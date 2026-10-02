try {
  const port = process.env.PORT || '4183';
  const response = await fetch(`http://127.0.0.1:${port}/api/health`, {
    signal: AbortSignal.timeout(3000),
  });
  const health = await response.json();
  if (!response.ok || health.ok !== true) process.exit(1);
} catch {
  process.exit(1);
}
