Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42733 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752082Ab1KYP1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 10:27:03 -0500
Date: Fri, 25 Nov 2011 10:27:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Johann Klammer <klammerr@aon.at>
cc: linux-usb@vger.kernel.org, <linux-media@vger.kernel.org>
Subject: Re: PROBLEM: EHCI disconnects DVB & HDD
In-Reply-To: <4ECEFBA3.7010808@aon.at>
Message-ID: <Pine.LNX.4.44L0.1111251022100.1951-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Nov 2011, Johann Klammer wrote:

> When using a DVB-T Dongle and an external HDD simultaneously, EHCI 
> almost always disconnects.
> 
> When tuning, it works for some time, but after a while, probably 
> triggered by disk activity
> the dmesg log fills up with disk errors and failed i2c writes. The 
> devices disconnect and the mountpoint gets lost.
> Attempting a simple 'ls /mnt/rec' fails with 'input/ouput error'. The 
> kernel log sometimes reports
> the khubd task hanging. As soon as the dvb software gets shut down(at 
> that point DVB doesn't work either),
> the devices get rediscovered as low speed devices and work again after 
> umount/mount and restart of software.
> But it's rather slow from there on.

This is probably a low-level hardware error.  Interference between the 
two ports of some kind.

> usbdump.mon: On request. usbmon output for the whole host controller 
> during the event. I can mail this, but it's rather large and the mailing 
> list won't accept the message.

Can you put the usbmon trace on a web server like pastebin.com?

Alan Stern

