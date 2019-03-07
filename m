Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE468C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 20:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8846720854
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 20:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfCGUWe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 15:22:34 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39136 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfCGUWe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 15:22:34 -0500
Received: from [IPv6:2804:431:d719:9975:b343:652b:e214:3dca] (unknown [IPv6:2804:431:d719:9975:b343:652b:e214:3dca])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tonyk)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id CCD4C2639A6;
        Thu,  7 Mar 2019 20:22:30 +0000 (GMT)
Subject: Re: [PATCH 7/8] media: vimc: stream: init/terminate the first entity
To:     Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@collabora.com
References: <20190306224244.21070-1-helen.koike@collabora.com>
 <20190306224244.21070-8-helen.koike@collabora.com>
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>
Message-ID: <dbcba9a6-6100-2f21-c95c-963bb1ff9ce6@collabora.com>
Date:   Thu, 7 Mar 2019 17:21:41 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190306224244.21070-8-helen.koike@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/6/19 7:42 PM, Helen Koike wrote:
> The s_stream callback was not being called for the first entity in the
> stream pipeline array.
> Instead of verifying the type of the node (video or subdevice) and
> calling s_stream from the second entity in the pipeline, do this process
> for all the entities in the pipeline for consistency.
>
> The previous code was not a problem because the first entity is a video
> device and not a subdevice, but this patch prepares vimc to allow
> setting some configuration in the entity before calling s_stream.
>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
Hello,

I've tested the stream (with the default media bus format and using an 
alternative one) using a custom user space application and tested all 
capture entities using qv4l2 -d /dev/videoX (where X is each of the 
capture entities). Also, I have checked v4l2-compliance -d /dev/videoX 
and with v4l2-compliance --streaming=5 -d /dev/videoX and no regressions 
where found.

Tested-by: André Almeida <andre.almeida@collabora.com>
> ---
>
>   drivers/media/platform/vimc/vimc-streamer.c | 25 ++++++++++++---------
>   1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
> index b7c1fdef5f0d..5a3bda62fbc8 100644
> --- a/drivers/media/platform/vimc/vimc-streamer.c
> +++ b/drivers/media/platform/vimc/vimc-streamer.c
> @@ -46,19 +46,18 @@ static struct media_entity *vimc_get_source_entity(struct media_entity *ent)
>    */
>   static void vimc_streamer_pipeline_terminate(struct vimc_stream *stream)
>   {
> -	struct media_entity *entity;
> +	struct vimc_ent_device *ved;
>   	struct v4l2_subdev *sd;
>   
>   	while (stream->pipe_size) {
>   		stream->pipe_size--;
> -		entity = stream->ved_pipeline[stream->pipe_size]->ent;
> -		entity = vimc_get_source_entity(entity);
> +		ved = stream->ved_pipeline[stream->pipe_size];
>   		stream->ved_pipeline[stream->pipe_size] = NULL;
>   
> -		if (!is_media_entity_v4l2_subdev(entity))
> +		if (!is_media_entity_v4l2_subdev(ved->ent))
>   			continue;
>   
> -		sd = media_entity_to_v4l2_subdev(entity);
> +		sd = media_entity_to_v4l2_subdev(ved->ent);
>   		v4l2_subdev_call(sd, video, s_stream, 0);
>   	}
>   }
> @@ -89,18 +88,24 @@ static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
>   		}
>   		stream->ved_pipeline[stream->pipe_size++] = ved;
>   
> +		if (is_media_entity_v4l2_subdev(ved->ent)) {
> +			sd = media_entity_to_v4l2_subdev(ved->ent);
> +			ret = v4l2_subdev_call(sd, video, s_stream, 1);
> +			if (ret && ret != -ENOIOCTLCMD) {
> +				pr_err("subdev_call error %s\n", ved->ent->name);
> +				vimc_streamer_pipeline_terminate(stream);
> +				return ret;
> +			}
> +		}
> +
>   		entity = vimc_get_source_entity(ved->ent);
>   		/* Check if the end of the pipeline was reached*/
>   		if (!entity)
>   			return 0;
>   
> +		/* Get the next device in the pipeline */
>   		if (is_media_entity_v4l2_subdev(entity)) {
>   			sd = media_entity_to_v4l2_subdev(entity);
> -			ret = v4l2_subdev_call(sd, video, s_stream, 1);
> -			if (ret && ret != -ENOIOCTLCMD) {
> -				vimc_streamer_pipeline_terminate(stream);
> -				return ret;
> -			}
>   			ved = v4l2_get_subdevdata(sd);
>   		} else {
>   			vdev = container_of(entity,
