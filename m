Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC43C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 13:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48E95218D8
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 13:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfBKNEv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:04:51 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:48094 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727182AbfBKNEv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 08:04:51 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id tBGPgteagRO5ZtBGTg43ia; Mon, 11 Feb 2019 14:04:49 +0100
Subject: Re: [PATCHv2 4/6] videodev2.h: add V4L2_CTRL_FLAG_REQUIRES_REQUESTS
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
 <20190211101357.48754-5-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <e334fb92-31a2-28c0-02e4-a9ccac49ba03@xs4all.nl>
Date:   Mon, 11 Feb 2019 14:04:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190211101357.48754-5-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfK57tZv9Lo8/WgUlsGy3UHsqe4RzsL+XAgSAvntSnleMFRmZPUKoSEXxIs//BOKvws0WMg7SZFXTq6G1ePcP+jt/D8zxf61Ge4lbDsVFR8TnynzPa4sN
 wCXR3oNspHm/MBHCXZdUUh+tsuchGqE7NRspoR/olK6HG+RAsdnTtLfEGW66se4UVRoPEsLh9/U+8fJHBmJqMfbS1W42hVdnMKSJD6F5cwdUzotxf0+CHugJ
 EwXqN1LgJtseoRwKE7/jKX3V4iWkHa8QIkJond9XOkr85A28l6QHCmBSTSOxOpvN
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/11/19 11:13 AM, Hans Verkuil wrote:
> Indicate if a control can only be set through a request, as opposed
> to being set directly. This is necessary for stateless codecs where
> it makes no sense to set the state controls directly.

Kwiboo on irc pointed out that this clashes with this line the in Initialization
section of the stateless decoder API:

"Call VIDIOC_S_EXT_CTRLS() to set all the controls (parsed headers, etc.) required
 by the OUTPUT format to enumerate the CAPTURE formats."

So for now ignore patches 4-6: I need to think about this some more.

My worry here is what happens when userspace is adding these controls to a
request and at the same time sets them directly. That may cause weird side-effects.

Regards,

	Hans

> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  .../media/uapi/v4l/vidioc-queryctrl.rst       |  4 ++++
>  .../media/videodev2.h.rst.exceptions          |  1 +
>  include/uapi/linux/videodev2.h                | 23 ++++++++++---------
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> index f824162d0ea9..b08c69cedb92 100644
> --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> @@ -539,6 +539,10 @@ See also the examples in :ref:`control`.
>  	``V4L2_CTRL_FLAG_GRABBED`` flag when buffers are allocated or
>  	streaming is in progress since most drivers do not support changing
>  	the format in that case.
> +    * - ``V4L2_CTRL_FLAG_REQUIRES_REQUESTS``
> +      - 0x0800
> +      - This control cannot be set directly, but only through a request
> +        (i.e. by setting ``which`` to ``V4L2_CTRL_WHICH_REQUEST_VAL``).
>  
>  
>  Return Value
> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
> index 64d348e67df9..0caa72014dba 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -351,6 +351,7 @@ replace define V4L2_CTRL_FLAG_VOLATILE control-flags
>  replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
>  replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
>  replace define V4L2_CTRL_FLAG_MODIFY_LAYOUT control-flags
> +replace define V4L2_CTRL_FLAG_REQUIRES_REQUESTS control-flags
>  
>  replace define V4L2_CTRL_FLAG_NEXT_CTRL control
>  replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 7f035d44666e..a78bfdc1df97 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1736,17 +1736,18 @@ struct v4l2_querymenu {
>  } __attribute__ ((packed));
>  
>  /*  Control flags  */
> -#define V4L2_CTRL_FLAG_DISABLED		0x0001
> -#define V4L2_CTRL_FLAG_GRABBED		0x0002
> -#define V4L2_CTRL_FLAG_READ_ONLY	0x0004
> -#define V4L2_CTRL_FLAG_UPDATE		0x0008
> -#define V4L2_CTRL_FLAG_INACTIVE		0x0010
> -#define V4L2_CTRL_FLAG_SLIDER		0x0020
> -#define V4L2_CTRL_FLAG_WRITE_ONLY	0x0040
> -#define V4L2_CTRL_FLAG_VOLATILE		0x0080
> -#define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
> -#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
> -#define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x0400
> +#define V4L2_CTRL_FLAG_DISABLED			0x0001
> +#define V4L2_CTRL_FLAG_GRABBED			0x0002
> +#define V4L2_CTRL_FLAG_READ_ONLY		0x0004
> +#define V4L2_CTRL_FLAG_UPDATE			0x0008
> +#define V4L2_CTRL_FLAG_INACTIVE			0x0010
> +#define V4L2_CTRL_FLAG_SLIDER			0x0020
> +#define V4L2_CTRL_FLAG_WRITE_ONLY		0x0040
> +#define V4L2_CTRL_FLAG_VOLATILE			0x0080
> +#define V4L2_CTRL_FLAG_HAS_PAYLOAD		0x0100
> +#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE		0x0200
> +#define V4L2_CTRL_FLAG_MODIFY_LAYOUT		0x0400
> +#define V4L2_CTRL_FLAG_REQUIRES_REQUESTS	0x0800
>  
>  /*  Query flags, to be ORed with the control ID */
>  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
> 

