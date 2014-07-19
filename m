Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-gw4.li-life.net ([195.225.200.36]:53873 "EHLO
	SMTP-GW4.li-life.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaGSRyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jul 2014 13:54:43 -0400
Message-ID: <53CAAF9D.6000507@kaiser-linux.li>
Date: Sat, 19 Jul 2014 19:49:17 +0200
From: Thomas Kaiser <thomas@kaiser-linux.li>
MIME-Version: 1.0
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ddbridge -- kernel 3.15.6
References: <53C920FB.1040501@grumpydevil.homelinux.org>
In-Reply-To: <53C920FB.1040501@grumpydevil.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 03:28 PM, Rudy Zijlstra wrote:
> Dears,
>
> I have a ddbridge device:
>
> 03:00.0 Multimedia controller: Device dd01:0003
>           Subsystem: Device dd01:0021
>           Flags: fast devsel, IRQ 17
>           Memory at f0900000 (64-bit, non-prefetchable) [size=64K]
>           Capabilities: [50] Power Management version 3
>           Capabilities: [90] Express Endpoint, MSI 00
>           Capabilities: [100] Vendor Specific Information: ID=0000 Rev=0
> Len=00c <?>
>           Kernel driver in use: DDBridge
>
> The kernel recognises as seen in dmesg:
>
> [    1.811626] Digital Devices PCIE bridge driver, Copyright (C) 2010-11
> Digital Devices GmbH
> [    1.813996] pci 0000:01:19.0: enabling device (0000 -> 0002)
> [    1.816033] DDBridge driver detected: Digital Devices PCIe bridge
> [    1.816273] HW 0001000d FW 00010004
>
> But /dev/dvb remains empty, only /dev/ddbridge exists.
>
> Any pointers are much appreciated
>
> Cheers
>
>
> Rudy

Hello Rudy

I use a similar card from Digital Devices with Ubuntu 14.04 and kernel 3.13.0-32-generic. Support for this card was not build into the kernel and I had to compile it myself. I had to use media_build_experimental from Mr. Endriss.

http://linuxtv.org/hg/~endriss/media_build_experimental

Your card should be supported with this version.

Regards, Thomas




