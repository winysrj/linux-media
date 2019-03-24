Return-Path: <SRS0=Cdzf=R3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5DDC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 20:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2048120828
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 20:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="o8evAxgR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfCXUo5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 16:44:57 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43996 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfCXUo5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 16:44:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id c8so4878549pfd.10
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2019 13:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bWvaytEUM3kLAW5DAIdkruFHQuKgrjcIk5gdVDJ8hdU=;
        b=o8evAxgRWTQNEhO5+8hjzA3o12J34EsasR1HURXgY9vzEWopXR6guptAnOGcrRHXHH
         Jx1EFVjhAcVrOT7WDKnlUhQRb06LhsddBqdapXfOcrz6xJnx0ScMZBRvFeLJU5IVr2NP
         AXDJZm+19wo+1HW+TD1AC3hHkD1S9QD6Kt/uw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bWvaytEUM3kLAW5DAIdkruFHQuKgrjcIk5gdVDJ8hdU=;
        b=ex+OcbOJcx5RkkxR51l/VirFGwYJgaVswQfg79GW66eG9P4KKF4c5VFjz16aOaWsMU
         Td23oZw/vBGUoDm3CaoQdLmqToBajJBrMWRiu9hqW5KYv+atwSCqSzrGeo4bpT7+gUVB
         AkJxdLuHeoWDBB0xSPN+730+HiDeUa6lF2Nc3wZfqP1htbBq/OqAv0wBCCYj/9F0zM+d
         sO1mXRwY/aHjBIN+r3N3+MPqCShM3sxOdFunymPUtGoMAS23KMkpc90pXY4PE9tIolAi
         RouZODl9FRqkXMW4/HcD0LO/A0LwOgw8TdgIL2P65c3Epuidt+t15WyhoufkKUAEmLrP
         FpTg==
X-Gm-Message-State: APjAAAWwiwURRkLsFLy06w4U0gLQNjt8B9gojbkM+wd5Y1+ubp6ZWVq+
        CixSt+gpUI3zFpufqURMEcjr6g==
X-Google-Smtp-Source: APXvYqxWwopTgTh11r2ATA+Z92WleBbtLCTT9gbCIDCUsYKYkHixfBt8gTM/njplM39zHc+yXf47qg==
X-Received: by 2002:a62:1ac3:: with SMTP id a186mr20345922pfa.48.1553460296340;
        Sun, 24 Mar 2019 13:44:56 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id b133sm17647812pfb.62.2019.03.24.13.44.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 24 Mar 2019 13:44:55 -0700 (PDT)
Date:   Sun, 24 Mar 2019 16:44:54 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Sandeep Patil <sspatil@android.com>
Cc:     Chenbo Feng <fengc@google.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        kernel-team@android.com, Sumit Semwal <sumit.semwal@linaro.org>,
        erickreyes@google.com, Daniel Vetter <daniel@ffwll.ch>,
        john.stultz@linaro.org
Subject: Re: [RFC v2 1/3] dma-buf: give each buffer a full-fledged inode
Message-ID: <20190324204454.GA102207@google.com>
References: <20190322025135.118201-1-fengc@google.com>
 <20190322025135.118201-2-fengc@google.com>
 <20190322150255.GA76423@google.com>
 <20190324175633.GA5826@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190324175633.GA5826@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sandeep,

On Sun, Mar 24, 2019 at 10:56:33AM -0700, Sandeep Patil wrote:
> On Fri, Mar 22, 2019 at 11:02:55AM -0400, Joel Fernandes wrote:
> > On Thu, Mar 21, 2019 at 07:51:33PM -0700, Chenbo Feng wrote:
> > > From: Greg Hackmann <ghackmann@google.com>
> > > 
> > > By traversing /proc/*/fd and /proc/*/map_files, processes with CAP_ADMIN
> > > can get a lot of fine-grained data about how shmem buffers are shared
> > > among processes.  stat(2) on each entry gives the caller a unique
> > > ID (st_ino), the buffer's size (st_size), and even the number of pages
> > > currently charged to the buffer (st_blocks / 512).
> > > 
> > > In contrast, all dma-bufs share the same anonymous inode.  So while we
> > > can count how many dma-buf fds or mappings a process has, we can't get
> > > the size of the backing buffers or tell if two entries point to the same
> > > dma-buf.  On systems with debugfs, we can get a per-buffer breakdown of
> > > size and reference count, but can't tell which processes are actually
> > > holding the references to each buffer.
> > > 
> > > Replace the singleton inode with full-fledged inodes allocated by
> > > alloc_anon_inode().  This involves creating and mounting a
> > > mini-pseudo-filesystem for dma-buf, following the example in fs/aio.c.
> > > 
> > > Signed-off-by: Greg Hackmann <ghackmann@google.com>
> > 
> > I believe Greg's address needs to be updated on this patch otherwise the
> > emails would just bounce, no? I removed it from the CC list. You can still
> > keep the SOB I guess but remove it from the CC list when sending.
> > 
> > Also about the minifs, just playing devil's advocate for why this is needed.
> > 
> > Since you are already adding the size information to /proc/pid/fdinfo/<fd> ,
> > can just that not be used to get the size of the buffer? What is the benefit
> > of getting this from stat? The other way to get the size would be through
> > another IOCTL and that can be used to return other unique-ness related metadata
> > as well.  Neither of these need creation of a dedicated inode per dmabuf.
> 
> Can you give an example of "unique-ness related data" here? The inode seems
> like the best fit cause its already unique, no?

I was thinking dma_buf file pointer, but I agree we need the per-inode now (see below).

> > Also what is the benefit of having st_blocks from stat? AFAIK, that is the
> > same as the buffer's size which does not change for the lifetime of the
> > buffer. In your patch you're doing this when 'struct file' is created which
> > AIUI is what reflects in the st_blocks:
> > +	inode_set_bytes(inode, dmabuf->size);
> 
> Can some of the use cases / data be trimmed down? I think so. For example, I
> never understood what we do with map_files here (or why). It is perfectly
> fine to just get the data from /proc/<pid>/fd and /proc/<pid>/maps. I guess
> the map_files bit is for consistency?

It just occured to me that since /proc/<pid/maps provides an inode number as
one of the fields, so indeed an inode per buf is a very good idea for the
user to distinguish buffers just by reading /proc/<pid/<maps> alone..

I also, similar to you, don't think map_files is useful for this usecase.
map_files are just symlinks named as memory ranges and pointing to a file. In
this case the symlink will point to default name "dmabuf" that doesn't exist.
If one does stat(2) on a map_file link, then it just returns the inode number
of the symlink, not what the map_file is pointing to, which seems kind of
useless.

Which makes me think both maps and map_files can be made more useful if we can
also make DMA_BUF_SET_NAME in the patch change the underlying dentry's name
from the default "dmabuf" to "dmabuf:<name>" ?

That would be useful because:
1. It should make /proc/pid/maps also have the name than always showing
"dmabuf".
2. It should make map_files also point to the name of the buffer than just
"dmabuf". Note that memfd_create(2) already takes a name and the maps_file
for this points to the name of the buffer created and showing it in both maps
and map_files.

I think this also removes the need for DMA_BUF_GET_NAME ioctl since the
dentry's name already has the information. I can try to look into that...
BTW any case we should not need GET_NAME ioctl since fdinfo already has the
name after SET_NAME is called. So let us drop that API?

> May be, to make it generic, we make the tracking part optional somehow to
> avoid the apparent wastage on other systems.

Yes, that's also fine. But I think if we can bake tracking into existing
mechanism and keep it always On, then that's also good for all other dmabuf
users as well and simplifies the kernel configuration for vendors.

> > I am not against adding of inode per buffer, but I think we should have this
> > debate and make the right design choice here for what we really need.
> 
> sure.

Right, so just to summarize:
- The intention here is /proc/<pid>/maps will give uniqueness (via the inode
  number) between different memory ranges. That I think is the main benefit
  of the patch.
- stat gives the size of buffer as does fdinfo
- fdinfo is useful to get the reference count of number of sharers of the
  buffer.
- map_files is not that useful for this usecase but can be made useful if
  we can name the underlying file's dentry to something other than "dmabuf".
- GET_NAME is not needed since fdinfo already has the SET_NAMEd name.

Do you agree?

Just to lay it out, there is a cost to unique inode. Each struct inode is 560
bytes on mainline with x86_64_defconfig. With 1000 buffers, we're looking at
~ 0.5MB of allocation. However I think I am convinced we need to do it
considering the advantages, and the size is trivial considering advantages.
Arguably large number dmabuf allocations are more likely to succeed with
devices with larger memory resources anyway :)

It is good to have this discussion. 

thanks,

 - Joel

