Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52755 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751262AbdH1JJr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 05:09:47 -0400
Subject: Re: [PATCH v4 3/7] media: open.rst: remove the minor number range
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1503747774.git.mchehab@s-opensource.com>
 <477281a419dc0a2208e967a7ad312ba79b8ee326.1503747774.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e230d79e-0ecb-6a9b-9752-28ec562c5de7@xs4all.nl>
Date: Mon, 28 Aug 2017 11:09:44 +0200
MIME-Version: 1.0
In-Reply-To: <477281a419dc0a2208e967a7ad312ba79b8ee326.1503747774.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/08/17 13:53, Mauro Carvalho Chehab wrote:
> minor numbers use to range between 0 to 255, but that
> was changed a long time ago. While it still applies when
> CONFIG_VIDEO_FIXED_MINOR_RANGES, when the minor number is
> dynamically allocated, this may not be true. In any case,
> this is not relevant, as udev will take care of it.
> 
> So, remove this useless misinformation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  Documentation/media/uapi/v4l/open.rst | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index fc0037091814..96ac972c1fa2 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -19,11 +19,10 @@ helper functions and a common application interface specified in this
>  document.
>  
>  Each driver thus loaded registers one or more device nodes with major
> -number 81 and a minor number between 0 and 255. Minor numbers are
> -allocated dynamically unless the kernel is compiled with the kernel
> -option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers
> -are allocated in ranges depending on the device node type (video, radio,
> -etc.).
> +number 81. Minor numbers are allocated dynamically unless the kernel
> +is compiled with the kernel option CONFIG_VIDEO_FIXED_MINOR_RANGES.

I wonder if we shouldn't remove this kernel option completely. Does it
make any sense to keep holding on to this?

Regards,

	Hans

> +In that case minor numbers are allocated in ranges depending on the
> +device node type.
>  
>  The existing V4L2 device node types are:
>  
> 
