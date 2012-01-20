Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56699 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab2ATQLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 11:11:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Date: Fri, 20 Jan 2012 17:11:50 +0100
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, m.szyprowski@samsung.com,
	rob@ti.com, daniel@ffwll.ch, patches@linaro.org
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <201201201612.31821.laurent.pinchart@ideasonboard.com> <4F198DF0.7000801@samsung.com>
In-Reply-To: <4F198DF0.7000801@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201201711.50965.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 20 January 2012 16:53:20 Tomasz Stanislawski wrote:
> On 01/20/2012 04:12 PM, Laurent Pinchart wrote:
> > On Friday 20 January 2012 11:58:39 Tomasz Stanislawski wrote:
> >> On 01/20/2012 11:41 AM, Sumit Semwal wrote:
> >>> On 20 January 2012 00:37, Pawel Osciak<pawel@osciak.com>   wrote:
> >>>> Hi Sumit,
> >>>> Thank you for your work. Please find my comments below.
> >>> 
> >>> Hi Pawel,
> 
> <snip>
> 
> >>>>>    struct vb2_mem_ops {
> >>>>>    
> >>>>>          void            *(*alloc)(void *alloc_ctx, unsigned long
> >>>>>          size);
> >>>>> 
> >>>>> @@ -65,6 +82,16 @@ struct vb2_mem_ops {
> >>>>> 
> >>>>>                                          unsigned long size, int
> >>>>>                                          write);
> >>>>>          
> >>>>>          void            (*put_userptr)(void *buf_priv);
> >>>>> 
> >>>>> +       /* Comment from Rob Clark: XXX: I think the attach / detach
> >>>>> could be handled +        * in the vb2 core, and vb2_mem_ops really
> >>>>> just need to get/put the +        * sglist (and make sure that the
> >>>>> sglist fits it's needs..) +        */
> >>>> 
> >>>> I *strongly* agree with Rob here. Could you explain the reason behind
> >>>> not doing this?
> >>>> Allocator should ideally not have to be aware of attaching/detaching,
> >>>> this is not specific to an allocator.
> >>> 
> >>> Ok, I thought we'll start with this version first, and then refine.
> >>> But you guys are right.
> >> 
> >> I think that it is not possible to move attach/detach to vb2-core. The
> >> problem is that dma_buf_attach needs 'struct device' argument. This
> >> pointer is not available in vb2-core. This pointer is delivered by
> >> device's driver in "void *alloc_context".
> >> 
> >> Moving information about device would introduce new problems like:
> >> - breaking layering in vb2
> >> - some allocators like vb2-vmalloc do not posses any device related
> >> attributes
> > 
> > What about passing the device to vb2-core then ?
> 
> IMO, One way to do this is adding field 'struct device *dev' to struct
> vb2_queue. This field should be filled by a driver prior to calling
> vb2_queue_init.

I haven't looked into the details, but that sounds good to me. Do we have use 
cases where a queue is allocated before knowing which physical device it will 
be used for ?

-- 
Regards,

Laurent Pinchart
