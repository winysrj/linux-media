Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BBFC43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43E2A222D7
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfBPJi0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 04:38:26 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:3221 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726326AbfBPJi0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 04:38:26 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 634A913A0406324283DC;
        Sat, 16 Feb 2019 17:38:23 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.408.0; Sat, 16 Feb 2019
 17:38:18 +0800
Subject: Re: [PATCH -next] media: vimc: remove set but not used variable
 'frame_size'
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20190216022438.32242-1-yuehaibing@huawei.com>
 <3f24847f-0557-5660-19de-1ef003f15524@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <ae50788b-ba39-db3e-4d94-cc13ba09e6bb@huawei.com>
Date:   Sat, 16 Feb 2019 17:38:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <3f24847f-0557-5660-19de-1ef003f15524@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 2019/2/16 17:25, Hans Verkuil wrote:
> On 2/16/19 3:24 AM, YueHaibing wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/media/platform/vimc/vimc-sensor.c: In function 'vimc_sen_process_frame':
>> drivers/media/platform/vimc/vimc-sensor.c:208:15: warning:
>>  variable 'frame_size' set but not used [-Wunused-but-set-variable]
>>
>> It's never used since introduction.
> 
> A patch for this is already pending in a pull request.

Thank you for info.

> 
> Regards,
> 
> 	Hans
> 
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/media/platform/vimc/vimc-sensor.c | 7 -------
>>  1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
>> index 93961a1e694f..59195f262623 100644
>> --- a/drivers/media/platform/vimc/vimc-sensor.c
>> +++ b/drivers/media/platform/vimc/vimc-sensor.c
>> @@ -204,13 +204,6 @@ static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
>>  {
>>  	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
>>  						    ved);
>> -	const struct vimc_pix_map *vpix;
>> -	unsigned int frame_size;
>> -
>> -	/* Calculate the frame size */
>> -	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
>> -	frame_size = vsen->mbus_format.width * vpix->bpp *
>> -		     vsen->mbus_format.height;
>>  
>>  	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
>>  	return vsen->frame;
>>
>>
>>
> 
> 
> .
> 

