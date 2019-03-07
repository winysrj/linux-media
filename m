Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B348FC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 20:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B52520840
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 20:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfCGUUI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 15:20:08 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39124 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfCGUUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 15:20:08 -0500
Received: from [IPv6:2804:431:d719:9975:b343:652b:e214:3dca] (unknown [IPv6:2804:431:d719:9975:b343:652b:e214:3dca])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tonyk)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 69626260A49;
        Thu,  7 Mar 2019 20:20:05 +0000 (GMT)
Subject: Re: [PATCH 5/8] media: vimc: stream: cleanup frame field from struct
 vimc_stream
To:     Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@collabora.com
References: <20190306224244.21070-1-helen.koike@collabora.com>
 <20190306224244.21070-6-helen.koike@collabora.com>
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>
Message-ID: <adbfa62c-e5f6-4c24-76b4-cac299cdd800@collabora.com>
Date:   Thu, 7 Mar 2019 17:19:15 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190306224244.21070-6-helen.koike@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

I've tested the stream (with the default media bus format and using an 
alternative one) using a custom user space application and tested all 
capture entities using qv4l2 -d /dev/videoX (where X is each of the 
capture entities). Also, I have checked v4l2-compliance -d /dev/videoX 
and with v4l2-compliance --streaming=5 -d /dev/videoX and no regressions 
where found.

On 3/6/19 7:42 PM, Helen Koike wrote:
> There is no need to have the frame field in the vimc_stream struct.
>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
Tested-by: André Almeida <andre.almeida@collabora.com>
> ---
>
>   drivers/media/platform/vimc/vimc-streamer.c | 10 ++++------
>   drivers/media/platform/vimc/vimc-streamer.h |  1 -
>   2 files changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
> index 392754c18046..b7c1fdef5f0d 100644
> --- a/drivers/media/platform/vimc/vimc-streamer.c
> +++ b/drivers/media/platform/vimc/vimc-streamer.c
> @@ -117,6 +117,7 @@ static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
>   static int vimc_streamer_thread(void *data)
>   {
>   	struct vimc_stream *stream = data;
> +	u8 *frame = NULL;
>   	int i;
>   
>   	set_freezable();
> @@ -127,12 +128,9 @@ static int vimc_streamer_thread(void *data)
>   			break;
>   
>   		for (i = stream->pipe_size - 1; i >= 0; i--) {
> -			stream->frame = stream->ved_pipeline[i]->process_frame(
> -					stream->ved_pipeline[i],
> -					stream->frame);
> -			if (!stream->frame)
> -				break;
> -			if (IS_ERR(stream->frame))
> +			frame = stream->ved_pipeline[i]->process_frame(
> +					stream->ved_pipeline[i], frame);
> +			if (!frame || IS_ERR(frame))
>   				break;
>   		}
>   		//wait for 60hz
> diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/media/platform/vimc/vimc-streamer.h
> index 752af2e2d5a2..dc1d0be431cb 100644
> --- a/drivers/media/platform/vimc/vimc-streamer.h
> +++ b/drivers/media/platform/vimc/vimc-streamer.h
> @@ -19,7 +19,6 @@ struct vimc_stream {
>   	struct media_pipeline pipe;
>   	struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
>   	unsigned int pipe_size;
> -	u8 *frame;
>   	struct task_struct *kthread;
>   };
>   
