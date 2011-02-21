Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48487 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BUKVC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 05:21:02 -0500
From: David Cohen <dacohen@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, David Cohen <dacohen@gmail.com>
Subject: [PATCH 1/1] headers: fix circular dependency between linux/sched.h and linux/wait.h
Date: Mon, 21 Feb 2011 12:20:49 +0200
Message-Id: <1298283649-24532-2-git-send-email-dacohen@gmail.com>
In-Reply-To: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently sched.h and wait.h have circular dependency between both.
wait.h defines macros wake_up*() which use macros TASK_* defined by
sched.h. But as sched.h indirectly includes wait.h, such wait.h header
file can't include sched.h too. The side effect is when some file
includes wait.h and tries to use its wake_up*() macros, it's necessary
to include sched.h also.
This patch moves all TASK_* macros from linux/sched.h to a new header
file linux/task_sched.h. This way, both sched.h and wait.h can include
task_sched.h and fix the circular dependency. No need to include sched.h
anymore when wake_up*() macros are used.

Signed-off-by: David Cohen <dacohen@gmail.com>
---
 include/linux/sched.h      |   61 +-----------------------------------------
 include/linux/task_sched.h |   64 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/wait.h       |    1 +
 3 files changed, 66 insertions(+), 60 deletions(-)
 create mode 100644 include/linux/task_sched.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..c60dcee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -90,6 +90,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
+#include <linux/task_sched.h>
 
 #include <asm/processor.h>
 
@@ -169,63 +170,6 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #endif
 
 /*
- * Task state bitmask. NOTE! These bits are also
- * encoded in fs/proc/array.c: get_task_state().
- *
- * We have two separate sets of flags: task->state
- * is about runnability, while task->exit_state are
- * about the task exiting. Confusing, but this way
- * modifying one set can't modify the other one by
- * mistake.
- */
-#define TASK_RUNNING		0
-#define TASK_INTERRUPTIBLE	1
-#define TASK_UNINTERRUPTIBLE	2
-#define __TASK_STOPPED		4
-#define __TASK_TRACED		8
-/* in tsk->exit_state */
-#define EXIT_ZOMBIE		16
-#define EXIT_DEAD		32
-/* in tsk->state again */
-#define TASK_DEAD		64
-#define TASK_WAKEKILL		128
-#define TASK_WAKING		256
-#define TASK_STATE_MAX		512
-
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
-
-extern char ___assert_task_state[1 - 2*!!(
-		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
-
-/* Convenience macros for the sake of set_task_state */
-#define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
-#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
-#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
-
-/* Convenience macros for the sake of wake_up */
-#define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
-#define TASK_ALL		(TASK_NORMAL | __TASK_STOPPED | __TASK_TRACED)
-
-/* get_task_state() */
-#define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
-				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
-				 __TASK_TRACED)
-
-#define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
-#define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
-#define task_is_dead(task)	((task)->exit_state != 0)
-#define task_is_stopped_or_traced(task)	\
-			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
-#define task_contributes_to_load(task)	\
-				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
-				 (task->flags & PF_FREEZING) == 0)
-
-#define __set_task_state(tsk, state_value)		\
-	do { (tsk)->state = (state_value); } while (0)
-#define set_task_state(tsk, state_value)		\
-	set_mb((tsk)->state, (state_value))
-
-/*
  * set_current_state() includes a barrier so that the write of current->state
  * is correctly serialised wrt the caller's subsequent test of whether to
  * actually sleep:
@@ -241,9 +185,6 @@ extern char ___assert_task_state[1 - 2*!!(
 #define set_current_state(state_value)		\
 	set_mb(current->state, (state_value))
 
-/* Task command name length */
-#define TASK_COMM_LEN 16
-
 #include <linux/spinlock.h>
 
 /*
diff --git a/include/linux/task_sched.h b/include/linux/task_sched.h
new file mode 100644
index 0000000..3787387
--- /dev/null
+++ b/include/linux/task_sched.h
@@ -0,0 +1,64 @@
+#ifndef _LINUX_TASK_H
+#define _LINUX_TASK_H
+
+/*
+ * Task state bitmask. NOTE! These bits are also
+ * encoded in fs/proc/array.c: get_task_state().
+ *
+ * We have two separate sets of flags: task->state
+ * is about runnability, while task->exit_state are
+ * about the task exiting. Confusing, but this way
+ * modifying one set can't modify the other one by
+ * mistake.
+ */
+#define TASK_RUNNING		0
+#define TASK_INTERRUPTIBLE	1
+#define TASK_UNINTERRUPTIBLE	2
+#define __TASK_STOPPED		4
+#define __TASK_TRACED		8
+/* in tsk->exit_state */
+#define EXIT_ZOMBIE		16
+#define EXIT_DEAD		32
+/* in tsk->state again */
+#define TASK_DEAD		64
+#define TASK_WAKEKILL		128
+#define TASK_WAKING		256
+#define TASK_STATE_MAX		512
+
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+
+extern char ___assert_task_state[1 - 2*!!(
+		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
+
+/* Convenience macros for the sake of set_task_state */
+#define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
+#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
+#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
+
+/* Convenience macros for the sake of wake_up */
+#define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
+#define TASK_ALL		(TASK_NORMAL | __TASK_STOPPED | __TASK_TRACED)
+
+/* get_task_state() */
+#define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
+				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
+				 __TASK_TRACED)
+
+#define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
+#define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
+#define task_is_dead(task)	((task)->exit_state != 0)
+#define task_is_stopped_or_traced(task)	\
+			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
+#define task_contributes_to_load(task)	\
+				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
+				 (task->flags & PF_FREEZING) == 0)
+
+#define __set_task_state(tsk, state_value)		\
+	do { (tsk)->state = (state_value); } while (0)
+#define set_task_state(tsk, state_value)		\
+	set_mb((tsk)->state, (state_value))
+
+/* Task command name length */
+#define TASK_COMM_LEN 16
+
+#endif
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3efc9f3..cccfdd2 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -22,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
+#include <linux/task_sched.h>
 #include <asm/system.h>
 #include <asm/current.h>
 
-- 
1.7.1

