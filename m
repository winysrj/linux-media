Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:40356 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3DWBTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 21:19:45 -0400
Date: Tue, 23 Apr 2013 10:19:41 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, matsu@igel.co.jp,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH v2 2/4] ARM: shmobile: r8a7779: add VIN support
Message-ID: <20130423011940.GH12017@verge.net.au>
References: <201304200232.33731.sergei.shtylyov@cogentembedded.com>
 <5171DD05.6020400@cogentembedded.com>
 <20130422045758.GP15680@verge.net.au>
 <51752F0D.6080805@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51752F0D.6080805@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 22, 2013 at 04:37:33PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 22-04-2013 8:57, Simon Horman wrote:
> 
> >>>From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> >>>Add VIN clocks and platform devices for R8A7779 SoC; add function to register
> >>>the VIN platform devices.
> 
> >>>Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> >>>[Sergei: added 'id' parameter check to r8a7779_add_vin_device(), renamed some
> >>>variables.]
> >>>Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> >>[...]
> 
> >>>Index: renesas/arch/arm/mach-shmobile/setup-r8a7779.c
> >>>===================================================================
> >>>--- renesas.orig/arch/arm/mach-shmobile/setup-r8a7779.c
> >>>+++ renesas/arch/arm/mach-shmobile/setup-r8a7779.c
> >>>@@ -559,6 +559,33 @@ static struct resource ether_resources[]
> >>>  	},
> >>>  };
> >>>+#define R8A7779_VIN(idx) \
> >>>+static struct resource vin##idx##_resources[] = {		\
> >>>+	DEFINE_RES_MEM(0xffc50000 + 0x1000 * (idx), 0x1000),	\
> >>>+	DEFINE_RES_IRQ(gic_iid(0x5f + (idx))),			\
> >>>+};								\
> >>>+								\
> >>>+static struct platform_device_info vin##idx##_info = {		\
> 
> >>    Hm, probably should have marked this as '__initdata'... maybe
> >>the resources too.
> 
> >That doesn't seem to be the case for other devices in
> >that or other shmobile files. Am I missing something
> >or should numerous other devices be updated?
> 
>    If the device is registered using platform_device_register_*(),
> it seems worth marking the resources, the platfrom data and 'struct
> platform_device_info' as '__initdata' as they're copied to the
> memory allocated from heap anyway and hence not needed past the init
> phase...

Thanks for the explanation, that make sense.
