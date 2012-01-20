Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33505 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab2ATPMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 10:12:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Date: Fri, 20 Jan 2012 16:12:31 +0100
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, m.szyprowski@samsung.com,
	rob@ti.com, daniel@ffwll.ch, patches@linaro.org
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <CAO_48GEo8icpXrFh_VmGUF-MU2N9BU=xrVVN0VRG37j5NbC0sQ@mail.gmail.com> <4F1948DF.2060207@samsung.com>
In-Reply-To: <4F1948DF.2060207@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201201612.31821.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 20 January 2012 11:58:39 Tomasz Stanislawski wrote:
> On 01/20/2012 11:41 AM, Sumit Semwal wrote:
> > On 20 January 2012 00:37, Pawel Osciak<pawel@osciak.com>  wrote:
> >> Hi Sumit,
> >> Thank you for your work. Please find my comments below.
> > 
> > Hi Pawel,
> > 
> > Thank you for finding time for this review, and your comments :) - my
> > comments inline.
> > [Also, as an aside, Tomasz has also been working on the vb2 adaptation
> > to dma-buf, and his patches should be more comprehensive, in that he
> > is also planning to include 'vb2 as exporter' of dma-buf. He might
> > take and improve on this RFC, so it might be worthwhile to wait for
> > it?]
> 
> <snip>
> 
> >>>   struct vb2_mem_ops {
> >>>   
> >>>         void            *(*alloc)(void *alloc_ctx, unsigned long size);
> >>> 
> >>> @@ -65,6 +82,16 @@ struct vb2_mem_ops {
> >>> 
> >>>                                         unsigned long size, int write);
> >>>         
> >>>         void            (*put_userptr)(void *buf_priv);
> >>> 
> >>> +       /* Comment from Rob Clark: XXX: I think the attach / detach
> >>> could be handled +        * in the vb2 core, and vb2_mem_ops really
> >>> just need to get/put the +        * sglist (and make sure that the
> >>> sglist fits it's needs..) +        */
> >> 
> >> I *strongly* agree with Rob here. Could you explain the reason behind
> >> not doing this?
> >> Allocator should ideally not have to be aware of attaching/detaching,
> >> this is not specific to an allocator.
> > 
> > Ok, I thought we'll start with this version first, and then refine.
> > But you guys are right.
> 
> I think that it is not possible to move attach/detach to vb2-core. The
> problem is that dma_buf_attach needs 'struct device' argument. This
> pointer is not available in vb2-core. This pointer is delivered by
> device's driver in "void *alloc_context".
> 
> Moving information about device would introduce new problems like:
> - breaking layering in vb2
> - some allocators like vb2-vmalloc do not posses any device related
> attributes

What about passing the device to vb2-core then ?

-- 
Regards,

Laurent Pinchart
