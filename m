Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5704C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78BDD222DD
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 09:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbfBPJZo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 04:25:44 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:52951 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728307AbfBPJZo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 04:25:44 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id uwE6geTTdLMwIuwEAgaD7q; Sat, 16 Feb 2019 10:25:42 +0100
Subject: Re: [PATCH -next] media: vimc: remove set but not used variable
 'frame_size'
To:     YueHaibing <yuehaibing@huawei.com>,
        Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190216022438.32242-1-yuehaibing@huawei.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3f24847f-0557-5660-19de-1ef003f15524@xs4all.nl>
Date:   Sat, 16 Feb 2019 10:25:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190216022438.32242-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfExf8fQ/8OjIu50o+r0tltSEomYCfGUlW5Qj0chBOu7xfLGUjFcxj+wpenCBjvn3K6z+p/0wHczV408RDSubz0wqnmYyVkjlhzFIUyo2pSS5y6f1GUnF
 hyD8O13PO5hDRFrbCxUiOX9tdCQWWhkALZKVWabgOcy1BPUX24II7qIil5Us0Abvubsi4dLqTZUviKLyQSRY6a1+vnM2kDorUPshQUPqITs8yyqPWYjCj0jW
 4d3F8h0aiEisg5oTDcq4irQiZRwIlM7wYicWDgS7i1GOhn3Rrbt08CnRTIxel/S2KnvxCvmDcB8DmUCXR2MmwLwKGvYoAARrAnJP6OArIMs=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/16/19 3:24 AM, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/media/platform/vimc/vimc-sensor.c: In function 'vimc_sen_process_frame':
> drivers/media/platform/vimc/vimc-sensor.c:208:15: warning:
>  variable 'frame_size' set but not used [-Wunused-but-set-variable]
> 
> It's never used since introduction.

A patch for this is already pending in a pull request.

Regards,

	Hans

> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/media/platform/vimc/vimc-sensor.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index 93961a1e694f..59195f262623 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -204,13 +204,6 @@ static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
>  {
>  	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
>  						    ved);
> -	const struct vimc_pix_map *vpix;
> -	unsigned int frame_size;
> -
> -	/* Calculate the frame size */
> -	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
> -	frame_size = vsen->mbus_format.width * vpix->bpp *
> -		     vsen->mbus_format.height;
>  
>  	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
>  	return vsen->frame;
> 
> 
> 

