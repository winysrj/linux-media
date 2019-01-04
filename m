Return-Path: <SRS0=+L2G=PM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1159C43387
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 12:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A6122070C
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 12:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfADMaj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:30:39 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39048 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726931AbfADMaj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Jan 2019 07:30:39 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id fOcTg8oEvNR5yfOcXgoUex; Fri, 04 Jan 2019 13:30:38 +0100
Subject: Re: [PATCH v6] media: vicodec: add support for CROP and COMPOSE
 selection
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190104102915.6687-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <79dca97b-7f40-5cac-d28b-985912fa8636@xs4all.nl>
Date:   Fri, 4 Jan 2019 13:30:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190104102915.6687-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOiil1Udcz/EBLCPZD6djYLNu87Qan1WnTdJ18MEQcbO3YrY1UaqPj82hqvN55gV2F3W9gOKUExfnHN6H0qNZi7txSwbsCh8wfUBdmnaLYKK0rdX+xHj
 CAO2z1AmtLlWcZL+D2STbKs6opGLGSWugb3kCnGVDzVfrZabpzc2PdVoObbt0F+9KORN7Yd5rR5dzm83M9m2qelGwYzm0dQDmYXzeIsiu18/PBLBFo3jQw5/
 4SAZsby80ATXmX8swwOG3A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/04/2019 11:29 AM, Dafna Hirschfeld wrote:
> Add support for the selection api for the crop and compose targets.
> The driver rounds up the coded width and height such that
> all planes dimensions are multiple of 8.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
> This patch temporarily dysfunction vicoded since it does not

vicoded -> vicodec

> allow setting the visible resolution for the decoder.

Actually, this patch doesn't break anything in vicodec. Currently vicodec doesn't
support padding at all, so there is no loss of functionality.

> Next patch will fix it by adding resolution-change event
> after reading the first compressed frame header.
> 
> Main changes from v5:
> - Replace 'coded_width*step' with 'stride' in order to get the offset of next row
> - allow setting only CROP selection for the encoder.
> 
>  drivers/media/platform/vicodec/codec-fwht.c   |  80 +++--
>  drivers/media/platform/vicodec/codec-fwht.h   |  17 +-
>  .../media/platform/vicodec/codec-v4l2-fwht.c  | 290 ++++++++++++------
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |   7 +-
>  drivers/media/platform/vicodec/vicodec-core.c | 150 +++++++--
>  5 files changed, 382 insertions(+), 162 deletions(-)
> 

Other than the commit message which needs a bit more work, this patch looks good!

So the next patch will deal with the decoder, correctly detecting the resolution from the
header. Once that's ready I should be able to merge everything and you can start work on
the stateless codec.

BTW, the next time you post your changes, post all the pending changes, so include
"[PATCH] media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info".

It's easier to keep track for me if I see all the changes made on top of the current
master branch.

Regards,

	Hans
