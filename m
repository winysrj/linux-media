Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37863 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751856AbdDCIfm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:35:42 -0400
Subject: Re: [PATCH] [media] vcodec: mediatek: Remove double parentheses
To: Matthias Kaehlcke <mka@chromium.org>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20170317210133.9662-1-mka@chromium.org>
 <20170331235850.GB2130@google.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        PoChun Lin <pochun.lin@mediatek.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b515fcac-fc62-484b-ddb5-2cf7b1ad8364@xs4all.nl>
Date: Mon, 3 Apr 2017 10:35:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170331235850.GB2130@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/01/2017 01:58 AM, Matthias Kaehlcke wrote:
> El Fri, Mar 17, 2017 at 02:01:33PM -0700 Matthias Kaehlcke ha dit:
> 
>> The extra pairs of parentheses are not needed and cause clang
>> warnings like this:
>>
>> drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:158:32: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
>>                 if ((inst->work_bufs[i].size == 0))
>>                      ~~~~~~~~~~~~~~~~~~~~~~~~^~~~
>> drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:158:32: note: remove extraneous parentheses around the comparison to silence this warning
>>                 if ((inst->work_bufs[i].size == 0))
>>                     ~                        ^   ~
>> drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:158:32: note: use '=' to turn this equality comparison into an assignment
>>                 if ((inst->work_bufs[i].size == 0))
>>                                              ^~
>>                                              =
>>
>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> ---
>>  drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
>> index 544f57186243..129cc74b4fe4 100644
>> --- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
>> +++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
>> @@ -155,7 +155,7 @@ static void vp8_enc_free_work_buf(struct venc_vp8_inst *inst)
>>  
>>  	/* Buffers need to be freed by AP. */
>>  	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_MAX; i++) {
>> -		if ((inst->work_bufs[i].size == 0))
>> +		if (inst->work_bufs[i].size == 0)
>>  			continue;
>>  		mtk_vcodec_mem_free(inst->ctx, &inst->work_bufs[i]);
>>  	}
>> @@ -172,7 +172,7 @@ static int vp8_enc_alloc_work_buf(struct venc_vp8_inst *inst)
>>  	mtk_vcodec_debug_enter(inst);
>>  
>>  	for (i = 0; i < VENC_VP8_VPU_WORK_BUF_MAX; i++) {
>> -		if ((wb[i].size == 0))
>> +		if (wb[i].size == 0)
>>  			continue;
>>  		/*
>>  		 * This 'wb' structure is set by VPU side and shared to AP for
> 
> Ping? Any feedback on this patch?
> 
> Cheers
> 
> Matthias
> 

It's part of a pull request that is waiting to be merged. Just be patient.

Regards,

	Hans
