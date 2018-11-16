Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp057.webpack.hosteurope.de ([80.237.132.64]:47418 "EHLO
        wp057.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbeKQGbJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 01:31:09 -0500
Subject: Re: TechnoTrend CT2-4500 remote not working
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
References: <9e2205c8-50f7-06de-f1e5-8946258f6a91@mknetz.de>
 <2A2F47EF-335E-4161-A6F4-8B75FF62ED4A@mknetz.de>
 <20181116112636.c6tnrsrvvttv5u6t@gofer.mess.org>
From: "martin.konopka@mknetz.de" <martin.konopka@mknetz.de>
Message-ID: <051c9159-6f33-75cb-acc5-6137c70ed6e6@mknetz.de>
Date: Fri, 16 Nov 2018 21:17:11 +0100
MIME-Version: 1.0
In-Reply-To: <20181116112636.c6tnrsrvvttv5u6t@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean,

Am 16.11.2018 um 12:26 schrieb Sean Young:
> 
> Ok, thank you. Now, we don't know how the IR is wired up. Please
> could you try enabling the enable_885_ir module parameter for
> cx23885. If this goes badly, then we might end up in an infinite
> loop of unending interrupts, so it would be prudent to not change
> your startup scripts to set this. As root, please run:
> 
> rmmod cx23885
> modprobe cx23885 enable_885_ir=1

Thank you, loading the module with enable_885_ir=1 works:

cx23885: cx23885_dev_checkrevision() Hardware revision = 0xa5
cx23885: cx23885[0]/0: found at 0000:17:00.0, rev: 4, irq: 31, latency: 
0, mmio: 0xfe000000
Registered IR keymap rc-tt-1500
IR RC5(x/sz) protocol handler initialized
rc rc1: cx23885 IR (Technotrend TT-budget CT2-4500 CI) as 
/devices/pci0000:00/0000:00:01.2/0000:15:00.2/0000:16:00.0/0000:17:00.0/rc/rc1
input: cx23885 IR (Technotrend TT-budget CT2-4500 CI) as 
/devices/pci0000:00/0000:00:01.2/0000:15:00.2/0000:16:00.0/0000:17:00.0/rc/rc1/input21

ir-keytable output:

Found /sys/class/rc/rc1/ (/dev/input/event17) with:
	Name: cx23885 IR (Technotrend TT-budget CT2-4500 CI)
	Driver: cx23885, table: rc-tt-1500
	lirc device: /dev/lirc1
	Supported protocols: other lirc rc-5 rc-5-sz jvc sony nec sanyo mce_kbd 
rc-6 sharp xmp
	Enabled protocols: lirc rc-5
	bus: 1, vendor/product: 13c2:3013, version: 0x0001
	Repeat delay = 500 ms, repeat period = 125 ms


Using ir-keytable -t I see all the buttons pressed. Maybe you can amend 
the module options description to include my device:

parm:           enable_885_ir:Enable integrated IR controller for supported
		    CX2388[57] boards that are wired for it:
			HVR-1250 (reported safe)
			TerraTec Cinergy T PCIe Dual (not well tested, appears to be safe)
			TeVii S470 (reported unsafe)
		    This can cause an interrupt storm with some cards.
		    Default: 0 [Disabled] (int)


> 
> You should get another rc device, which might just work.

Thanks again Sean for the help!

Martin
