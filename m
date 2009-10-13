Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44102 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933766AbZJMOyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 10:54:08 -0400
Date: Tue, 13 Oct 2009 10:53:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	<linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <4AD42453.20103@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0910131050460.3169-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Oct 2009, [UTF-8] Ozan Çağlayan wrote:

> Hi,
> 
> Some recent netbooks (Some MSI winds and LG X110's) equipped with an
> integrated webcam have non-working USB ports unless the uvcvideo module
> is blacklisted. I've found some bug reports in launchpad:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/435352
> 
> I have an LG X110 on which I can reproduce the problem with 2.6.30.8.
> Here's the interesting part in dmesg:
> 
> Oct 13 08:46:32 x110 kernel: [  261.048312] uvcvideo: Found UVC 1.00
> device BisonCam, NB Pro (5986:0203)
> Oct 13 08:46:32 x110 kernel: [  261.053592] input: BisonCam, NB Pro as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5:1.0/input/input10
> Oct 13 08:46:32 x110 kernel: [  261.053891] usbcore: registered new
> interface driver uvcvideo
> Oct 13 08:46:32 x110 kernel: [  261.054755] USB Video Class driver (v0.1.0)
> Oct 13 08:46:32 x110 kernel: [  261.091014] ehci_hcd 0000:00:1d.7: force
> halt; handhake f807c024 00004000 00000000 -> -110

Can you add a dump_stack() call just after the ehci_err() line in 
drivers/usb/host/ehci-hcd.c:handshake_on_error_set_halt()?  It should 
provide some clues.

At the same time (i.e., during the same test) you should collect a 
usbmon trace.

Alan Stern

