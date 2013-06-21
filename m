Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50590 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161523Ab3FUQTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 12:19:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH] v4l2-controls.h: fix copy-and-paste error in comment
Date: Fri, 21 Jun 2013 18:19:22 +0200
Message-ID: <1518252.jVldMt7J07@avalon>
In-Reply-To: <1371794734-10078-1-git-send-email-hverkuil@xs4all.nl>
References: <1371794734-10078-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 21 June 2013 08:05:34 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The comment for the FM_RX class was copied from the DV class unchanged.
> Fixed.
> 
> Also made the FM_TX comment consistent with the others.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/uapi/linux/v4l2-controls.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h index 69bd5bb..e90a88a 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -53,13 +53,13 @@
>  #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls 
*/
>  #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls 
*/
>  #define V4L2_CTRL_CLASS_CAMERA		0x009a0000	/* Camera class controls 
*/
> -#define V4L2_CTRL_CLASS_FM_TX		0x009b0000	/* FM Modulator control 
class */
> +#define V4L2_CTRL_CLASS_FM_TX		0x009b0000	/* FM Modulator controls 
*/
>  #define V4L2_CTRL_CLASS_FLASH		0x009c0000	/* Camera flash controls 
*/
>  #define V4L2_CTRL_CLASS_JPEG		0x009d0000	/* JPEG-compression controls 
*/
>  #define V4L2_CTRL_CLASS_IMAGE_SOURCE	0x009e0000	/* Image source 
controls */
> #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing 
controls
> */ #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
> -#define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* Digital Video 
controls */
> +#define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls 
*/
> 
>  /* User-class control IDs */
-- 
Regards,

Laurent Pinchart

