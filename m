Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:34032 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753625Ab0FMN5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 09:57:36 -0400
Date: Sun, 13 Jun 2010 09:57:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: thomas.schorpp@gmail.com
cc: "C. Hemsing" <C.Hemsing@gmx.net>, <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>
Subject: Re: was: af9015, af9013 DVB-T problems. now: Intermittent USB
 disconnects with many (2.0) high speed devices
In-Reply-To: <4C14DAF0.6030704@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1006130954180.22182-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 13 Jun 2010, thomas schorpp wrote:

> ehci-hcd is broken and halts silently or disconnects after hours or a few days, with the wlan usb adapter

How do you know the bug is in ehci-hcd and not in the hardware?

> I was able to catch a dmesg err message like "ehci...force halt... handshake failed" once only.

Can you please post the error message?

> The disconnects with dvb-usb need reboot cause driver cannot be removed with modprobe.

That sounds like it might be a bug in dvb-usb driver.  It always should 
be possible to remove the driver.

> This long standing bug is really nasty and makes permanent high speed usb connections unusable on Linux,
> at least with this VIA hardware.
> 
> No debug parms in modules, we need to ask linux-usb how to debug this.

You can start by building a kernel with CONFIG_USB_DEBUG enabled.

Alan Stern

