Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33314 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbcE0SSo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 14:18:44 -0400
Received: by mail-lb0-f174.google.com with SMTP id k7so33549328lbm.0
        for <linux-media@vger.kernel.org>; Fri, 27 May 2016 11:18:43 -0700 (PDT)
Subject: Re: [PATCH 8/8] [media] rcar-vin: add Gen2 and Gen3 fallback
 compatibility strings
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
 <1464203409-1279-9-git-send-email-niklas.soderlund@ragnatech.se>
 <26f0ba3a-2324-23ce-0933-452fe7e16542@cogentembedded.com>
 <20160527113656.GI8307@bigcity.dyn.berto.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <3c671425-a949-6a6d-c162-6a6e793ac76b@cogentembedded.com>
Date: Fri, 27 May 2016 21:18:39 +0300
MIME-Version: 1.0
In-Reply-To: <20160527113656.GI8307@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 05/27/2016 02:36 PM, Niklas Söderlund wrote:

>>> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>
>>> These are present in the soc-camera version of this driver and it's time
>>> to add them to this driver as well.
>>>
>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>> ---
>>>  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
>>> index 520690c..87041db 100644
>>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>>> @@ -33,6 +33,8 @@ static const struct of_device_id rvin_of_id_table[] = {
>>>  	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
>>>  	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
>>>  	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
>>> +	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
>>> +	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
>>
>>    What's the point of adding the H3 specific compatibility string in the
>> previous patch then? The fallback stings were added not have to updated the
>> driver for every new SoC exactly.
>
> Since this driver aims to replace the previous R-Car VIN driver which
> uses soc-camera I think it also should contain all the compatibility
> strings that the soc-camera driver do.

    Indeed. And I'm not seeing the gen2/3 strings there yet (I thought Simon 
had already pushed them there). Nevermind then.

MBR, Sergei

