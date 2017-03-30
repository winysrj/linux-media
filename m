Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37288 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933077AbdC3MEv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 08:04:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be aligned
Date: Thu, 30 Mar 2017 15:05:30 +0300
Message-ID: <6163606.hRdPdWigB9@avalon>
In-Reply-To: <20170330072800.5ee8bc33@vento.lan>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com> <3181783.rVmBcEVlbi@avalon> <20170330072800.5ee8bc33@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 30 Mar 2017 07:28:00 Mauro Carvalho Chehab wrote:
> Em Thu, 30 Mar 2017 12:34:32 +0300 Laurent Pinchart escreveu:
> > On Thursday 30 Mar 2017 10:11:31 Oliver Neukum wrote:
> >> Am Donnerstag, den 30.03.2017, 01:15 +0300 schrieb Laurent Pinchart:
> >>>> +   may also override PAD bytes at the end of the
> >>>> ``transfer_buffer``, up to the
> >>>> +   size of the CPU word.
> >>> 
> >>> "May" is quite weak here. If some host controller drivers require
> >>> buffers to be aligned, then it's an API requirement, and all buffers
> >>> must be aligned. I'm not even sure I would mention that some host
> >>> drivers require it, I think we should just state that the API requires
> >>> buffers to be aligned.
> >> 
> >> That effectively changes the API. Many network drivers are written with
> >> the assumption that any contiguous buffer is valid. In fact you could
> >> argue that those drivers are buggy and must use bounce buffers in those
> >> cases.
> 
> Blaming the dwc2 driver was my first approach, but such patch got nacked ;)
> 
> Btw, the dwc2 driver has a routine that creates a temporary buffer if the
> buffer pointer is not DWORD aligned. My first approach were to add
> a logic there to also use the temporary buffer if the buffer size is
> not DWORD aligned:
> 	https://patchwork.linuxtv.org/patch/40093/
> 
> While debugging this issue, I saw *a lot* of network-generated URB
> traffic from RPi3 Ethernet port drivers that were using non-aligned
> buffers and were subject to the temporary buffer conversion.
> 
> My understanding here is that having a temporary bounce buffer sucks,
> as the performance and latency are affected. So, I see the value of
> adding this constraint to the API, pushing the task of getting
> aligned buffers to the USB drivers,

This could however degrade performances when the HCD can handle unaligned 
buffers.

> but you're right: that means a lot of work, as all USB drivers should be
> reviewed.

If we decide in the end to push the constraint on the USB device driver side, 
then the dwc2 HCD driver should return an error when the buffer isn't 
correctly aligned.

> Btw, I'm a lot more concerned about USB storage drivers. When I was
> discussing about this issue at the #raspberrypi-devel IRC channel,
> someone complained that, after switching from the RPi downstream Kernel
> to upstream, his USB data storage got corrupted. Well, if the USB
> storage drivers also assume that the buffer can be continuous,
> that can corrupt data.
> 
> That's why I think that being verbose here is a good idea.
> 
> I'll rework on this patch to put more emphasis about this issue.
> 
> >> So we need to include the full story here.
> > 
> > I personally don't care much about whose side is responsible for handling
> > the alignment constraints, but I want it to be documented before "fixing"
> > any USB driver.

-- 
Regards,

Laurent Pinchart
