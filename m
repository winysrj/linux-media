Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6429C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8722920449
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfCHONz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:13:55 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47173 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbfCHONy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 09:13:54 -0500
Received: from [IPv6:2001:420:44c1:2579:1aa:f05e:8209:429d] ([IPv6:2001:420:44c1:2579:1aa:f05e:8209:429d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 2GFxh2MfZ4HFn2GG1h26pm; Fri, 08 Mar 2019 15:13:53 +0100
Subject: Re: [PATCHv4 7/9] vimc: zero the media_device on probe
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
References: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
 <20190308135625.11278-8-hverkuil-cisco@xs4all.nl>
 <20190308140909.GL4802@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <eb52fba3-587c-5e59-5f3a-8c818bf413cd@xs4all.nl>
Date:   Fri, 8 Mar 2019 15:13:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190308140909.GL4802@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPobihu2fEz3uQljqmp8wsnzVwXfAtxz3puQ6Y/ARbxpD6AKLLDRg279rb3GoxOF55Lj1ec7s73KyFLo4PG0xxumHDAHwpKuixY3j9YDW6pAuHBfzQ8K
 epi/t6xA9rA+jZTKBvEnDFTzI0eoRKcrDfaKBYYrkoygCZR3r0nrEOwst45OBjCQkfxcBtXUIekWRdFBi4N2I1P52lE+V5EKQXNwTx3F4WZeBHQnuQwV/82p
 qJc9dWW52fesNjGexzt/ZtQlEMGKw6X5NWrFnuw1cM+063RuppfA5MEqiRZfAXIBloG1HYACskqm0/6fr6ldBB0+na8bj3wjmZPtmJmJX8NPk0o79XquqkPK
 XJ6kP7sWqo0E0oISWjI94p3ZsVIk4A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/8/19 3:09 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Fri, Mar 08, 2019 at 02:56:23PM +0100, Hans Verkuil wrote:
>> The media_device is part of a static global vimc_device struct.
>> The media framework expects this to be zeroed before it is
>> used, however, since this is a global this is not the case if
>> vimc is unbound and then bound again.
>>
>> So call memset to ensure any left-over values are cleared.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Do I recall correctly that you mentioned there's work in progress that
> will allocate this dynamically ? If so feel free to mention it in the
> commit message if you want.

There is, but it might take some time before that will land (it's Helen's
patch series that converts vimc to use configfs to configure all the
subdevs and topology).

Regards,

	Hans

> 
>> ---
>>  drivers/media/platform/vimc/vimc-core.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
>> index 0fbb7914098f..3aa62d7e3d0e 100644
>> --- a/drivers/media/platform/vimc/vimc-core.c
>> +++ b/drivers/media/platform/vimc/vimc-core.c
>> @@ -304,6 +304,8 @@ static int vimc_probe(struct platform_device *pdev)
>>  
>>  	dev_dbg(&pdev->dev, "probe");
>>  
>> +	memset(&vimc->mdev, 0, sizeof(vimc->mdev));
>> +
>>  	/* Create platform_device for each entity in the topology*/
>>  	vimc->subdevs = devm_kcalloc(&vimc->pdev.dev, vimc->pipe_cfg->num_ents,
>>  				     sizeof(*vimc->subdevs), GFP_KERNEL);
> 

