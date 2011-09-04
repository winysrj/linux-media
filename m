Return-path: <linux-media-owner@vger.kernel.org>
Received: from moh2-ve1.go2.pl ([193.17.41.186]:42138 "EHLO moh2-ve1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab1IDVBQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 17:01:16 -0400
Received: from moh2-ve1.go2.pl (unknown [10.0.0.186])
	by moh2-ve1.go2.pl (Postfix) with ESMTP id 17FF0200014
	for <linux-media@vger.kernel.org>; Sun,  4 Sep 2011 23:01:12 +0200 (CEST)
Received: from unknown (unknown [10.0.0.108])
	by moh2-ve1.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Sun,  4 Sep 2011 23:01:12 +0200 (CEST)
Message-ID: <4E63E715.6020708@o2.pl>
Date: Sun, 04 Sep 2011 23:01:09 +0200
From: Maciej Szmigiero <mhej@o2.pl>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Martin Wilks <m.wilks@technisat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sven Barth <pascaldragon@googlemail.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH]Medion 95700 analog video support
References: <4E63C8A0.7030702@o2.pl> <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com>
In-Reply-To: <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 04.09.2011 21:46, Michael Krufky pisze:
> Maciej,
> 
> I'm excited to see some success getting analog to work in the dvb-usb
> framework.  Some people have been asking for this support in the cxusb
> driver for a long time.
> 
> I have a device (DViCO FusionHDTV5 usb) that should work with this
> patch with some small modifications -- i will try it out.
> 
> I see that this patch adds analog support to cxusb... have you thought
> at all about adding generic analog support callbacks to the dvb-usb
> framework?  There are some other dvb-usb devices based on the dib0700
> chipset that also also use the cx25840 decoder for analog -- it would
> be great if this can be done in a way to benefit both the dib0700 and
> cxusb drivers.
> 
> I will let you know how things go after I try this code on my own device, here.
> 
> Thanks for your patch.
> 
> -Mike Krufky

Hi and thanks for reply,

I think whether the code should be moved to dvb-usb framework really 
depends on how much the devices have in common - Medion uses a
generic Cypress FX2 USB bridge which is programmed (by firmware) to post an
ISO buffer once there is exactly 1010 bytes received on its parallel interface.

This parallel interface is 8-bit wide and has data inputs connected to cx25840
video interface data output and clock input to cx25840 pixel clock output.
USB bridge does not modify this data in any way, nor it does any alignment.
So we have a raw BT.656 (or VESA VIP) stream coming from the device.

Because there are 3 such 1010-byte packets per (micro)frame 
the URB frame descriptor has to be 3030 bytes in length (or more) or data will
be truncated, which will result in parts of field being all-green.

If your device has similar characteristics then it is just matter of substituting
a few commands in code (and maybe changing CXUSB_VIDEO_PKT_SIZE to different value
if it does not use 3*1010 byte frames).

Otherwise, for example if device outputs simple YUV data without any framing, the code
will pretty much be different - other than a bit of V4L2 driver glue code which can be shared.

Best regards and hope this helps,
Maciej Szmigiero
