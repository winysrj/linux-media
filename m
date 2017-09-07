Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:32909 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932287AbdIGSn2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:43:28 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Riley Andrews <riandrews@android.com>
Subject: [PATCH v3 14/15] fs/files: export close_fd() symbol
Date: Thu,  7 Sep 2017 15:42:25 -0300
Message-Id: <20170907184226.27482-15-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Rename __close_fd() to close_fd() and export it to be able close files
in modules using file descriptors.

The usecase that motivates this change happens in V4L2 where we send
events to userspace with a fd that has file installed in it. But if for
some reason we have to cancel the video stream we need to close the files
that haven't been shared with userspace yet. Thus the export of
close_fd() becomes necessary.

fd_install() happens when we call an ioctl to queue a buffer, but we only
share the fd with userspace later, and that may happen in a kernel thread
instead.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Riley Andrews <riandrews@android.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
This is more like a question, I don't know how unhappy people will be with
this proposal to expose close_fd(). I'm all ears for more interesting
ways of doing it!
---
 drivers/android/binder.c | 2 +-
 fs/file.c                | 5 +++--
 fs/open.c                | 2 +-
 include/linux/fdtable.h  | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index f7665c31feca..5a9bc73012df 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -440,7 +440,7 @@ static long task_close_fd(struct binder_proc *proc, unsigned int fd)
 	if (proc->files == NULL)
 		return -ESRCH;
 
-	retval = __close_fd(proc->files, fd);
+	retval = close_fd(proc->files, fd);
 	/* can't restart close syscall because file table entry was cleared */
 	if (unlikely(retval == -ERESTARTSYS ||
 		     retval == -ERESTARTNOINTR ||
diff --git a/fs/file.c b/fs/file.c
index 1fc7fbbb4510..111d387ac190 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -618,7 +618,7 @@ EXPORT_SYMBOL(fd_install);
 /*
  * The same warnings as for __alloc_fd()/__fd_install() apply here...
  */
-int __close_fd(struct files_struct *files, unsigned fd)
+int close_fd(struct files_struct *files, unsigned fd)
 {
 	struct file *file;
 	struct fdtable *fdt;
@@ -640,6 +640,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
 	spin_unlock(&files->file_lock);
 	return -EBADF;
 }
+EXPORT_SYMBOL(close_fd);
 
 void do_close_on_exec(struct files_struct *files)
 {
@@ -856,7 +857,7 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
 	struct files_struct *files = current->files;
 
 	if (!file)
-		return __close_fd(files, fd);
+		return close_fd(files, fd);
 
 	if (fd >= rlimit(RLIMIT_NOFILE))
 		return -EBADF;
diff --git a/fs/open.c b/fs/open.c
index 35bb784763a4..30907d967443 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1152,7 +1152,7 @@ EXPORT_SYMBOL(filp_close);
  */
 SYSCALL_DEFINE1(close, unsigned int, fd)
 {
-	int retval = __close_fd(current->files, fd);
+	int retval = close_fd(current->files, fd);
 
 	/* can't restart close syscall because file table entry was cleared */
 	if (unlikely(retval == -ERESTARTSYS ||
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 6e84b2cae6ad..511fd38d5e4b 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -115,7 +115,7 @@ extern int __alloc_fd(struct files_struct *files,
 		      unsigned start, unsigned end, unsigned flags);
 extern void __fd_install(struct files_struct *files,
 		      unsigned int fd, struct file *file);
-extern int __close_fd(struct files_struct *files,
+extern int close_fd(struct files_struct *files,
 		      unsigned int fd);
 
 extern struct kmem_cache *files_cachep;
-- 
2.13.5
