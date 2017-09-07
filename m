Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49862 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755546AbdIGWJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 18:09:30 -0400
Subject: Re: [PATCH v3 14/15] fs/files: export close_fd() symbol
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Riley Andrews <riandrews@android.com>
References: <20170907184226.27482-1-gustavo@padovan.org>
 <20170907184226.27482-15-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <73f8820e-216b-5d7e-87e7-7a8b90bfb0d2@xs4all.nl>
Date: Fri, 8 Sep 2017 00:09:23 +0200
MIME-Version: 1.0
In-Reply-To: <20170907184226.27482-15-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2017 08:42 PM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Rename __close_fd() to close_fd() and export it to be able close files
> in modules using file descriptors.
> 
> The usecase that motivates this change happens in V4L2 where we send
> events to userspace with a fd that has file installed in it. But if for
> some reason we have to cancel the video stream we need to close the files
> that haven't been shared with userspace yet. Thus the export of
> close_fd() becomes necessary.
> 
> fd_install() happens when we call an ioctl to queue a buffer, but we only
> share the fd with userspace later, and that may happen in a kernel thread
> instead.

This isn't the way to do this.

You should only create the out fence file descriptor when userspace dequeues
(i.e. calls VIDIOC_DQEVENT) the BUF_QUEUED event. That's when you give it to
userspace and at that moment closing the fd is the responsibility of userspace.
There is no point creating it earlier anyway since userspace can't get to it
until it dequeues the event.

It does mean some more work in the V4L2 core since you need to hook into the
DQEVENT code in order to do this.

Regards,

	Hans

> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Riley Andrews <riandrews@android.com>
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
> This is more like a question, I don't know how unhappy people will be with
> this proposal to expose close_fd(). I'm all ears for more interesting
> ways of doing it!
> ---
>  drivers/android/binder.c | 2 +-
>  fs/file.c                | 5 +++--
>  fs/open.c                | 2 +-
>  include/linux/fdtable.h  | 2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index f7665c31feca..5a9bc73012df 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -440,7 +440,7 @@ static long task_close_fd(struct binder_proc *proc, unsigned int fd)
>  	if (proc->files == NULL)
>  		return -ESRCH;
>  
> -	retval = __close_fd(proc->files, fd);
> +	retval = close_fd(proc->files, fd);
>  	/* can't restart close syscall because file table entry was cleared */
>  	if (unlikely(retval == -ERESTARTSYS ||
>  		     retval == -ERESTARTNOINTR ||
> diff --git a/fs/file.c b/fs/file.c
> index 1fc7fbbb4510..111d387ac190 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -618,7 +618,7 @@ EXPORT_SYMBOL(fd_install);
>  /*
>   * The same warnings as for __alloc_fd()/__fd_install() apply here...
>   */
> -int __close_fd(struct files_struct *files, unsigned fd)
> +int close_fd(struct files_struct *files, unsigned fd)
>  {
>  	struct file *file;
>  	struct fdtable *fdt;
> @@ -640,6 +640,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
>  	spin_unlock(&files->file_lock);
>  	return -EBADF;
>  }
> +EXPORT_SYMBOL(close_fd);
>  
>  void do_close_on_exec(struct files_struct *files)
>  {
> @@ -856,7 +857,7 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  	struct files_struct *files = current->files;
>  
>  	if (!file)
> -		return __close_fd(files, fd);
> +		return close_fd(files, fd);
>  
>  	if (fd >= rlimit(RLIMIT_NOFILE))
>  		return -EBADF;
> diff --git a/fs/open.c b/fs/open.c
> index 35bb784763a4..30907d967443 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -1152,7 +1152,7 @@ EXPORT_SYMBOL(filp_close);
>   */
>  SYSCALL_DEFINE1(close, unsigned int, fd)
>  {
> -	int retval = __close_fd(current->files, fd);
> +	int retval = close_fd(current->files, fd);
>  
>  	/* can't restart close syscall because file table entry was cleared */
>  	if (unlikely(retval == -ERESTARTSYS ||
> diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
> index 6e84b2cae6ad..511fd38d5e4b 100644
> --- a/include/linux/fdtable.h
> +++ b/include/linux/fdtable.h
> @@ -115,7 +115,7 @@ extern int __alloc_fd(struct files_struct *files,
>  		      unsigned start, unsigned end, unsigned flags);
>  extern void __fd_install(struct files_struct *files,
>  		      unsigned int fd, struct file *file);
> -extern int __close_fd(struct files_struct *files,
> +extern int close_fd(struct files_struct *files,
>  		      unsigned int fd);
>  
>  extern struct kmem_cache *files_cachep;
> 
