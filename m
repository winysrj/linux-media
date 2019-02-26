Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AF9C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 09:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B928213A2
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 09:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfBZJGH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:06:07 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:39296 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbfBZJGG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 04:06:06 -0500
Received: from [IPv6:2001:983:e9a7:1:7cd2:8892:5865:2071] ([IPv6:2001:983:e9a7:1:7cd2:8892:5865:2071])
        by smtp-cloud7.xs4all.net with ESMTPA
        id yYgdgmXbCLMwIyYgegOISS; Tue, 26 Feb 2019 10:06:04 +0100
Subject: Re: [PATCH v4 17/21] media: vicodec: add documentation to
 V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190225222210.121713-1-dafna3@gmail.com>
 <20190225222210.121713-8-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <47f73b93-54ba-29c5-dde2-378d0c713e6b@xs4all.nl>
Date:   Tue, 26 Feb 2019 10:06:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190225222210.121713-8-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGUPB5Ip7q4jDiwBv9HthTHYbFYk+GxkdR/bUWRvwNsE5gdXZ87VMbjeADXSe3tL8Af1F+TCGmsB8Xi3DRHxNQT2sNHfIMsF8tXnbN1COddr0wexUYvs
 h7RHFPjlDs6RfUV/7Kk0u+GYIOkcC2rMFhpDY9TqkaHSHPEs5JBn3eY8MnMf2MwEBsGSJgkVahyok/W03y9O56bdr9B4FEBx8sxx+7XxMt+qu8oZ4xvts4l+
 65aQKTfXxIdZJyUJOAka9mm20AKYPq6J/STmdn7I5NmTtzpCY8NrunEaHGmCsPZeCDQ1P2FylvRmT7sjDdepdHMzvc8kG3TVlcoeEYE/+s8=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/25/19 11:22 PM, Dafna Hirschfeld wrote:
> add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
> control and it's related 'v4l2_ctrl_fwht_params' struct

it's -> its

> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  .../media/uapi/v4l/ext-ctrls-codec.rst        | 54 +++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> index a30ce4fd2ea1..280f1386d5a9 100644
> --- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> +++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> @@ -1541,6 +1541,60 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
>  
>  .. _v4l2-mpeg-fwht:
>  
> +``V4L2_CID_MPEG_VIDEO_FWHT_PARAMS (struct)``
> +    Specifies the fwht parameters (as extracted from the bitstream) for the
> +    associated FWHT data. This includes the necessary parameters for
> +    configuring a stateless hardware decoding pipeline for FWHT.
> +
> +    .. note::
> +
> +       This compound control is not yet part of the public kernel API and
> +       it is expected to change.
> +
> +.. c:type:: v4l2_ctrl_fwht_params
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_fwht_params
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u64
> +      - ``backward_ref_ts``
> +      - Timestamp of the V4L2 capture buffer to use as backward reference, used
> +        with P-coded frames. The timestamp refers to the
> +	``timestamp`` field in struct :c:type:`v4l2_buffer`. Use the
> +	:c:func:`v4l2_timeval_to_ns()` function to convert the struct
> +	:c:type:`timeval` in struct :c:type:`v4l2_buffer` to a __u64.
> +    * - __u32
> +      - ``version``
> +      - The version of the codec
> +    * - __u32
> +      - ``width``
> +      - The width of the frame
> +    * - __u32
> +      - ``height``
> +      - The height of the frame
> +    * - __u32
> +      - ``flags``
> +      - The flags of the frame

You need to add a table documenting the flags.

> +    * - __u32
> +      - ``colorspace``
> +      - The colorspace of the frame, from enum :c:type:`v4l2_colorspace`.
> +    * - __u32
> +      - ``xfer_func``
> +      - The transfer function, from enum :c:type:`v4l2_xfer_func`.
> +    * - __u32
> +      - ``ycbcr_enc``
> +      - The Y'CbCr encoding, from enum :c:type:`v4l2_ycbcr_encoding`.
> +    * - __u32
> +      - ``quantization``
> +      - The quantization range, from enum :c:type:`v4l2_quantization`.
> +    * - __u32
> +      - ``comp_frame_size``
> +      - The size of the compressed frame.

Why do we need this? Isn't this set via the 'bytesused' field when we queue
the buffer containing the compressed frame?

I think this field should be dropped.

> +
>  ``V4L2_CID_FWHT_I_FRAME_QP (integer)``
>      Quantization parameter for an I frame for FWHT. Valid range: from 1
>      to 31.
> 

Regards,

	Hans
