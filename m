Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E54AC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F2F920823
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfARJNr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:13:47 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:45948 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfARJNr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 04:13:47 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kQDfgc4MRaxzfkQDggohMx; Fri, 18 Jan 2019 10:13:45 +0100
Subject: Re: [RFC PATCH] media/doc: Allow sizeimage to be set by v4l clients
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190116123701.10344-1-stanimir.varbanov@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <299e8aeb-6deb-b383-8f63-cf2cbf5d2e9f@xs4all.nl>
Date:   Fri, 18 Jan 2019 10:13:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190116123701.10344-1-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPEZxO+BbzhP7kgU3N90NsBEKOWzZuk9RkcGbyn5ImdtmIDsqUQxADdvseAmOHamRb4JiEVP1p/Rn0Gwm5jVraW3D9tCzwG2yf/KVZdnoBZGv0ZXGNUh
 Ub5Vozz4AOD1UZC0ByhS9ntdyaw7zWVkO3xO+M7lqxB0hfJFj0CiEofecIo2q5Ek3/6VnkbPXXWxrCTqIFyq9P887yT9NcX0tzcyrrQ1YZMdglZpEp/jIIbm
 jjC2hklubx6bYcUosW4AppxwjJD36g/R1fgUhWDJXQ1BWO1HgN3IFhNHARK+hrZEDfARfoHhVKT9HqFa6EcrcO5MOiejUfjZ5E5FoMXWfxMBPEZlzVpAgbuV
 zRbd8BTi4p2XRUelkCftKkFF6YXPfyi8eKL5LM7HNhsVTCpt9yE9AJSuGMjN/tonmmigd7m7ZxTpVK6edC45G0iO3/aC7lSadTO8D+eM3PPG866QZrR2YmUY
 XGGnEC+LjjZ+vif0JIHQQYiRjgBjTjePgxxUvBpfl/Hhadf0no2EAFEfe/mczuCi6gRRd+wso85cfoNfUU/03G6C3AcNOCJUVGHhvQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/16/19 1:37 PM, Stanimir Varbanov wrote:
> This changes v4l2_pix_format and v4l2_plane_pix_format sizeimage
> field description to allow v4l clients to set bigger image size
> in case of variable length compressed data.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst | 5 ++++-
>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst        | 3 ++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
> index 7f82dad9013a..dbe0b74e9ba4 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
> @@ -30,7 +30,10 @@ describing all planes of that format.
>  
>      * - __u32
>        - ``sizeimage``
> -      - Maximum size in bytes required for image data in this plane.
> +      - Maximum size in bytes required for image data in this plane,
> +        set by the driver. When the image consists of variable length
> +        compressed data this is the maximum number of bytes required
> +        to hold an image, and it is allowed to be set by the client.
>      * - __u32
>        - ``bytesperline``
>        - Distance in bytes between the leftmost pixels in two adjacent
> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
> index 71eebfc6d853..54b6d2b67bd7 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
> @@ -89,7 +89,8 @@ Single-planar format structure
>        - Size in bytes of the buffer to hold a complete image, set by the
>  	driver. Usually this is ``bytesperline`` times ``height``. When
>  	the image consists of variable length compressed data this is the
> -	maximum number of bytes required to hold an image.
> +	maximum number of bytes required to hold an image, and it is
> +	allowed to be set by the client.
>      * - __u32
>        - ``colorspace``
>        - Image colorspace, from enum :c:type:`v4l2_colorspace`.
> 

Hmm. "maximum number of bytes required to hold an image": that's not actually true
for bitstream formats like MPEG. It's just the size of the buffer used to store the
bitstream, i.e. one buffer may actually contain multiple compressed images, or a
compressed image is split over multiple buffers.

Only for MJPEG is this statement true since each buffer will contain a single
compressed JPEG image.

Regards,

	Hans
