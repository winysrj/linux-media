Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A855C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 18:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26DBE21872
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 18:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfBGSHY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 13:07:24 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54498 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbfBGSHY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 13:07:24 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ro52g0kg1NR5yro53g3Tpb; Thu, 07 Feb 2019 19:07:22 +0100
Subject: Re: [PATCH v4] media: vimc: Add vimc-streamer for stream control
To:     "Lucas A. M. Magalhaes" <lucmaga@gmail.com>,
        linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com, mchehab@kernel.org,
        lkcamp@lists.libreplanetbr.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190122010501.15933-1-lucmaga@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e2359d6c-5f14-14d1-fbba-7fcd8d66de5f@xs4all.nl>
Date:   Thu, 7 Feb 2019 19:07:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190122010501.15933-1-lucmaga@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDV3zibngfrRzrpTkNTL166BPu7VvkVF+Kan/6t5/prQGtMSU1TdlAaKEGs53DulLNWvqOtOtMMuAD7daQ1J5Eaez+puQP8RaL+QWiorLYYFdjfCHKRI
 z5ehOz92SVW2sIclQBqclSrPTmzTptA/rVO2vvHdU0d+1hH62brU7XkE0TAbDJrRiF28g0jOy8lwQi1mxBQU1H2i+8idyPIsEt8J+MtlNT72TJ1E2afIx9cd
 25qdFL8qgxbDlrS8B8RQkqZruTNgpiB/RMnY8BK9dOyNkh7nldk+5yWphtSn2kAQ2MEYAoHhe6SZHcfe9g9L1gFdB+gIyRvJmXoSHJ9073AXMTWg2LDJ8mqt
 ZFTeJoOuuJ0DEgu5TSk0TPAAPSKC7dmGnm8qr5NSH9xxkE6x7N4YuRnpmykcJYWQ6B9s/vFheZ6dQMgQwiHX26lfMkSsgFhJvYeBmmtYcu5bgBiqxxKL9it1
 1/CMmNsIrh5zL5ff
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Lucas,

On 1/22/19 2:05 AM, Lucas A. M. Magalhaes wrote:
> Add a linear pipeline logic for the stream control. It's created by
> walking backwards on the entity graph. When the stream starts it will
> simply loop through the pipeline calling the respective process_frame
> function of each entity.
> 
> Fixes: f2fe89061d797 ("vimc: Virtual Media Controller core, capture
> and sensor")
> Cc: stable@vger.kernel.org # for v4.20
> Signed-off-by: Lucas A. M. Magalhães <lucmaga@gmail.com>
> ---
> 
> The actual approach for streaming frames on vimc uses a recursive
> logic[1]. This algorithm may cause problems as the stack usage
> increases a with the topology. For the actual topology almost 1Kb of
> stack is used if compiled with KASAN on a 64bit architecture. However
> the topology is fixed and hard-coded on vimc-core[2]. So it's a
> controlled situation if used as is.
> 
> [1]
> The stream starts on vim-sensor's thread
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-sensor.c#n204
> It proceeds calling successively vimc_propagate_frame
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-common.c#n210
> Then processes_frame on the next entity
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-scaler.c#n349
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-debayer.c#n483
> This goes until the loop ends on a vimc-capture device
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-capture.c#n358
> 
> [2]https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-core.c#n80
> 
> Thanks the review Helen. I've made the change you pointed out. There was really
> a bug for single entity pipelines.
> 
> Changed from v3:
> * Fix vimc_streamer_pipeline_init and vimc_streamer_pipeline_terminate for a
> single entity pipeline.
> * Remove unnecessary checks and comments.
> * Alignment and style.
> 
>  drivers/media/platform/vimc/Makefile        |   3 +-
>  drivers/media/platform/vimc/vimc-capture.c  |  18 +-
>  drivers/media/platform/vimc/vimc-common.c   |  35 ----
>  drivers/media/platform/vimc/vimc-common.h   |  15 +-
>  drivers/media/platform/vimc/vimc-debayer.c  |  26 +--
>  drivers/media/platform/vimc/vimc-scaler.c   |  28 +--
>  drivers/media/platform/vimc/vimc-sensor.c   |  56 ++----
>  drivers/media/platform/vimc/vimc-streamer.c | 188 ++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-streamer.h |  38 ++++
>  9 files changed, 260 insertions(+), 147 deletions(-)
>  create mode 100644 drivers/media/platform/vimc/vimc-streamer.c
>  create mode 100644 drivers/media/platform/vimc/vimc-streamer.h
> 

<snip>

> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index 32ca9c6172b1..93961a1e694f 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -16,8 +16,6 @@
>   */
>  
>  #include <linux/component.h>
> -#include <linux/freezer.h>
> -#include <linux/kthread.h>
>  #include <linux/module.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/platform_device.h>
> @@ -201,38 +199,27 @@ static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
>  	.set_fmt		= vimc_sen_set_fmt,
>  };
>  
> -static int vimc_sen_tpg_thread(void *data)
> +static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
> +				    const void *sink_frame)
>  {
> -	struct vimc_sen_device *vsen = data;
> -	unsigned int i;
> -
> -	set_freezable();
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> -
> -	for (;;) {
> -		try_to_freeze();
> -		if (kthread_should_stop())
> -			break;
> -
> -		tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
> +	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
> +						    ved);
> +	const struct vimc_pix_map *vpix;
> +	unsigned int frame_size;
>  
> -		/* Send the frame to all source pads */
> -		for (i = 0; i < vsen->sd.entity.num_pads; i++)
> -			vimc_propagate_frame(&vsen->sd.entity.pads[i],
> -					     vsen->frame);
> +	/* Calculate the frame size */
> +	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
> +	frame_size = vsen->mbus_format.width * vpix->bpp *
> +		     vsen->mbus_format.height;

frame_size is set, but not used:

vimc-sensor.c:208:15: warning: variable 'frame_size' set but not used [-Wunused-but-set-variable]

Can you make a patch fixing this?

I'm not sure how I missed this sparse warning, weird.

>  
> -		/* 60 frames per second */
> -		schedule_timeout(HZ/60);
> -	}
> -
> -	return 0;
> +	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
> +	return vsen->frame;
>  }

Regards,

	Hans
