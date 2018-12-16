Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22756C43387
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 11:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5FE72086C
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 11:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbeLPLaz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 16 Dec 2018 06:30:55 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55651 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730145AbeLPLay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Dec 2018 06:30:54 -0500
Received: from [IPv6:2001:983:e9a7:1:f082:bc65:7eed:3c74] ([IPv6:2001:983:e9a7:1:f082:bc65:7eed:3c74])
        by smtp-cloud9.xs4all.net with ESMTPA
        id YUdHgQ0ZuMlDTYUdIgYQRf; Sun, 16 Dec 2018 12:30:53 +0100
Subject: Re: [PATCH] media: vicodec: bugfix - replace '=' with '|='
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20181215115119.2732-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b9ef022-be49-682f-0316-b1f735033caf@xs4all.nl>
Date:   Sun, 16 Dec 2018 12:30:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181215115119.2732-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMyHt2+0o3IpFtV5O94gQhZ+koJqO7omz3U0HjwsueQibFzhuUnlJ89aIaoY4o1J614h62oBqlvQ5KYypoIM9j0W9OKobBzFwyY1I98FMVRmFaKzCzfQ
 X4ELDVkIWba8qSTRfQ4DC3+W50n7C+7YvJAaAOxnk33aWa+W1BTFieNGrj4/VeBnFeMTnwpmls9dpn4KCxK+TR6kkdACnHBKeynZbSWdhfNaHOSHqtxihchl
 1QVyrD7l37EgIDEGqq/wfN7E+rZBZhYJWIM3mJ1EyBMCtMh0jn19rXL1iNQoiLDX5fOElBRsSAKjNPU9tlQbzNycR8pKSF6BIgK26agdtXI=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/15/18 12:51 PM, Dafna Hirschfeld wrote:
> In the function fwht_encode_frame, 'encoding = encode_plane'
> should be replaced with 'encoding |= encode_plane'
> so existing flags won't be overwrriten.

Good catch.

Hmm, it looks like you didn't update the alignment of the arguments.
I expect checkpatch to complain about it. Can you post a v2 fixing that?

Regards,

	Hans

> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/codec-fwht.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> index 5630f1dc45e6..a678a716580c 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-fwht.c
> @@ -787,7 +787,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>  
>  	if (frm->components_num == 4) {
>  		rlco_max = rlco + size / 2 - 256;
> -		encoding = encode_plane(frm->alpha, ref_frm->alpha, &rlco,
> +		encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
>  					rlco_max, cf, frm->height, frm->width,
>  					frm->luma_alpha_step,
>  					is_intra, next_is_intra);
> 

