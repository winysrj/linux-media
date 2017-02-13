Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:34168 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751808AbdBMSf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 13:35:57 -0500
Received: by mail-ot0-f176.google.com with SMTP id f9so75112209otd.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 10:35:57 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
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
Subject: Re: [PATCH 08/10] ARM: davinci: fix the DT boot on da850-evm
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-9-git-send-email-bgolaszewski@baylibre.com>
        <m2fujpkgkg.fsf@baylibre.com>
        <4574d1c3-c169-b158-dba6-f1965a1056b0@ti.com>
Date: Mon, 13 Feb 2017 10:35:55 -0800
In-Reply-To: <4574d1c3-c169-b158-dba6-f1965a1056b0@ti.com> (Sekhar Nori's
        message of "Thu, 9 Feb 2017 20:53:02 +0530")
Message-ID: <m2shnidjlg.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar Nori <nsekhar@ti.com> writes:

> On Tuesday 07 February 2017 11:51 PM, Kevin Hilman wrote:
>> Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:
>> 
>>> When we enable vpif capture on the da850-evm we hit a BUG_ON() because
>>> the i2c adapter can't be found. The board file boot uses i2c adapter 1
>>> but in the DT mode it's actually adapter 0. Drop the problematic lines.
>>>
>>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>>> ---
>>>  arch/arm/mach-davinci/pdata-quirks.c | 4 ----
>>>  1 file changed, 4 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
>>> index 94948c1..09f62ac 100644
>>> --- a/arch/arm/mach-davinci/pdata-quirks.c
>>> +++ b/arch/arm/mach-davinci/pdata-quirks.c
>>> @@ -116,10 +116,6 @@ static void __init da850_vpif_legacy_init(void)
>>>  	if (of_machine_is_compatible("ti,da850-lcdk"))
>>>  		da850_vpif_capture_config.subdev_count = 1;
>>>  
>>> -	/* EVM (UI card) uses i2c adapter 1 (not default: zero) */
>>> -	if (of_machine_is_compatible("ti,da850-evm"))
>>> -		da850_vpif_capture_config.i2c_adapter_id = 1;
>>> -
>> 
>> oops, my bad.
>> 
>> Acked-by: Kevin Hilman <khilman@baylibre.com>
>
> The offending code is not in my master branch. Since its almost certain
> that VPIF platform support is going to wait for v4.12, can you or Kevin
> please update Kevin's original patches with these fixes rolled in?

I'm folding this into the original patch.

Kevin
