Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A43C282D7
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 07:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A273A2146E
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 07:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfBBHlA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 02:41:00 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53615 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbfBBHlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Feb 2019 02:41:00 -0500
Received: from [192.168.1.192] ([188.93.81.205])
        by smtp-cloud7.xs4all.net with ESMTPA
        id ppv1gJgznBDyIppv5g3r8X; Sat, 02 Feb 2019 08:40:58 +0100
Subject: Re: [PATCH][media-next] media: vb2: remove unused variable i
To:     Colin King <colin.king@canonical.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190201180642.14328-1-colin.king@canonical.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a51e8cc0-80f5-0139-9875-0507a8d7c341@xs4all.nl>
Date:   Sat, 2 Feb 2019 08:40:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190201180642.14328-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPWxuwMB1RJqGpmXhN5VToqu6qn7xlp2hr1EmA/N28/f25E3ar1QrCPXhY8NmyQAeEvVpYVyl6eRZu72P+w/plyXqSCSoNTv3MzhXM9e2PjUbObFi7mi
 bNuVzxwwOd0dWGcLuIH5dozHRCZt8mrbzNheD/inRjTz/NfrwmHoqbN/9G3guArXM58a9vpDpG2jV32Wn+phwq433kPWBmpx9CAiKCQ99jhIec3KhN0FOfFd
 ZYmhUTO9dRdHYIbvOaOz/iITDO28khl6KF2kInsHf+VOHLGr9uECxFV+uxVupGkBR1pVkyUCGUvHx6uvjpDtUelo15D2Va718hoRpFmAy+Zp9HDW0SHsYC92
 foh5xoQZmha3coEfk2Gy4XSFyjB8/V8uZIhdJ0+Sy4bUl2ojCh40QS9zErBN8jDysjTOwy2SpYD+DY+7V8e3zawrXuqhsg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 02/01/2019 07:06 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable i is declared and never used. Fix this by removing it.

A fix for this is already pending in a pull request.

Regards,

	Hans

> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index e07b6bdb6982..34cc87ca8d59 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1769,7 +1769,6 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
>  static void __vb2_dqbuf(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	unsigned int i;
>  
>  	/* nothing to do if the buffer is already dequeued */
>  	if (vb->state == VB2_BUF_STATE_DEQUEUED)
> 

