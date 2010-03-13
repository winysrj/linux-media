Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49997 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933894Ab0CMQpe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 11:45:34 -0500
Subject: Re: [linux-dvb] USB1.1 vs. USB2.0
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <e77013311003120749q5c37f89at5e224f557fde0442@mail.gmail.com>
References: <e77013311003120749q5c37f89at5e224f557fde0442@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 11:45:27 -0500
Message-Id: <1268498728.3084.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-03-12 at 16:49 +0100, Ton Machielsen wrote:
> Hi all!
>  
> When i insert a USB 2.0 device i get the following errors:
> 
> [   93.680054] usb 2-1: new full speed USB device using uhci_hcd and
> address 3
> [   93.843342] usb 2-1: configuration #1 chosen from 1 choice
> [   93.855095] input: HID 18b4:1001
> as /devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1:1.0/input/input12
> [   93.855916] generic-usb 0003:18B4:1001.0002: input,hidraw0: USB HID
> v1.11 Keyboard [HID 18b4:1001] on usb-0000:00:1d.1-1/input0
> [   93.866130] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference
> design' in cold state, will try to load a firmware
> [   93.866151] usb 2-1: firmware: requesting dvb-usb-ec168.fw
> [   94.212405] dvb-usb: downloading firmware from file
> 'dvb-usb-ec168.fw'
> [   94.317243] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference
> design' in warm state.
> [   94.317401] dvb-usb: This USB2.0 device cannot be run on a USB1.1
> port. (it lacks a hardware PID filter)
> [   94.317471] dvb-usb: E3C EC168 DVB-T USB2.0 reference design error
> while loading driver (-19)
> 
> I've seen this message many times when searching the internet for a
> solution, but i haven't found the solution yet.
>  
> Does anybody know how to solve this?
>  
> This is Ubuntu 2.6.32.8-1 on an EeePC 701. And yes, this machine does
> have USB 2.0 ports.

Remove any external USB hubs and connect the TV capture device directly
into the port on the computer.

Do you get the same error?


As root, you may want to run 

# /sbin/lsusb -t
# /sbin/lsusb -v

To make sure the device is connected to a USB2.0 "High" speed hub, and
not a USB1.1 "Full" speed hub.

Regards,
Andy

> Thanks,
>  
> Ton.



