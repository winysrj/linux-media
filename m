Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52170 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbZLBWJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2009 17:09:59 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NFxOe-00088E-TA
	for linux-media@vger.kernel.org; Wed, 02 Dec 2009 23:10:04 +0100
Received: from ip4da5ee91.direct-adsl.nl ([77.165.238.145])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2009 23:10:04 +0100
Received: from bert.massop by ip4da5ee91.direct-adsl.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2009 23:10:04 +0100
To: linux-media@vger.kernel.org
From: Bert Massop <bert.massop@gmail.com>
Subject: Re: af9015: tuner id:179 not supported, please report!
Date: Wed, 2 Dec 2009 22:06:24 +0000 (UTC)
Message-ID: <loom.20091202T230047-299@post.gmane.org>
References: <1259695756.5239.2.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jan Sundman <jan.sundman <at> aland.net> writes:

> 
> Hi,
> 
> I just received a usb DVB-T card and have been trying to get it to work
> under Ubuntu 9.10, but to no avail. dmesg shows the following when
> plugging in the card:
> 
> [   35.280024] usb 2-1: new high speed USB device using ehci_hcd and
> address 4
> [   35.435978] usb 2-1: configuration #1 chosen from 1 choice
> [   35.450176] af9015: tuner id:179 not supported, please report!
> [   35.452891] Afatech DVB-T 2: Fixing fullspeed to highspeed interval:
> 10 -> 7
> [   35.453097] input: Afatech DVB-T 2
> as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1:1.1/input/input8
> [   35.453141] generic-usb 0003:15A4:9016.0005: input,hidraw3: USB HID
> v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:13.2-1/input1
> 
> lsusb shows:
> Bus 002 Device 005: ID 15a4:9016  
> 
> and finally lsmod | grep dvb
> dvb_usb_af9015         37152  0 
> dvb_usb                22892  1 dvb_usb_af9015
> dvb_core              109716  1 dvb_usb
> 
> While googling for an answer to my troubles I came across
> http://ubuntuforums.org/showthread.php?t=606487&page=5 which hints that
> the card may use the TDA18218HK tuner chip which does not seem to be
> supported currently.
> 
> Does anyone have any experience regarding this chip and know what to do
> to get it working.
> 
> Best regards,
> 
> //Jan
> 
> 

Hi Jan,

As stated in the Ubuntuforums thread, there doesn't seem to be any support for
this chip at the moment. I don't know how hard it is to code support for a
specific tuner, but I'm looking into that right now.

Hopefully some more experienced coders will join in writing something usable, as
I don't think I will be able to do it myself.

Please drop a message if anyone finds something useful.

Best regards,

Bert


