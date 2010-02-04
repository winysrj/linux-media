Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45623 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726Ab0BDN1o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 08:27:44 -0500
Date: Thu, 4 Feb 2010 14:27:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pekka Sarnila <sarnila@adit.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>, Antti Palosaari <crope@iki.fi>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
In-Reply-To: <4B6ACA4B.2030906@adit.fi>
Message-ID: <alpine.LNX.2.00.1002041425050.15395@pobox.suse.cz>
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6ACA4B.2030906@adit.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 4 Feb 2010, Pekka Sarnila wrote:

> The FULLSPEED thing is really not ir receiver specific problem. It can 
> happen with any device with interrupt endpoint. That's the reason why I 
> placed the quirk to HID driver.
> 
> However even the HID driver is logically a wrong place. Really it should 
> belong to the usb/endpoint layer because this really is not HID specific 
> problem but usb layer problem (as also Jiri Kosina then pointed out). 
> However linux usb layer has been build so that it was technically 
> impossible to put it there without completely redesigning usb <-> higher 
> layer (including HID) interface. But I'm of the opinion that that 
> redesign should be done anyway. Even when no quirk is needed interrupt 
> endpoint handling is a usb level task not a hid level (or any other 
> higher level) task. The usb layer should do the interrupt endpoint 
> polling and just put up interrupt events to higher layers. Partly this 
> confusion is due the poor usb/hid specifications. It really should be a 
> device/endpoint-quirk.

Yes, I still think what I have stated before, that this should be properly 
handled in the USB stack.

On the other hand, in usbhid driver we do a lot of USB-specific 
lower-level things anyway, so it's technically more-or-less OK to apply 
the quirk there as well (and that's why I have accepted it back then).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
