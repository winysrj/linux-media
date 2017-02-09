Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:65261 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752896AbdBIPhm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 10:37:42 -0500
Subject: Re: [PATCH 08/10] ARM: davinci: fix the DT boot on da850-evm
To: Kevin Hilman <khilman@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
 <1486485683-11427-9-git-send-email-bgolaszewski@baylibre.com>
 <m2fujpkgkg.fsf@baylibre.com>
CC: Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>
From: Sekhar Nori <nsekhar@ti.com>
Message-ID: <4574d1c3-c169-b158-dba6-f1965a1056b0@ti.com>
Date: Thu, 9 Feb 2017 20:53:02 +0530
MIME-Version: 1.0
In-Reply-To: <m2fujpkgkg.fsf@baylibre.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 07 February 2017 11:51 PM, Kevin Hilman wrote:
> Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:
> 
>> When we enable vpif capture on the da850-evm we hit a BUG_ON() because
>> the i2c adapter can't be found. The board file boot uses i2c adapter 1
>> but in the DT mode it's actually adapter 0. Drop the problematic lines.
>>
>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>> ---
>>  arch/arm/mach-davinci/pdata-quirks.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
>> index 94948c1..09f62ac 100644
>> --- a/arch/arm/mach-davinci/pdata-quirks.c
>> +++ b/arch/arm/mach-davinci/pdata-quirks.c
>> @@ -116,10 +116,6 @@ static void __init da850_vpif_legacy_init(void)
>>  	if (of_machine_is_compatible("ti,da850-lcdk"))
>>  		da850_vpif_capture_config.subdev_count = 1;
>>  
>> -	/* EVM (UI card) uses i2c adapter 1 (not default: zero) */
>> -	if (of_machine_is_compatible("ti,da850-evm"))
>> -		da850_vpif_capture_config.i2c_adapter_id = 1;
>> -
> 
> oops, my bad.
> 
> Acked-by: Kevin Hilman <khilman@baylibre.com>

The offending code is not in my master branch. Since its almost certain
that VPIF platform support is going to wait for v4.12, can you or Kevin
please update Kevin's original patches with these fixes rolled in?

Thanks,
Sekhar

