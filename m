Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A77C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998EF2087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfARIzC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:55:02 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60298 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbfARIzB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:55:01 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kPvWgbwAoaxzfkPvXgocbt; Fri, 18 Jan 2019 09:54:59 +0100
Subject: Re: [PATCH v3 6/6] media: vicodec: Add support for resolution change
 event.
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190117182319.118359-1-dafna3@gmail.com>
 <20190117182319.118359-7-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <216cbb31-874e-1cfe-f971-da4650e2ca80@xs4all.nl>
Date:   Fri, 18 Jan 2019 09:54:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190117182319.118359-7-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPpGx7RLyQProbuLOyjqWwe3aYRf8C7DK92ebB0+bCQQehC8THZTZafmuhLbLS+YX/pfgrUXYngSwfzb5I+Zr/0ltPGU1/kjOWtdwYHge3PvXQHiXwQb
 cesjdhwnCb0wNrlGdDZrlPCImcJescho/3aq+eJPWz0jbWsuarHJf5WBeO6JFcOfLnvHvb3w+7DhQvw2hwa3DO4G8/q9DnIrokegGSCJ25lD9j9Nqkcz+V3K
 bCxOJ3jbXEX5C8nyDenMNDsANB28Q9buDLiKTqF8QGX5OwVSr+8/x9EgRIyZSEU2NdhDcKlOl+hnOpRY9rlufsJVtdnZbtBZ2WkLTPZYDY0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/17/19 7:23 PM, Dafna Hirschfeld wrote:
> If the the queues are not streaming then the first resolution
> change is handled in the buf_queue callback.
> The following resolution change events are handled in job_ready.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 355 ++++++++++++++----
>  1 file changed, 290 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 2a95eca3cae6..6430c18b8f94 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -129,6 +129,8 @@ struct vicodec_ctx {
>  	u32			comp_frame_size;
>  	bool			comp_has_frame;
>  	bool			comp_has_next_frame;
> +	bool			first_source_change_sent;
> +	bool			source_changed;
>  };
>  
>  static inline struct vicodec_ctx *file2ctx(struct file *file)
> @@ -322,6 +324,95 @@ static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
>  	spin_unlock(ctx->lock);
>  }
>  
> +static const struct v4l2_fwht_pixfmt_info *info_from_header(struct fwht_cframe_hdr p_hdr)

Don't copy the struct, just use const struct fwht_cframe_hdr *p_hdr.

> +{
> +	unsigned int flags = ntohl(p_hdr.flags);
> +	unsigned int width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
> +	unsigned int height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
> +	unsigned int components_num = 3;
> +	unsigned int pixenc = 0;
> +	unsigned int version = ntohl(p_hdr.version);
> +
> +	if (version == FWHT_VERSION) {
> +		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
> +				FWHT_FL_COMPONENTS_NUM_OFFSET);
> +		pixenc = (flags & FWHT_FL_PIXENC_MSK);
> +	}
> +	return v4l2_fwht_default_fmt(width_div, height_div,
> +				     components_num, pixenc, 0);
> +}
> +
> +static bool is_header_valid(struct fwht_cframe_hdr p_hdr)

Ditto.

> +{
> +	const struct v4l2_fwht_pixfmt_info *info;
> +	unsigned int w = ntohl(p_hdr.width);
> +	unsigned int h = ntohl(p_hdr.height);
> +	unsigned int version = ntohl(p_hdr.version);
> +	unsigned int flags = ntohl(p_hdr.flags);
> +
> +	if (!version || version > FWHT_VERSION)
> +		return false;
> +
> +	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
> +		return false;
> +
> +	if (version == FWHT_VERSION) {
> +		unsigned int components_num = 1 +
> +			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
> +			FWHT_FL_COMPONENTS_NUM_OFFSET);
> +		unsigned int pixenc = flags & FWHT_FL_PIXENC_MSK;
> +
> +		if (components_num == 0 || components_num > 4 || !pixenc)
> +			return false;
> +	}
> +
> +	info = info_from_header(p_hdr);
> +	if (!info)
> +		return false;
> +	return true;
> +}

Regards,

	Hans
