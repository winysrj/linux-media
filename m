Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41531 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752256AbdDIK72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Apr 2017 06:59:28 -0400
Subject: Re: [PATCH] [media] vidioc-queryctrl.rst: fix menu/int menu
 references
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <c8027c4d4c667a0ff406261e948252a94d1c5e7b.1491735360.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <58b3efb1-a374-d8ac-10f3-53778fba7de5@xs4all.nl>
Date: Sun, 9 Apr 2017 12:59:21 +0200
MIME-Version: 1.0
In-Reply-To: <c8027c4d4c667a0ff406261e948252a94d1c5e7b.1491735360.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2017 12:56 PM, Mauro Carvalho Chehab wrote:
> The documentation incorrectly mentions MENU and INTEGER_MENU
> at struct v4l2_querymenu table as if they were flags. They're
> not: they're types.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> index 82769de801b1..80842983eb12 100644
> --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> @@ -301,12 +301,12 @@ See also the examples in :ref:`control`.
>        - ``name``\ [32]
>        - Name of the menu item, a NUL-terminated ASCII string. This
>  	information is intended for the user. This field is valid for
> -	``V4L2_CTRL_FLAG_MENU`` type controls.
> +	``V4L2_CTRL_TYPE_MENU`` type controls.
>      * -
>        - __s64
>        - ``value``
>        - Value of the integer menu item. This field is valid for
> -	``V4L2_CTRL_FLAG_INTEGER_MENU`` type controls.
> +	``V4L2_CTRL_TYPE_INTEGER_MENU`` type controls.
>      * - __u32
>        -
>        - ``reserved``
> 
