Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58208 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1CIXi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 18:38:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH v2 1/4] v4l: add V4L2_PIX_FMT_Y12 format
Date: Thu, 10 Mar 2011 00:36:14 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299686863-20701-1-git-send-email-michael.jones@matrix-vision.de> <1299686863-20701-2-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299686863-20701-2-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103100036.21138.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Thanks for the patch.

On Wednesday 09 March 2011 17:07:40 Michael Jones wrote:
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/videodev2.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 02da9e7..6fac463 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -288,6 +288,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_Y4      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
>  #define V4L2_PIX_FMT_Y6      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
>  #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
> +#define V4L2_PIX_FMT_Y12     v4l2_fourcc('Y', '1', '2', ' ') /* 12  Greyscale     */
>  #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
> 
>  /* Palette formats */

Could you please also document the format in Documentation/DocBook/v4l ?

-- 
Regards,

Laurent Pinchart
