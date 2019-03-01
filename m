Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B1CC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30C5218B0
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:55:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="EgI6t+UO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbfCAIzK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:55:10 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44030 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfCAIzJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 03:55:09 -0500
Received: by mail-ed1-f67.google.com with SMTP id m35so19310475ede.10
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2019 00:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6JSj88hu2XntZH+r/9g9XYQars3muYppbN70BI4AiSM=;
        b=EgI6t+UOodnsmhx5WYqEuMC1u7kkC44U30Dcdzcj24sqj0zU2mEjjjo6AjYaGVM73V
         XsiqV3F7zVOZXRO93ZrJizFLf08JssaxOB+hFoUSc0+xgSnPete42XEvWw1uPoBd0dN/
         TjUtGX27SFyfaL2R3rgR2HZTUPeHRGnCRAmz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=6JSj88hu2XntZH+r/9g9XYQars3muYppbN70BI4AiSM=;
        b=XTF6JmvDburRWn40bHChUDmPwG7PjgfYBbJnUTvZHAwys81e8ot8dC3Jg2JM96mx+o
         fohD3UCRocNqGr/fkCEDS+QPvxm0zBXUzPQdl6RBxFeydRaHkltguWwkl25BM650CB9K
         6e7wAzIUzSAj/QqaLb3rdNazPtsvohLVrQ6ksObarTtlYErzrMf0Xpj/dF7MyGlDIDE9
         DIZWmBNPTCWZiLvP7rBerXoI/ujpENdLrEIUwCbR1b9JKwK5UADc0TAta/q+8HSkpAka
         BxHaowBWwmSl5CdBcWoiL88s42Qk+/sgvamEgoY4qUcjKcYsW111T4mvlsw9U7L6VMO1
         3z3Q==
X-Gm-Message-State: APjAAAWbfFHVMzvovVinzaMsjMHLI0DJEfSezrD2L534ROAzyS6NUkDN
        XFXPaq7B7BthVk/U83AFJQLvrA==
X-Google-Smtp-Source: APXvYqwpKe4onHsyeu8lzM1whULTPhJ0l7teuN5TnDSTMEdUeUexIv2Rcp0Ei7uUDUwWyl0mpxNFPg==
X-Received: by 2002:a50:b4e6:: with SMTP id x35mr3248822edd.123.1551430507212;
        Fri, 01 Mar 2019 00:55:07 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id a58sm5810068eda.91.2019.03.01.00.55.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 00:55:05 -0800 (PST)
Date:   Fri, 1 Mar 2019 09:55:03 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Hyun Kwon <hyun.kwon@xilinx.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Hyun Kwon <hyunk@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefano Stabellini <stefanos@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Michal Simek <michals@xilinx.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 1/1] uio: Add dma-buf import ioctls
Message-ID: <20190301085503.GV2665@phenom.ffwll.local>
Mail-Followup-To: Hyun Kwon <hyun.kwon@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefano Stabellini <stefanos@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" <linaro-mm-sig@lists.linaro.org>,
        Michal Simek <michals@xilinx.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" <linux-media@vger.kernel.org>
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
 <20190226115311.GA4094@kroah.com>
 <CAKMK7uE=dSyo5vdjtQf=k1rdoegiBgSozCOotXLSW2VAkz2Ldw@mail.gmail.com>
 <20190226221817.GB10631@smtp.xilinx.com>
 <CAKMK7uFay0mjHFhQqmQ7fneS2B0xNW_Nv4AWqp-FK1NnHVe5uw@mail.gmail.com>
 <20190228003606.GA1063@smtp.xilinx.com>
 <20190228100146.GK2665@phenom.ffwll.local>
 <20190301001856.GA20971@smtp.xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301001856.GA20971@smtp.xilinx.com>
X-Operating-System: Linux phenom 4.19.0-1-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 28, 2019 at 04:18:57PM -0800, Hyun Kwon wrote:
> Hi Daniel,
> 
> On Thu, 2019-02-28 at 02:01:46 -0800, Daniel Vetter wrote:
> > On Wed, Feb 27, 2019 at 04:36:06PM -0800, Hyun Kwon wrote:
> > > Hi Daniel,
> > > 
> > > On Wed, 2019-02-27 at 06:13:45 -0800, Daniel Vetter wrote:
> > > > On Tue, Feb 26, 2019 at 11:20 PM Hyun Kwon <hyun.kwon@xilinx.com> wrote:
> > > > >
> > > > > Hi Daniel,
> > > > >
> > > > > Thanks for the comment.
> > > > >
> > > > > On Tue, 2019-02-26 at 04:06:13 -0800, Daniel Vetter wrote:
> > > > > > On Tue, Feb 26, 2019 at 12:53 PM Greg Kroah-Hartman
> > > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > >
> > > > > > > On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> > > > > > > > Add the dmabuf map / unmap interfaces. This allows the user driver
> > > > > > > > to be able to import the external dmabuf and use it from user space.
> > > > > > > >
> > > > > > > > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > > > > > > > ---
> > > > > > > >  drivers/uio/Makefile         |   2 +-
> > > > > > > >  drivers/uio/uio.c            |  43 +++++++++
> > > > > > > >  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
> > > > > > > >  drivers/uio/uio_dmabuf.h     |  26 ++++++
> > > > > > > >  include/uapi/linux/uio/uio.h |  33 +++++++
> > > > > > > >  5 files changed, 313 insertions(+), 1 deletion(-)
> > > > > > > >  create mode 100644 drivers/uio/uio_dmabuf.c
> > > > > > > >  create mode 100644 drivers/uio/uio_dmabuf.h
> > > > > > > >  create mode 100644 include/uapi/linux/uio/uio.h
> > > > > > > >
> > > > > > > > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > > > > > > > index c285dd2..5da16c7 100644
> > > > > > > > --- a/drivers/uio/Makefile
> > > > > > > > +++ b/drivers/uio/Makefile
> > > > > > > > @@ -1,5 +1,5 @@
> 
> [snip]
> 
> > > > > > Frankly looks like a ploy to sidestep review by graphics folks. We'd
> > > > > > ask for the userspace first :-)
> > > > >
> > > > > Please refer to pull request [1].
> > > > >
> > > > > For any interest in more details, the libmetal is the abstraction layer
> > > > > which provides platform independent APIs. The backend implementation
> > > > > can be selected per different platforms: ex, rtos, linux,
> > > > > standalone (xilinx),,,. For Linux, it supports UIO / vfio as of now.
> > > > > The actual user space drivers sit on top of libmetal. Such drivers can be
> > > > > found in [2]. This is why I try to avoid any device specific code in
> > > > > Linux kernel.
> > > > >
> > > > > >
> > > > > > Also, exporting dma_addr to userspace is considered a very bad idea.
> > > > >
> > > > > I agree, hence the RFC to pick some brains. :-) Would it make sense
> > > > > if this call doesn't export the physicall address, but instead takes
> > > > > only the dmabuf fd and register offsets to be programmed?
> > > > >
> > > > > > If you want to do this properly, you need a minimal in-kernel memory
> > > > > > manager, and those tend to be based on top of drm_gem.c and merged
> > > > > > through the gpu tree. The last place where we accidentally leaked a
> > > > > > dma addr for gpu buffers was in the fbdev code, and we plugged that
> > > > > > one with
> > > > >
> > > > > Could you please help me understand how having a in-kernel memory manager
> > > > > helps? Isn't it just moving same dmabuf import / paddr export functionality
> > > > > in different modules: kernel memory manager vs uio. In fact, Xilinx does have
> > > > > such memory manager based on drm gem in downstream. But for this time we took
> > > > > the approach of implementing this through generic dmabuf allocator, ION, and
> > > > > enabling the import capability in the UIO infrastructure instead.
> > > > 
> > > > There's a group of people working on upstreaming a xilinx drm driver
> > > > already. Which driver are we talking about? Can you pls provide a link
> > > > to that xilinx drm driver?
> > > > 
> > > 
> > > The one I was pushing [1] is implemented purely for display, and not
> > > intended for anything other than that as of now. What I'm refering to above
> > > is part of Xilinx FPGA (acceleration) runtime [2]. As far as I know,
> > > it's planned to be upstreamed, but not yet started. The Xilinx runtime
> > > software has its own in-kernel memory manager based on drm_cma_gem with
> > > its own ioctls [3].
> > > 
> > > Thanks,
> > > -hyun
> > > 
> > > [1] https://patchwork.kernel.org/patch/10513001/
> > > [2] https://github.com/Xilinx/XRT
> > > [3] https://github.com/Xilinx/XRT/tree/master/src/runtime_src/driver/zynq/drm
> > 
> > I've done a very quick look only, and yes this is kinda what I'd expect.
> > Doing a small drm gem driver for an fpga/accelarator that needs lots of
> > memories is the right architecture, since at the low level of kernel
> > interfaces a gpu really isn't anything else than an accelarater.
> > 
> > And from a very cursory look the gem driver you mentioned (I only scrolled
> > through the ioctl handler quickly) looks reasonable.
> 
> Thanks for taking time to look and share input. But still I'd like to
> understand why it's more reasonable if the similar ioctl exists with drm
> than with uio. Is it because such drm ioctl is vendor specific?

We do have quite a pile of shared infrastructure in drm beyond just the
vendor specific ioctl. So putting accelerator drivers there makes sense,
whether the programming is a GPU, some neural network folder, an FPGA or
something else. The one issue is that we require open source userspace
together with your driver, since just the accelerator shim in the kernel
alone is fairly useless (both for review and for doing anything with it).

But there's also some kernel maintainers who disagree and happily take
drivers originally written for drm and then rewritten for non-drm for
upstream to avoid the drm folks (or at least it very much looks like that,
and happens fairly regularly).

Cheers, Daniel

> 
> Thanks,
> -hyun
> 
> > -Daniel
> > > 
> > > > Thanks, Daniel
> > > > 
> > > > > Thanks,
> > > > > -hyun
> > > > >
> > > > > [1] https://github.com/OpenAMP/libmetal/pull/82/commits/951e2762bd487c98919ad12f2aa81773d8fe7859
> > > > > [2] https://github.com/Xilinx/embeddedsw/tree/master/XilinxProcessorIPLib/drivers
> > > > >
> > > > > >
> > > > > > commit 4be9bd10e22dfc7fc101c5cf5969ef2d3a042d8a (tag:
> > > > > > drm-misc-next-fixes-2018-10-03)
> > > > > > Author: Neil Armstrong <narmstrong@baylibre.com>
> > > > > > Date:   Fri Sep 28 14:05:55 2018 +0200
> > > > > >
> > > > > >     drm/fb_helper: Allow leaking fbdev smem_start
> > > > > >
> > > > > > Together with cuse the above patch should be enough to implement a drm
> > > > > > driver entirely in userspace at least.
> > > > > >
> > > > > > Cheers, Daniel
> > > > > > --
> > > > > > Daniel Vetter
> > > > > > Software Engineer, Intel Corporation
> > > > > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> > > > 
> > > > 
> > > > 
> > > > -- 
> > > > Daniel Vetter
> > > > Software Engineer, Intel Corporation
> > > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> > 
> > -- 
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
