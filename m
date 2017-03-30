Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46563
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932921AbdC3Mh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 08:37:26 -0400
Date: Thu, 30 Mar 2017 09:37:16 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Oliver Neukum <oneukum@suse.com>,
        David Mosberger <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-rpi-kernel@lists.infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        John Youn <johnyoun@synopsys.com>,
        Roger Quadros <rogerq@ti.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be
 aligned
Message-ID: <20170330093716.175c2ebe@vento.lan>
In-Reply-To: <6163606.hRdPdWigB9@avalon>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
        <3181783.rVmBcEVlbi@avalon>
        <20170330072800.5ee8bc33@vento.lan>
        <6163606.hRdPdWigB9@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 15:05:30 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Thursday 30 Mar 2017 07:28:00 Mauro Carvalho Chehab wrote:
> > Em Thu, 30 Mar 2017 12:34:32 +0300 Laurent Pinchart escreveu:  
> > > On Thursday 30 Mar 2017 10:11:31 Oliver Neukum wrote:  
> > >> Am Donnerstag, den 30.03.2017, 01:15 +0300 schrieb Laurent Pinchart:  
> > >>>> +   may also override PAD bytes at the end of the
> > >>>> ``transfer_buffer``, up to the
> > >>>> +   size of the CPU word.  
> > >>> 
> > >>> "May" is quite weak here. If some host controller drivers require
> > >>> buffers to be aligned, then it's an API requirement, and all buffers
> > >>> must be aligned. I'm not even sure I would mention that some host
> > >>> drivers require it, I think we should just state that the API requires
> > >>> buffers to be aligned.  
> > >> 
> > >> That effectively changes the API. Many network drivers are written with
> > >> the assumption that any contiguous buffer is valid. In fact you could
> > >> argue that those drivers are buggy and must use bounce buffers in those
> > >> cases.  
> > 
> > Blaming the dwc2 driver was my first approach, but such patch got nacked ;)
> > 
> > Btw, the dwc2 driver has a routine that creates a temporary buffer if the
> > buffer pointer is not DWORD aligned. My first approach were to add
> > a logic there to also use the temporary buffer if the buffer size is
> > not DWORD aligned:
> > 	https://patchwork.linuxtv.org/patch/40093/
> > 
> > While debugging this issue, I saw *a lot* of network-generated URB
> > traffic from RPi3 Ethernet port drivers that were using non-aligned
> > buffers and were subject to the temporary buffer conversion.
> > 
> > My understanding here is that having a temporary bounce buffer sucks,
> > as the performance and latency are affected. So, I see the value of
> > adding this constraint to the API, pushing the task of getting
> > aligned buffers to the USB drivers,  
> 
> This could however degrade performances when the HCD can handle unaligned 
> buffers.

No, it won't degrade performance out there, except if the driver
would need to do double buffering due to such constraint. 

It will just waste memory.

> 
> > but you're right: that means a lot of work, as all USB drivers should be
> > reviewed.  
> 
> If we decide in the end to push the constraint on the USB device driver side, 
> then the dwc2 HCD driver should return an error when the buffer isn't 
> correctly aligned.

Yeah, with such constraint, either the HCD drivers or the USB core
should complain.

There is another option: to add a field, filled by te USB driver,
telling the core that the buffer is aligned, e. g. drivers would
be doing something like:

	urb->transfer_buffer_align = 4;

Something similar could be filled by the HCD driver:

	hc_driver->transfer_buffer_align = 4;

The core will then check if the alignment required by the HCD driver
is compatible with the buffer alignment ensured by the USB driver.
If it doesn't, then the core would create a temporary buffer for the
transfers.

No idea about how easy/hard would be to implement something like
that.

In such case, it could make sense to generate a warning that
the driver should be fixed, or that the performance would
decrease due to double-buffering.

Thanks,
Mauro
