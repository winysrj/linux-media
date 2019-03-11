Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4431C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B00C32075C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfCKORg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:17:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727219AbfCKORg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:17:36 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 097FB1E608FAF29DBC18;
        Mon, 11 Mar 2019 22:17:34 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Mon, 11 Mar 2019
 22:17:30 +0800
Subject: Re: [PATCH] staging: davinci: drop pointless static qualifier in
 vpfe_resizer_init()
To:     Dan Carpenter <dan.carpenter@oracle.com>
References: <20190311141405.123611-1-maowenan@huawei.com>
 <20190311140733.GG2434@kadam>
CC:     <gregkh@linuxfoundation.org>, <Julia.Lawall@lip6.fr>,
        <kimbrownkd@gmail.com>, <colin.king@canonical.com>,
        <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <kernel-janitors@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <7021aa62-e311-edfc-68b2-3a5dba11118f@huawei.com>
Date:   Mon, 11 Mar 2019 22:17:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190311140733.GG2434@kadam>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2019/3/11 22:07, Dan Carpenter wrote:
> On Mon, Mar 11, 2019 at 10:14:05PM +0800, Mao Wenan wrote:
>> There is no need to have the 'T *v' variable static
>> since new value always be assigned before use it.
>>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> ---
>>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
>> index 6098f43ac51b..a2a672d4615d 100644
>> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
>> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
>> @@ -1881,7 +1881,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
>>  	struct v4l2_subdev *sd = &vpfe_rsz->crop_resizer.subdev;
>>  	struct media_pad *pads = &vpfe_rsz->crop_resizer.pads[0];
>>  	struct media_entity *me = &sd->entity;
>> -	static resource_size_t  res_len;
>> +	resource_size_t  res_len;
>                         ^
> Could you remove the extra space character also, please.

sure, I will do this, sorry, I don't pay attention to the old code style.
> 
>>  	struct resource *res;
>>  	int ret;
> 
> regards,
> dan carpenter
> 
> 
> 
> .
> 

