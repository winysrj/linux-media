Return-path: <linux-media-owner@vger.kernel.org>
Received: from a.mx.esa.t-systems.com ([81.7.202.133]:58463 "EHLO
	a.mx.esa.t-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0ECIjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 04:39:08 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [RFC 0/2] UVC gadget driver
Date: Mon, 3 May 2010 10:29:17 +0200
Message-ID: <D6DB9C7EDECDA944B870F62B587008622C89AB@NL-EXC-06.intra.local>
References: <1272495179-2652-1-git-send-email-laurent.pinchart@ideasonboard.com> <201004290914.04140.laurent.pinchart@ideasonboard.com> <20100429073210.GA9462@kroah.com> <201004290934.50743.laurent.pinchart@ideasonboard.com>
From: "Robert Lukassen" <Robert.Lukassen@tomtom.com>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Greg KH" <greg@kroah.com>
Cc: <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 
> > > Both drivers act as "webcams". Robert's version exports the local 
> > > frame buffer through USB, making the "webcam" capture what's 
> > > displayed on the device. My version exposes a V4L2 interface to 
> > > userspace, allowing an application on the device to send 
> whatever it 
> > > wants over USB (for instance frames captured from a 
> sensor, making 
> > > the device a real camera).
> > 
> > Ah.  So your's has the advantage of being able to do what 
> his does as 
> > well, right?

Our driver has been developed with an explicit goal of being 'transparent' for user-land. When an application uses a double-buffered framebuffer device for rendering, ALSA for sound playback and the linux input framework for input, then it just works. We have in the past also used a V4L2 like API on the video function, but stepped away from it as the framebuffer usually is uncached, and reading from the framebuffer is slow. In the approach you suggest, you'll have to memcpy() from a mmapped framebuffer to the V4L2 buffer. In the kernel driver, you'll have a copy of the data from the V4L2 buffer to the payload buffers. In the driver we've posted, data is copied from the framebuffer using an ordinary memcpy(), but for specific devices we've replaced that with a DMA memory copy. In that situation, the CPU doesn't do any copying of data and impact of streaming out video to a host is very low.

Laurent's driver is more generic, our's has been tuned to low impact/high performance. I believe there is value in both approaches, but if you want to avoid to have two function implementations of the same device class it would be right to favour Laurent's generality over our tuning. 

Please let me know if you still want me to post a patch for f_vdc as a separate function implementation.

Regards,

Robert Lukassen 
