Return-Path: <SRS0=Cdzf=R3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFE6C10F00
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 17:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9892147C
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 17:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b="SrWo8yFS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfCXR4g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 13:56:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44510 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfCXR4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 13:56:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id a3so4737515pff.11
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2019 10:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sKSai27DogAtl07WiZZ+59RbLKmNjaByrdzNStHGzes=;
        b=SrWo8yFSuP2YJ4l1btZudiZLi60dE8VqNnSDrA8jPVJose+ASSNqsOpZ1qE0RqdVdU
         NAeB6UHB0P0JALYutaJPVw7M9ssBUazoK/9AMW4IUHs+tCZbLXTuf7L3Ph8LpcwfLtQq
         4kFuGtEF1cs4gjxFnd7WdfhH7LaYR6hFS36TKdtOpK7jO1cqg4R2EXBDZ3Ec2qAux0Px
         pxcHTDz6jJTNRuQbtRa7qhSng46dAG8javmKpodtPd+jI7+egTpdrQEaOVvBzNqhh6tZ
         1mNi+fcCWxTK079Dw5zFNolAcdnR8bVPK/SgcC6KF2LuULXC86FtR8OQ+rPTzcBjv/AD
         j1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sKSai27DogAtl07WiZZ+59RbLKmNjaByrdzNStHGzes=;
        b=fW8TW4FJC+jidZiqYMIPSCJEVL6loeLJ+X3+UqZjdx1NbNVUDBs49kV4LLUdNd5Yj0
         TiEi3Ezv8htYnqrMsH7sUKOtGUNR491c4OLQEI3depqo825MxTgWYDwjfLzNBvYpza4h
         jvUoQq1UFEtq+RXZ1GlC8wxRxFTrODD/Zx44XlbonIP8njj5kzJIaw7IwK9ha8+tmflj
         GphJXTMG24S8fZyflJXi65DQJs3ht4VARwyTx4Kyun1s8wUcfIhX8LY+P8Zsj5BeyrR8
         RFOb2I/I0iWEV8RCNcFwAJchEK8KuXjLdVceSbBKtsMQtsC4EjX+V88/gGQet3zYcFyP
         46nA==
X-Gm-Message-State: APjAAAUzbxNG5+Rd2F31HfQHhGXmDbK65BScgQrd/tyRTy6HdGSq8HUk
        dSn41qY0ieFVTdgaU879VEVwNA==
X-Google-Smtp-Source: APXvYqz5VjXygqyB9bLSY3/hfXHNLSuqbaHxHqWSd6mv1ox+zyaYrgs0lUsi3oI0McAZpMw6PtBCaA==
X-Received: by 2002:a63:1003:: with SMTP id f3mr10618325pgl.227.1553450195060;
        Sun, 24 Mar 2019 10:56:35 -0700 (PDT)
Received: from localhost ([216.9.107.110])
        by smtp.gmail.com with ESMTPSA id k9sm26911067pfc.57.2019.03.24.10.56.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 24 Mar 2019 10:56:34 -0700 (PDT)
Date:   Sun, 24 Mar 2019 10:56:33 -0700
From:   Sandeep Patil <sspatil@android.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Chenbo Feng <fengc@google.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        kernel-team@android.com, Sumit Semwal <sumit.semwal@linaro.org>,
        erickreyes@google.com, Daniel Vetter <daniel@ffwll.ch>,
        john.stultz@linaro.org
Subject: Re: [RFC v2 1/3] dma-buf: give each buffer a full-fledged inode
Message-ID: <20190324175633.GA5826@google.com>
References: <20190322025135.118201-1-fengc@google.com>
 <20190322025135.118201-2-fengc@google.com>
 <20190322150255.GA76423@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322150255.GA76423@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 22, 2019 at 11:02:55AM -0400, Joel Fernandes wrote:
> On Thu, Mar 21, 2019 at 07:51:33PM -0700, Chenbo Feng wrote:
> > From: Greg Hackmann <ghackmann@google.com>
> > 
> > By traversing /proc/*/fd and /proc/*/map_files, processes with CAP_ADMIN
> > can get a lot of fine-grained data about how shmem buffers are shared
> > among processes.  stat(2) on each entry gives the caller a unique
> > ID (st_ino), the buffer's size (st_size), and even the number of pages
> > currently charged to the buffer (st_blocks / 512).
> > 
> > In contrast, all dma-bufs share the same anonymous inode.  So while we
> > can count how many dma-buf fds or mappings a process has, we can't get
> > the size of the backing buffers or tell if two entries point to the same
> > dma-buf.  On systems with debugfs, we can get a per-buffer breakdown of
> > size and reference count, but can't tell which processes are actually
> > holding the references to each buffer.
> > 
> > Replace the singleton inode with full-fledged inodes allocated by
> > alloc_anon_inode().  This involves creating and mounting a
> > mini-pseudo-filesystem for dma-buf, following the example in fs/aio.c.
> > 
> > Signed-off-by: Greg Hackmann <ghackmann@google.com>
> 
> I believe Greg's address needs to be updated on this patch otherwise the
> emails would just bounce, no? I removed it from the CC list. You can still
> keep the SOB I guess but remove it from the CC list when sending.
> 
> Also about the minifs, just playing devil's advocate for why this is needed.
> 
> Since you are already adding the size information to /proc/pid/fdinfo/<fd> ,
> can just that not be used to get the size of the buffer? What is the benefit
> of getting this from stat? The other way to get the size would be through
> another IOCTL and that can be used to return other unique-ness related metadata
> as well.  Neither of these need creation of a dedicated inode per dmabuf.

Can you give an example of "unique-ness related data" here? The inode seems
like the best fit cause its already unique, no?

> Imagine 1000s of dmabuf created in a system with rich graphics, then you have
> inode allocated per dmabuf, sounds wasteful to me if not needed.

It is, in fact, needed. The only way to differentiate a buffer owned by the
same process of the same size (which is very common) is via this unique
inode. Benefits of attaching the buffer metadata to the inode are that now
the metadata can be easily queried from userspace using stat(2) too.

> You are also
> adding the name per buffer, which can also be used to distinguish between
> different buffers if that's the issue.

The name is not unique, unless its decided by the kernel (which we don't want).
The names are coming in from user space in this case and are generally used
to track the "type / use case" of the buffer for debugging / triaging
purposes. We didn't want to rely on user space to give each buffer a unique
name, neither do we want to be responsible for generating one.

> 
> Also what is the benefit of having st_blocks from stat? AFAIK, that is the
> same as the buffer's size which does not change for the lifetime of the
> buffer. In your patch you're doing this when 'struct file' is created which
> AIUI is what reflects in the st_blocks:
> +	inode_set_bytes(inode, dmabuf->size);

Can some of the use cases / data be trimmed down? I think so. For example, I
never understood what we do with map_files here (or why). It is perfectly
fine to just get the data from /proc/<pid>/fd and /proc/<pid>/maps. I guess
the map_files bit is for consistency?

> 
> Note that creating a new mount and allocating inode for each buf will consume
> more kernel memory than before. Has there been a study of how much this is in
> reality? Like by running a game? This is the point of using
> anon_inode_getfile in the first place is to not have this wastage.

Its not "wastage" if its being used to track memeory IMHO. To give
some perspective, On Pixel 2 after fresh reboot + launch camera, we track
about 444 dmabuf objects with this that amounted to about 568573952
untracked memory. The cost of 444 'struct inode' compared to the 500+MB of
untrackable memory is miniscule.

May be, to make it generic, we make the tracking part optional somehow to
avoid the apparent wastage on other systems.

> 
> I am not against adding of inode per buffer, but I think we should have this
> debate and make the right design choice here for what we really need.

sure.

- ssp
> 
> thanks!
> 
>  - Joel
> 
> 
> > Signed-off-by: Chenbo Feng <fengc@google.com>
> > ---
> >  drivers/dma-buf/dma-buf.c  | 63 ++++++++++++++++++++++++++++++++++----
> >  include/uapi/linux/magic.h |  1 +
> >  2 files changed, 58 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 7c858020d14b..ffd5a2ad7d6f 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -34,8 +34,10 @@
> >  #include <linux/poll.h>
> >  #include <linux/reservation.h>
> >  #include <linux/mm.h>
> > +#include <linux/mount.h>
> >  
> >  #include <uapi/linux/dma-buf.h>
> > +#include <uapi/linux/magic.h>
> >  
> >  static inline int is_dma_buf_file(struct file *);
> >  
> > @@ -46,6 +48,25 @@ struct dma_buf_list {
> >  
> >  static struct dma_buf_list db_list;
> >  
> > +static const struct dentry_operations dma_buf_dentry_ops = {
> > +	.d_dname = simple_dname,
> > +};
> > +
> > +static struct vfsmount *dma_buf_mnt;
> > +
> > +static struct dentry *dma_buf_fs_mount(struct file_system_type *fs_type,
> > +		int flags, const char *name, void *data)
> > +{
> > +	return mount_pseudo(fs_type, "dmabuf:", NULL, &dma_buf_dentry_ops,
> > +			DMA_BUF_MAGIC);
> > +}
> > +
> > +static struct file_system_type dma_buf_fs_type = {
> > +	.name = "dmabuf",
> > +	.mount = dma_buf_fs_mount,
> > +	.kill_sb = kill_anon_super,
> > +};
> > +
> >  static int dma_buf_release(struct inode *inode, struct file *file)
> >  {
> >  	struct dma_buf *dmabuf;
> > @@ -338,6 +359,31 @@ static inline int is_dma_buf_file(struct file *file)
> >  	return file->f_op == &dma_buf_fops;
> >  }
> >  
> > +static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
> > +{
> > +	struct file *file;
> > +	struct inode *inode = alloc_anon_inode(dma_buf_mnt->mnt_sb);
> > +
> > +	if (IS_ERR(inode))
> > +		return ERR_CAST(inode);
> > +
> > +	inode->i_size = dmabuf->size;
> > +	inode_set_bytes(inode, dmabuf->size);
> > +
> > +	file = alloc_file_pseudo(inode, dma_buf_mnt, "dmabuf",
> > +				 flags, &dma_buf_fops);
> > +	if (IS_ERR(file))
> > +		goto err_alloc_file;
> > +	file->f_flags = flags & (O_ACCMODE | O_NONBLOCK);
> > +	file->private_data = dmabuf;
> > +
> > +	return file;
> > +
> > +err_alloc_file:
> > +	iput(inode);
> > +	return file;
> > +}
> > +
> >  /**
> >   * DOC: dma buf device access
> >   *
> > @@ -433,8 +479,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
> >  	}
> >  	dmabuf->resv = resv;
> >  
> > -	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf,
> > -					exp_info->flags);
> > +	file = dma_buf_getfile(dmabuf, exp_info->flags);
> >  	if (IS_ERR(file)) {
> >  		ret = PTR_ERR(file);
> >  		goto err_dmabuf;
> > @@ -1025,8 +1070,8 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
> >  		return ret;
> >  
> >  	seq_puts(s, "\nDma-buf Objects:\n");
> > -	seq_printf(s, "%-8s\t%-8s\t%-8s\t%-8s\texp_name\n",
> > -		   "size", "flags", "mode", "count");
> > +	seq_printf(s, "%-8s\t%-8s\t%-8s\t%-8s\texp_name\t%-8s\n",
> > +		   "size", "flags", "mode", "count", "ino");
> >  
> >  	list_for_each_entry(buf_obj, &db_list.head, list_node) {
> >  		ret = mutex_lock_interruptible(&buf_obj->lock);
> > @@ -1037,11 +1082,12 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
> >  			continue;
> >  		}
> >  
> > -		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\n",
> > +		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08lu\n",
> >  				buf_obj->size,
> >  				buf_obj->file->f_flags, buf_obj->file->f_mode,
> >  				file_count(buf_obj->file),
> > -				buf_obj->exp_name);
> > +				buf_obj->exp_name,
> > +				file_inode(buf_obj->file)->i_ino);
> >  
> >  		robj = buf_obj->resv;
> >  		while (true) {
> > @@ -1136,6 +1182,10 @@ static inline void dma_buf_uninit_debugfs(void)
> >  
> >  static int __init dma_buf_init(void)
> >  {
> > +	dma_buf_mnt = kern_mount(&dma_buf_fs_type);
> > +	if (IS_ERR(dma_buf_mnt))
> > +		return PTR_ERR(dma_buf_mnt);
> > +
> >  	mutex_init(&db_list.lock);
> >  	INIT_LIST_HEAD(&db_list.head);
> >  	dma_buf_init_debugfs();
> > @@ -1146,5 +1196,6 @@ subsys_initcall(dma_buf_init);
> >  static void __exit dma_buf_deinit(void)
> >  {
> >  	dma_buf_uninit_debugfs();
> > +	kern_unmount(dma_buf_mnt);
> >  }
> >  __exitcall(dma_buf_deinit);
> > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > index f8c00045d537..665e18627f78 100644
> > --- a/include/uapi/linux/magic.h
> > +++ b/include/uapi/linux/magic.h
> > @@ -91,5 +91,6 @@
> >  #define UDF_SUPER_MAGIC		0x15013346
> >  #define BALLOON_KVM_MAGIC	0x13661366
> >  #define ZSMALLOC_MAGIC		0x58295829
> > +#define DMA_BUF_MAGIC		0x444d4142	/* "DMAB" */
> >  
> >  #endif /* __LINUX_MAGIC_H__ */
> > -- 
> > 2.21.0.225.g810b269d1ac-goog
> > 
> 
> 
