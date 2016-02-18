Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:50865 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbcBRH3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 02:29:47 -0500
Received: from [192.168.1.138] (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id DA176CAD66
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2016 08:29:42 +0100 (CET)
Subject: Re: Terratec CINERGY T/C Stick
To: linux-media <linux-media@vger.kernel.org>
References: <20160217201920.yq8h5szz5wogsso0@www.mail4me.at>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <56C572E6.8060301@southpole.se>
Date: Thu, 18 Feb 2016 08:29:42 +0100
MIME-Version: 1.0
In-Reply-To: <20160217201920.yq8h5szz5wogsso0@www.mail4me.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/17/2016 08:19 PM, lorenz.giefing@physio-geidorf.at wrote:
> Hi!
> I bought such a stick to build a linux driven video recorder.
> But the stick istn't recognized by the kernel
>
> uname -a
> Linux ESPRIMO 4.2.0-27-generic #32-Ubuntu SMP Fri Jan 22 04:49:08 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> dmesg
> Feb 17 20:06:42 ESPRIMO kernel: [35572.460078] usb 2-3: new high-speed
> USB device number 5 using ehci-pci
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604226] usb 2-3: New USB device
> found, idVendor=0ccd, idProduct=5103
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604233] usb 2-3: New USB device
> strings: Mfr=1, Product=2, SerialNumber=3
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604237] usb 2-3: Product: RTL2841UHIDIR
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604240] usb 2-3: Manufacturer: Realtek

Open the device take some pictures and tell us what chips are inside. It 
might be easy to add support.

MvH
Benjamin Larsson
