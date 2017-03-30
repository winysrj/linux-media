Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49622 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750766AbdC3U1B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:27:01 -0400
Date: Thu, 30 Mar 2017 23:26:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helen Koike <helen.koike@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/2] [media] docs-rst: add V4L2_INPUT_TYPE_DEFAULT
Message-ID: <20170330202626.GM16657@valkosipuli.retiisi.org.uk>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
 <1490889738-30009-2-git-send-email-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490889738-30009-2-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen and others,

On Thu, Mar 30, 2017 at 01:02:18PM -0300, Helen Koike wrote:
> add documentation for V4L2_INPUT_TYPE_DEFAULT
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-enuminput.rst | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> index 17aaaf9..0237e10 100644
> --- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> @@ -112,6 +112,9 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
>      :stub-columns: 0
>      :widths:       3 1 4
>  
> +    * - ``V4L2_INPUT_TYPE_DEFAULT``
> +      - 0
> +      - This is the default value returned when no input is supported.
>      * - ``V4L2_INPUT_TYPE_TUNER``
>        - 1
>        - This input uses a tuner (RF demodulator).

What would you think of calling this input as "unknown" instead of
"default"? That's what an input which isn't really specified actually is.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
