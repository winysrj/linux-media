Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72992C4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AA5A21929
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437110AbfBONmy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:42:54 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37610 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbfBONmx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:42:53 -0500
Received: from [IPv6:2001:420:44c1:2579:e58e:188a:dca7:31dc] ([IPv6:2001:420:44c1:2579:e58e:188a:dca7:31dc])
        by smtp-cloud7.xs4all.net with ESMTPA
        id udlPgW74pLMwIudlTgWFwW; Fri, 15 Feb 2019 14:42:52 +0100
Subject: Re: [PATCH v2 09/10] media: vicodec: add a flag FWHT_FL_P_FRAME to
 fwht header
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190215130509.86290-1-dafna3@gmail.com>
 <20190215130509.86290-10-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2c78bae3-8729-c49d-e5e8-fe8a64a1be05@xs4all.nl>
Date:   Fri, 15 Feb 2019 14:42:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190215130509.86290-10-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKJEFuDJ2NEY/LTI4ZNItcfyp57R+ncAcnV1MQk7nqAxxLtvrngsGYh17BGnliJLMPYIb6h5jTIYKizqXxqV9KTcDSs3E8++6GIjMAAgInmtDiqG7RAW
 NVgM99zpZx7GKD2z0EaBYE9fXYgaDqhdKb0Nme1sLIEF0EZCNpehzNbeEzLji1Z81hSNQEd4qBJN2kdelsgnjxyoIyUWhdiRb/XnRg1G46+isqzT7rfE/ihq
 SJXkqyEF3auwN9qK3oMDp6cpaAA5twfTSL6TLqcm5EnM/BVNq0nSqAXPIx0+ZUqHALsrSX66jh1tyAi087tdojbtYeH3P2PPMfBBxcYZtMQPRyfoYw3xRWCT
 DxoWTMPn
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dafna,

On 2/15/19 2:05 PM, Dafna Hirschfeld wrote:
> Add the flag 'FWHT_FL_P_FRAME' to indicate that
> the frame is a p-frame so it needs the previous buffer
> as a reference frame. This is needed for the stateless
> codecs.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/codec-fwht.h      | 1 +
>  drivers/media/platform/vicodec/codec-v4l2-fwht.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> index eab4a97aa132..c2b1f3cc9fed 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-fwht.h
> @@ -76,6 +76,7 @@
>  #define FWHT_FL_CHROMA_FULL_HEIGHT	BIT(7)
>  #define FWHT_FL_CHROMA_FULL_WIDTH	BIT(8)
>  #define FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
> +#define FWHT_FL_P_FRAME			BIT(10)

I thought about this some more and I think we need two changes here:

1) invert the flag, so rename it to FWHT_FL_I_FRAME. It makes more sense
   to signal an I frame than it is to signal a P frame (there are a lot
   more P frames than I frames)

2) this requires that the version of the codec will have to be updated.
   So a stateless decoder can only handle version 3 and up.

It also means for the stateless decoder that the version number should be
part of struct v4l2_ctrl_fwht_params so the driver can reject older versions.

If possible, can you make a patch for vicodec for the current master that
implements these two changes? It would be desirable to get this in for 5.1.

Regards,

	Hans

>  
>  /* A 4-values flag - the number of components - 1 */
>  #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(18, 16)
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index 40b1f4901fd3..1c20b5685201 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -257,6 +257,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  		flags |= FWHT_FL_CR_IS_UNCOMPRESSED;
>  	if (encoding & FWHT_ALPHA_UNENCODED)
>  		flags |= FWHT_FL_ALPHA_IS_UNCOMPRESSED;
> +	if (encoding & FWHT_FRAME_PCODED)
> +		flags |= FWHT_FL_P_FRAME;
>  	if (rf.height_div == 1)
>  		flags |= FWHT_FL_CHROMA_FULL_HEIGHT;
>  	if (rf.width_div == 1)
> 

