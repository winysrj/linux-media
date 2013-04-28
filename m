Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46231 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3D1VIe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 17:08:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Igor Kugasyan <kugasyan@hotmail.com>
Cc: "todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"clark.becker@ridgerun.com" <clark.becker@ridgerun.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: mt9v034 driver
Date: Sun, 28 Apr 2013 23:08:38 +0200
Message-ID: <1762550.7mDg3VrWU9@avalon>
In-Reply-To: <DUB112-W1120C7E0BD196DF8764BA21D2B70@phx.gbl>
References: <DUB112-W1120C7E0BD196DF8764BA21D2B70@phx.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Igor,

On Friday 26 April 2013 16:30:49 Igor Kugasyan wrote:
> Dear Sirs,
> 
> I wrote a driver for the mt9v034 as Todd recommended (on basis of working
> mt9p031 and mt9v022), built kernel with this driver,

Note that a driver for the same sensor has already been posted, see 
https://patchwork.linuxtv.org/patch/14907/.

> but faced with the
> problem:
 
> /dev # cat video0
> cat: can't open 'video0': No such device
> 
> ----------------------------------------------------------------------------
> NAND
> Starting NAND Copy...
> Valid magicnum, 0xA1ACED66, found in block 0x00000019.
> 
> 
> U-Boot 2010.12-rc2 (Feb 07 2013 - 18:15:34)
> 
> Cores: ARM 297 MHz
> DDR:   243 MHz
> I2C:   ready
> DRAM:  128 MiB
> NAND:  256 MiB
> MMC:   davinci: 0, davinci: 1
> Net:   Ethernet PHY: GENERIC @ 0x00
> DaVinci-EMAC
> Hit any key to stop autoboot:  0 
> 
> Loading from nand0, offset 0x400000
>    Image Name:   "RR Linux Kernel"
>    Created:      2013-04-26  11:03:27 UTC
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    4247104 Bytes = 4.1 MiB
>    Load Address: 80008000
>    Entry Point:  80008000
> Automatic boot of image at addr 0x82000000 ...
> ## Booting kernel from Legacy Image at 82000000 ...
>    Image Name:   "RR Linux Kernel"
>    Created:      2013-04-26  11:03:27 UTC
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    4247104 Bytes = 4.1 MiB
>    Load Address: 80008000
>    Entry Point:  80008000
>    Verifying Checksum ... OK
>    Loading Kernel Image ... OK
> OK
> 
> Starting kernel ...
> 
> Linux version 2.6.32.17-davinci1 (root@ubuntu) (gcc version 4.3.3 (Sourcery
> G++ Lite 2009q1-203) ) #129 PREEMPT Fri Apr 26 14:02:08 EEST 2013

Not only is 2.6.32 from ancient times, I suppose it's the kernel provided with 
the TI BSP. I don't think you will get any support for that here, you should 
contact your TI support channel. We can only provide support for the mainline 
kernel.

-- 
Regards,

Laurent Pinchart

