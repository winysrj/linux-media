Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34069 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdFIGPL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 02:15:11 -0400
Date: Fri, 9 Jun 2017 15:15:07 +0900
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC 00/10] V4L2 explicit synchronization support
Message-ID: <20170609061507.GA30571@jade>
References: <20170313192035.29859-1-gustavo@padovan.org>
 <20170525003101.GA16058@jade>
 <20170608171728.09d3b194@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608171728.09d3b194@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

2017-06-08 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Hi Gustavo,
> 
> Em Wed, 24 May 2017 21:31:01 -0300
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > Hi all,
> > 
> > I've been working on the v2 of this series, but I think I hit a blocker
> > when trying to cover the case where the driver asks to requeue the
> > buffer. It is related to the out-fence side.
> > 
> > In the current implementation we return on QBUF an out-fence fd that is not
> > tied to any buffer, because we don't know the queueing order until the
> > buffer is queued to the driver. Then when the buffer is queued we use
> > the BUF_QUEUED event to notify userspace of the index of the buffer,
> > so now userspace knows the buffer associated to the out-fence fd
> > received earlier.
> > 
> > Userspace goes ahead and send a DRM Atomic Request to the kernel to
> > display that buffer on the screen once the fence signals. If it is 
> > a nonblocking request the fence waiting is past the check phase, thus
> > it isn't allowed to fail anymore.
> > 
> > But now, what happens if the V4L2 driver calls buffer_done() asking
> > to requeue the buffer. That means the operation failed and can't
> > signal the fence, starving the DRM side.
> > 
> > We need to fix that. The only way I can see is to guarantee ordering of
> > buffers when out-fences are used. Ordering is something that HAL3 needs
> > to so maybe there is more than one reason to do it like this. I'm not
> > a V4L2 expert, so I don't know all the consequences of such a change.
> > 
> > Any other ideas?
> > 
> > The current patchset is at:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/padovan/linux.git/log/?h=v4l2-fences
> 
> Currently, nothing warrants that buffers will be returned in order,
> but that should be the case of most drivers. I guess the main
> exception would be mem2mem codec drivers. On those, the driver
> or the hardware may opt to reorder the buffers.
> 
> If this is a mandatory requirement for explicit fences to work, then
> we'll need to be able to explicitly enable it, per driver, and
> clearly document that drivers using it *should* warrant that the
> dequeued buffer will follow the queued order.

It is mandatory in the sense it won't work properly and make DRM fail an
atomic commit if a buffer is requeued. So it is fair to ask drivers to
guarantee ordering is a good thing. Then later we can deal with the
drivers that can't. 

> 
> We may need to modify VB2 in order to enforce it or return an
> error if the order doesn't match.

Yeah, I'll look into how to do this.

Gustavo
