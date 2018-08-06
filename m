Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40529 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732682AbeHFUkL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 16:40:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id j19-v6so11378003ljc.7
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 11:29:51 -0700 (PDT)
Subject: Re: [PATCH] rcar-vin: add R8A77980 support
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
References: <e7afb623-799b-17b6-cb6b-8fd839ea660a@cogentembedded.com>
 <20180806181056.GE1635@bigcity.dyn.berto.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <069d25b2-d158-0038-14de-d2598ec5ec50@cogentembedded.com>
Date: Mon, 6 Aug 2018 21:29:49 +0300
MIME-Version: 1.0
In-Reply-To: <20180806181056.GE1635@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2018 09:10 PM, Niklas Söderlund wrote:

>> Add the R8A77980 SoC support to the R-Car VIN driver.
>>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
[...]
>> --- media_tree.orig/drivers/media/platform/rcar-vin/rcar-core.c
>> +++ media_tree/drivers/media/platform/rcar-vin/rcar-core.c
>> @@ -1097,6 +1097,34 @@ static const struct rvin_info rcar_info_
>>  	.routes = rcar_info_r8a77995_routes,
>>  };
>>  
>> +static const struct rvin_group_route rcar_info_r8a77980_routes[] = {
>> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
>> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 0, .mask = BIT(2) },
>> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
>> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(1) | BIT(3) },
>> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 2, .mask = BIT(1) },
>> +	{ .csi = RVIN_CSI40, .channel = 2, .vin = 2, .mask = BIT(3) },
>> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 3, .mask = BIT(0) },
>> +	{ .csi = RVIN_CSI40, .channel = 3, .vin = 3, .mask = BIT(3) },
>> +	{ .csi = RVIN_CSI41, .channel = 0, .vin = 4, .mask = BIT(0) | BIT(3) },
>> +	{ .csi = RVIN_CSI41, .channel = 1, .vin = 4, .mask = BIT(2) },
>> +	{ .csi = RVIN_CSI41, .channel = 0, .vin = 5, .mask = BIT(2) },
>> +	{ .csi = RVIN_CSI41, .channel = 1, .vin = 5, .mask = BIT(1) | BIT(3) },
>> +	{ .csi = RVIN_CSI41, .channel = 0, .vin = 6, .mask = BIT(1) },
>> +	{ .csi = RVIN_CSI41, .channel = 2, .vin = 6, .mask = BIT(3) },
>> +	{ .csi = RVIN_CSI41, .channel = 1, .vin = 7, .mask = BIT(0) },
>> +	{ .csi = RVIN_CSI41, .channel = 3, .vin = 7, .mask = BIT(3) },
>> +	{ /* Sentinel */ }
>> +};
>> +
>> +static const struct rvin_info rcar_info_r8a77980 = {
>> +	.model = RCAR_GEN3,
>> +	.use_mc = true,
>> +	.max_width = 4096,
>> +	.max_height = 4096,
>> +	.routes = rcar_info_r8a77980_routes,
>> +};
>> +
> 
> Could you move this chunk so it fits the numerical sorting order of this 
> part of the code? That is move the chunk between the r8a77970 and 
> r8a77995 structs :-) With that fixed feel free to add

   Ugh, I've noticed the newly added SoC when rebasing to media_tree.git but
failed to updated all chunks... Sorry, will respin/repost.

> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

   Thanks!

[...]

MBR, Sergei
