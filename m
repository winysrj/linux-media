Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40103 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3DVMiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:38:46 -0400
Received: by mail-lb0-f170.google.com with SMTP id 13so2432359lba.29
        for <linux-media@vger.kernel.org>; Mon, 22 Apr 2013 05:38:45 -0700 (PDT)
Message-ID: <51752F0D.6080805@cogentembedded.com>
Date: Mon, 22 Apr 2013 16:37:33 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, matsu@igel.co.jp,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH v2 2/4] ARM: shmobile: r8a7779: add VIN support
References: <201304200232.33731.sergei.shtylyov@cogentembedded.com> <5171DD05.6020400@cogentembedded.com> <20130422045758.GP15680@verge.net.au>
In-Reply-To: <20130422045758.GP15680@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 22-04-2013 8:57, Simon Horman wrote:

>>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

>>> Add VIN clocks and platform devices for R8A7779 SoC; add function to register
>>> the VIN platform devices.

>>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>> [Sergei: added 'id' parameter check to r8a7779_add_vin_device(), renamed some
>>> variables.]
>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> [...]

>>> Index: renesas/arch/arm/mach-shmobile/setup-r8a7779.c
>>> ===================================================================
>>> --- renesas.orig/arch/arm/mach-shmobile/setup-r8a7779.c
>>> +++ renesas/arch/arm/mach-shmobile/setup-r8a7779.c
>>> @@ -559,6 +559,33 @@ static struct resource ether_resources[]
>>>   	},
>>>   };
>>> +#define R8A7779_VIN(idx) \
>>> +static struct resource vin##idx##_resources[] = {		\
>>> +	DEFINE_RES_MEM(0xffc50000 + 0x1000 * (idx), 0x1000),	\
>>> +	DEFINE_RES_IRQ(gic_iid(0x5f + (idx))),			\
>>> +};								\
>>> +								\
>>> +static struct platform_device_info vin##idx##_info = {		\

>>     Hm, probably should have marked this as '__initdata'... maybe
>> the resources too.

> That doesn't seem to be the case for other devices in
> that or other shmobile files. Am I missing something
> or should numerous other devices be updated?

    If the device is registered using platform_device_register_*(), it seems 
worth marking the resources, the platfrom data and 'struct 
platform_device_info' as '__initdata' as they're copied to the memory 
allocated from heap anyway and hence not needed past the init phase...

WBR, Sergei

