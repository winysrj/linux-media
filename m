Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:48438 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752613Ab1LMHsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 02:48:36 -0500
Message-ID: <4EE70351.8030200@gmx.de>
Date: Tue, 13 Dec 2011 08:48:33 +0100
From: Ninja <Ninja15@gmx.de>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: Multiple Mantis devices gives me glitches
References: <4EE682B3.4090301@tyldum.com>
In-Reply-To: <4EE682B3.4090301@tyldum.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello,
>
> I have three  Cinergy C (DVB-C cards) like this:
> 05:04.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
> Bridge Controller [Ver 1.0] (rev 01)
>          Subsystem: TERRATEC Electronic GmbH Device 1178
>          Flags: bus master, medium devsel, latency 128, IRQ 20
>          Memory at fdcfe000 (32-bit, prefetchable) [size=4K]
>          Kernel driver in use: Mantis
>          Kernel modules: mantis
>
> Kernel: 2.6.38-13-generic-pae (Ubuntu Natty stock)
> Motherboard: P43-ES3G
> CPU: Intel(R) Core(TM)2 Quad CPU    Q8400
>
> At some point i started having glitches (I would from time to time get an
> 'old' frame displayed and sometimes audio noise when this happened). I tried
> pretty much every trick I could find:
>   * CPU affinity
>   * Dedicated IRQ for each card (only shared with USB, which has no units
> attached)
>   * Various process priorities (also for the kdvb-processes)
>   * pci latency (from 0x20 to 0xff)
>
> I have quite decent results when I only have 2 DVB cards present, and the
> results became even better when running the irqbalancer-dæmon as well.
> The glitches are not completely gone, but much more manageble now.
>
> So the problem seems to be caused by too many interrupts for my system to
> handle, however this is where I am in over my head.
>
> I know 2.6.38 isn't the freshest brew, but I could not find any changes to
> the driver since then that seemed relevant (which could just be my lack of
> source-fu).
>
> So, any ideas on how to improve the performance? I am suffering from some
> hardware incompatibility or is the driver this resource hungry?

Hi,
I noticed some SMP problems with the mantis driver as well (see my post 
"Mantis CAM not SMP safe / Activating CAM on Technisat Skystar HD2 
(DVB-S2)").
One workaround for me is to limit the CPU to one core (to be sure 
disable the hyperthreading cores as well). That can be done via BIOS 
*or* adding maxcpus=1 as kernel parameter *or* you can disable the cores 
one by one via "|echo 0 > /sys/devices/system/cpu/cpuX/online|" where X 
is the core to disable. Since you need to be root for this, I did "sudo 
su" first.
But of course our problems might be completely unrelated and limiting to 
one core won't change a thing ;)

Manuel

