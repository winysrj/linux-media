Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754213AbdC3M5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 08:57:09 -0400
Message-ID: <1490878570.11920.6.camel@suse.com>
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be
 aligned
From: Oliver Neukum <oneukum@suse.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Mosberger <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        GregKroah-Hartman <gregkh@linuxfoundation.org>,
        linux-rpi-kernel@lists.infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        John Youn <johnyoun@synopsys.com>,
        Roger Quadros <rogerq@ti.com>,
        Linux Doc MailingList <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-usb@vger.kernel.org
Date: Thu, 30 Mar 2017 14:56:10 +0200
In-Reply-To: <20170330072800.5ee8bc33@vento.lan>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
         <1822963.cezI9HmAB6@avalon> <1490861491.8660.2.camel@suse.com>
         <3181783.rVmBcEVlbi@avalon> <20170330072800.5ee8bc33@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 30.03.2017, 07:28 -0300 schrieb Mauro Carvalho
Chehab:
> Em Thu, 30 Mar 2017 12:34:32 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > 

Hi,

> > > That effectively changes the API. Many network drivers are written with
> > > the assumption that any contiguous buffer is valid. In fact you could
> > > argue that those drivers are buggy and must use bounce buffers in those
> > > cases.
> 
> Blaming the dwc2 driver was my first approach, but such patch got nacked ;)

That I am afraid was a mistake in a certain sense. This belongs into
usbcore. It does not belong into controller drivers or device drivers.

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

If you need it, you need it. Doing this in the device driver isn't any
less problematic in terms of performance. The only thing we can do
is do it in a central place to avoid code duplication.

> adding this constraint to the API, pushing the task of getting 
> aligned buffers to the USB drivers, but you're right: that means a lot
> of work, as all USB drivers should be reviewed.

And it is wrong. To be blunt: The important drivers are EHCI and XHCI.
We must not degrade performance with them for the sake of controllers
with less capabilities.

> Btw, I'm a lot more concerned about USB storage drivers. When I was
> discussing about this issue at the #raspberrypi-devel IRC channel,
> someone complained that, after switching from the RPi downstream Kernel
> to upstream, his USB data storage got corrupted. Well, if the USB
> storage drivers also assume that the buffer can be continuous,
> that can corrupt data.
> 
> That's why I think that being verbose here is a good idea.

They do assume that.

> I'll rework on this patch to put more emphasis about this issue.

For now that is the best. But even in the medium term this sucks.
At a minimum controller drivers need to export what they can do.

	Regards
		Oliver
