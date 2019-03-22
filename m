Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824ACC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 15:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F894218B0
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 15:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="Yk8e6b8X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfCVPC6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:02:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40016 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbfCVPC6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 11:02:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id u9so1702902pgo.7
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 08:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zQZIX94KhgrzzQy0XH8WNm8hwMfg9eekiUa1F30FQEM=;
        b=Yk8e6b8XfCtm+9DHP5b/vOx7ex9d6ShGqSZCYUVXZ3XqDM2SWe3qgyUCqBL9eSgI3l
         qhjlH7Ao0E+2EF0AAbKu3aqIFqllORTbhGxrFpfgkFymEQyWFbWVciqPMmJGpvn3vnq3
         otbXmPEk/Y1zh8jfbf5wz2SxA5opQRypw6q3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zQZIX94KhgrzzQy0XH8WNm8hwMfg9eekiUa1F30FQEM=;
        b=Tlcex1VmYmHTLbNHDLVAyVpcFmKtcUeFt9cA+UhimYVLSpkrpreGu6gqWTOF0D0Vg9
         4BAGaHTuQRuyQLna9KHh/VyL3slUOkGQTHPT0sHmYI7ep4vCBFtH05CwcLtCFJKh1fue
         gKCPRRCxxZeB0DUtZw3zH/htRs0zN2NnRLnYMrDdH0EXXWHmU8gIcgcCZ2scAeJdhqTf
         TmCybPxDGQ+nt7Q8xZhzVzdj05xYtI+pOBl+Pb76Id+IHHvTgcIiUX/VMjrE3WcMSmEa
         IdsMHny/VGhhY2LHC2D8FsrA3QsMpXns2Mib6V0aaKSEXrcoUu03GvHamVtDr5DRlQi/
         Vszw==
X-Gm-Message-State: APjAAAXJSINZci6f77RL80NJogSJZs7A8KCyt0fjWdkaHCBYf9WirHgP
        /d859cw/BBGcjNMxa2g41o5MbA==
X-Google-Smtp-Source: APXvYqxVP5r5sGdws3sd/6gS3osqnlR5el+wi0N9nbxguzT0d6ob6bacu7wJNElIW7g29DtPtT3Jyg==
X-Received: by 2002:a17:902:7e0f:: with SMTP id b15mr9500127plm.124.1553266977681;
        Fri, 22 Mar 2019 08:02:57 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id b18sm9582893pff.25.2019.03.22.08.02.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 08:02:56 -0700 (PDT)
Date:   Fri, 22 Mar 2019 11:02:55 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Chenbo Feng <fengc@google.com>
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, kernel-team@android.com,
        Sumit Semwal <sumit.semwal@linaro.org>, erickreyes@google.com,
        Daniel Vetter <daniel@ffwll.ch>, john.stultz@linaro.org
Subject: Re: [RFC v2 1/3] dma-buf: give each buffer a full-fledged inode
Message-ID: <20190322150255.GA76423@google.com>
References: <20190322025135.118201-1-fengc@google.com>
 <20190322025135.118201-2-fengc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322025135.118201-2-fengc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 21, 2019 at 07:51:33PM -0700, Chenbo Feng wrote:
> From: Greg Hackmann <ghackmann@google.com>
> 
> By traversing /proc/*/fd and /proc/*/map_files, processes with CAP_ADMIN
> can get a lot of fine-grained data about how shmem buffers are shared
> among processes.  stat(2) on each entry gives the caller a unique
> ID (st_ino), the buffer's size (st_size), and even the number of pages
> currently charged to the buffer (st_blocks / 512).
> 
> In contrast, all dma-bufs share the same anonymous inode.  So while we
> can count how many dma-buf fds or mappings a process has, we can't get
> the size of the backing buffers or tell if two entries point to the same
> dma-buf.  On systems with debugfs, we can get a per-buffer breakdown of
> size and reference count, but can't tell which processes are actually
> holding the references to each buffer.
> 
> Replace the singleton inode with full-fledged inodes allocated by
> alloc_anon_inode().  This involves creating and mounting a
> mini-pseudo-filesystem for dma-buf, following the example in fs/aio.c.
> 
> Signed-off-by: Greg Hackmann <ghackmann@google.com>

I believe Greg's address needs to be updated on this patch otherwise the
emails would just bounce, no? I removed it from the CC list. You can still
keep the SOB I guess but remove it from the CC list when sending.

Also about the minifs, just playing devil's advocate for why this is needed.

Since you are already adding the size information to /proc/pid/fdinfo/<fd> ,
can just that not be used to get the size of the buffer? What is the benefit
of getting this from stat? The other way to get the size would be through
another IOCTL and that can be used to return other unique-ness related metadata
as well.  Neither of these need creation of a dedicated inode per dmabuf.
Imagine 1000s of dmabuf created in a system with rich graphics, then you have
inode allocated per dmabuf, sounds wasteful to me if not needed. You are also
adding the name per buffer, which can also be used to distinguish between
different buffers if that's the issue.

Also what is the benefit of having st_blocks from stat? AFAIK, that is the
same as the buffer's size which does not change for the lifetime of the
buffer. In your patch you're doing this when 'struct file' is created which
AIUI is what reflects in the st_blocks:
+	inode_set_bytes(inode, dmabuf->size);

Note that creating a new mount and allocating inode for each buf will consume
more kernel memory than before. Has there been a study of how much this is in
reality? Like by running a game? This is the point of using
anon_inode_getfile in the first place is to not have this wastage.

I am not against adding of inode per buffer, but I think we should have this
debate and make the right design choice here for what we really need.

thanks!

 - Joel


> Signed-off-by: Chenbo Feng <fengc@google.com>
> ---
>  drivers/dma-buf/dma-buf.c  | 63 ++++++++++++++++++++++++++++++++++----
>  include/uapi/linux/magic.h |  1 +
>  2 files changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 7c858020d14b..ffd5a2ad7d6f 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -34,8 +34,10 @@
>  #include <linux/poll.h>
>  #include <linux/reservation.h>
>  #include <linux/mm.h>
> +#include <linux/mount.h>
>  
>  #include <uapi/linux/dma-buf.h>
> +#include <uapi/linux/magic.h>
>  
>  static inline int is_dma_buf_file(struct file *);
>  
> @@ -46,6 +48,25 @@ struct dma_buf_list {
>  
>  static struct dma_buf_list db_list;
>  
> +static const struct dentry_operations dma_buf_dentry_ops = {
> +	.d_dname = simple_dname,
> +};
> +
> +static struct vfsmount *dma_buf_mnt;
> +
> +static struct dentry *dma_buf_fs_mount(struct file_system_type *fs_type,
> +		int flags, const char *name, void *data)
> +{
> +	return mount_pseudo(fs_type, "dmabuf:", NULL, &dma_buf_dentry_ops,
> +			DMA_BUF_MAGIC);
> +}
> +
> +static struct file_system_type dma_buf_fs_type = {
> +	.name = "dmabuf",
> +	.mount = dma_buf_fs_mount,
> +	.kill_sb = kill_anon_super,
> +};
> +
>  static int dma_buf_release(struct inode *inode, struct file *file)
>  {
>  	struct dma_buf *dmabuf;
> @@ -338,6 +359,31 @@ static inline int is_dma_buf_file(struct file *file)
>  	return file->f_op == &dma_buf_fops;
>  }
>  
> +static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
> +{
> +	struct file *file;
> +	struct inode *inode = alloc_anon_inode(dma_buf_mnt->mnt_sb);
> +
> +	if (IS_ERR(inode))
> +		return ERR_CAST(inode);
> +
> +	inode->i_size = dmabuf->size;
> +	inode_set_bytes(inode, dmabuf->size);
> +
> +	file = alloc_file_pseudo(inode, dma_buf_mnt, "dmabuf",
> +				 flags, &dma_buf_fops);
> +	if (IS_ERR(file))
> +		goto err_alloc_file;
> +	file->f_flags = flags & (O_ACCMODE | O_NONBLOCK);
> +	file->private_data = dmabuf;
> +
> +	return file;
> +
> +err_alloc_file:
> +	iput(inode);
> +	return file;
> +}
> +
>  /**
>   * DOC: dma buf device access
>   *
> @@ -433,8 +479,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  	}
>  	dmabuf->resv = resv;
>  
> -	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf,
> -					exp_info->flags);
> +	file = dma_buf_getfile(dmabuf, exp_info->flags);
>  	if (IS_ERR(file)) {
>  		ret = PTR_ERR(file);
>  		goto err_dmabuf;
> @@ -1025,8 +1070,8 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>  		return ret;
>  
>  	seq_puts(s, "\nDma-buf Objects:\n");
> -	seq_printf(s, "%-8s\t%-8s\t%-8s\t%-8s\texp_name\n",
> -		   "size", "flags", "mode", "count");
> +	seq_printf(s, "%-8s\t%-8s\t%-8s\t%-8s\texp_name\t%-8s\n",
> +		   "size", "flags", "mode", "count", "ino");
>  
>  	list_for_each_entry(buf_obj, &db_list.head, list_node) {
>  		ret = mutex_lock_interruptible(&buf_obj->lock);
> @@ -1037,11 +1082,12 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>  			continue;
>  		}
>  
> -		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\n",
> +		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08lu\n",
>  				buf_obj->size,
>  				buf_obj->file->f_flags, buf_obj->file->f_mode,
>  				file_count(buf_obj->file),
> -				buf_obj->exp_name);
> +				buf_obj->exp_name,
> +				file_inode(buf_obj->file)->i_ino);
>  
>  		robj = buf_obj->resv;
>  		while (true) {
> @@ -1136,6 +1182,10 @@ static inline void dma_buf_uninit_debugfs(void)
>  
>  static int __init dma_buf_init(void)
>  {
> +	dma_buf_mnt = kern_mount(&dma_buf_fs_type);
> +	if (IS_ERR(dma_buf_mnt))
> +		return PTR_ERR(dma_buf_mnt);
> +
>  	mutex_init(&db_list.lock);
>  	INIT_LIST_HEAD(&db_list.head);
>  	dma_buf_init_debugfs();
> @@ -1146,5 +1196,6 @@ subsys_initcall(dma_buf_init);
>  static void __exit dma_buf_deinit(void)
>  {
>  	dma_buf_uninit_debugfs();
> +	kern_unmount(dma_buf_mnt);
>  }
>  __exitcall(dma_buf_deinit);
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index f8c00045d537..665e18627f78 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -91,5 +91,6 @@
>  #define UDF_SUPER_MAGIC		0x15013346
>  #define BALLOON_KVM_MAGIC	0x13661366
>  #define ZSMALLOC_MAGIC		0x58295829
> +#define DMA_BUF_MAGIC		0x444d4142	/* "DMAB" */
>  
>  #endif /* __LINUX_MAGIC_H__ */
> -- 
> 2.21.0.225.g810b269d1ac-goog
> 
