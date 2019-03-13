Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E165C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52FEE20854
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfCMO7X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:59:23 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:46088 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfCMO7X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 10:59:23 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 45LihlVTS4HFn45LlhPsm5; Wed, 13 Mar 2019 15:59:22 +0100
Subject: Re: [PATCH v5 03/23] cedrus: set requires_requests
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Dafna Hirschfeld <dafna3@gmail.com>,
        linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maxime Ripard <maxime.ripard@bootlin.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
 <20190306211343.15302-4-dafna3@gmail.com>
 <87eee8a06fba3882cbba472922d81cfeecd0c950.camel@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <37ad8e24-c79c-ed76-76fb-9cc2755a37b9@xs4all.nl>
Date:   Wed, 13 Mar 2019 15:59:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <87eee8a06fba3882cbba472922d81cfeecd0c950.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKYT+mdXvvXHf2oJMn4zflYbk7MqUI6BopvLBtJlnfyI+td8ECZU/t4wMsYQnAB0hKFzTsnRJOABM8VdKz86cSebPeL6elr5nilf8TCYy/ZiE4BYlcbG
 /H3ryZwGcw3+0jxoz6GoKhZW4WLAXF7Gb44n1ozfhWQccoDRx0NQx3hB0t1ny8avr5yQlafkbd/dO34KP7Ntr08tnzSMoC27VBC1LQI6mu2vyH64Fp4pzJjP
 Ar7toppd0ZyG2vrnVwpkRCVLdAS90x/GpY1bxHqO6YxmwZJxeNV/Jeu/kWy8eugeOYYf2J9ohRTSVhaPYwI1oLfVbdYSoRG+2aomWqjJC1nKupBQQVMD4Mih
 2qSxBt4T4DfXYWgLkiFR63DEJNDUx5UPR+28RdjFXcjSxmcDLwHqyJotoWXX8ys+jqM2ZInWIoT7hczh6UM1SWibi3/Gsrab1CuBgchFOhgxxj9ghS4=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/12/19 4:32 PM, Paul Kocialkowski wrote:
> Hi,
> 
> On Wed, 2019-03-06 at 13:13 -0800, Dafna Hirschfeld wrote:
>> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> The cedrus stateless decoder requires the use of request, so
>> indicate this by setting requires_requests to 1.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Note that this is true for now, but we might need to get rid of the
> flag when adding support for decoding JPEG, which may not require the
> request API.

I thought about this some more, and the flag can just be set or cleared
whenever a new format is set. I.e. when JPEG is selected, then both the
supports_requests and requires_requests flags can be set to false, and
set to true again when a non-JPEG format is set.

Regards,

	Hans

> 
> Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> 
> Cheers,
> 
> Paul
> 
>> ---
>>  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>> index b47854b3bce4..9673874ece10 100644
>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>> @@ -536,6 +536,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
>>  	src_vq->lock = &ctx->dev->dev_mutex;
>>  	src_vq->dev = ctx->dev->dev;
>>  	src_vq->supports_requests = true;
>> +	src_vq->requires_requests = true;
>>  
>>  	ret = vb2_queue_init(src_vq);
>>  	if (ret)

