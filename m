Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4999 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab0EFGi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 02:38:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v2 2/10] V4L2 patches for Intel Moorestown Camera Imaging Drivers - part 1
Date: Thu, 6 May 2010 08:39:39 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>
References: <33AB447FBD802F4E932063B962385B351D6D536E@shsmsx501.ccr.corp.intel.com> <201003290840.50223.hverkuil@xs4all.nl>
In-Reply-To: <201003290840.50223.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005060839.39901.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 29 March 2010 08:40:50 Hans Verkuil wrote:
> Hi Xiaolin,
> 
> On Sunday 28 March 2010 16:42:30 Zhang, Xiaolin wrote:
> > From 1c18c41be33246e4b766d0e95e28a72dded87475 Mon Sep 17 00:00:00 2001
> > From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> > Date: Sun, 28 Mar 2010 21:31:24 +0800
> > Subject: [PATCH 2/10] This patch is second part of intel moorestown isp driver and c files collection which is v4l2 implementation.
> > 
> 
> ....
> 
> > +struct videobuf_dma_contig_memory {
> > +       u32 magic;
> > +       void *vaddr;
> > +       dma_addr_t dma_handle;
> > +       unsigned long size;
> > +       int is_userptr;
> > +};
> > +
> > +#define MAGIC_DC_MEM 0x0733ac61
> > +#define MAGIC_CHECK(is, should)                                                    \
> > +       if (unlikely((is) != (should))) {                                   \
> > +               pr_err("magic mismatch: %x expected %x\n", (is), (should)); \
> > +               BUG();                                                      \
> > +       }
> 
> I will do a more in-depth review in a few days. 

I realize that I never got round to this. You have to remind me if you don't
see a follow-up within a week! These things tend to get buried otherwise.

I will try to review this this weekend. Let me know if you prefer me to wait
for the next patch series incorporating the comments already made by others.

Regards,

	Hans

> However, I did notice that
> you added your own dma_contig implementation. What were the reasons for doing
> this? I've CC-ed Pawel since he will be interested in this as well.
> 
> Another question that came up is: what is 'marvin'? It's clearly a codename,
> but a codename for what? This should be documented at the top of some source
> or header. Apologies if it is already documented, I didn't read everything yet.
> 
> A final point I noticed: don't cast away a function result:
> 
> (void)ci_isp_set_bp_detection(NULL);
> 
> No need for (void). The gcc compiler won't warn about this unless the function
> is annotated with __must_check__.
> 
> Regards,
> 
> 	Hans
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
