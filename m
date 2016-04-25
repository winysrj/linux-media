Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59750 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbcDYHaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 03:30:02 -0400
Subject: Re: [RFC PATCH 01/24] V4L fixes
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571DC774.7050404@xs4all.nl>
Date: Mon, 25 Apr 2016 09:29:56 +0200
MIME-Version: 1.0
In-Reply-To: <1461532104-24032-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/2016 11:08 PM, Ivaylo Dimitrov wrote:
> From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
> 
> Squashed from the following upstream commits:
> 
> V4L: Create control class for sensor mode
> V4L: add ad5820 focus specific custom controls
> V4L: add V4L2_CID_TEST_PATTERN
> V4L: Add V4L2_CID_MODE_OPSYSCLOCK for reading output system clock
> 
> Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  include/uapi/linux/v4l2-controls.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index b6a357a..23011cc 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -62,6 +62,7 @@
>  #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
>  #define V4L2_CTRL_CLASS_RF_TUNER	0x00a20000	/* RF tuner controls */
>  #define V4L2_CTRL_CLASS_DETECT		0x00a30000	/* Detection controls */
> +#define V4L2_CTRL_CLASS_MODE		0x00a40000	/* Sensor mode information */
>  
>  /* User-class control IDs */
>  
> @@ -974,4 +975,20 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>  
> +/* SMIA-type sensor information */
> +#define V4L2_CID_MODE_CLASS_BASE		(V4L2_CTRL_CLASS_MODE | 0x900)
> +#define V4L2_CID_MODE_CLASS			(V4L2_CTRL_CLASS_MODE | 1)
> +#define V4L2_CID_MODE_FRAME_WIDTH		(V4L2_CID_MODE_CLASS_BASE+1)
> +#define V4L2_CID_MODE_FRAME_HEIGHT		(V4L2_CID_MODE_CLASS_BASE+2)
> +#define V4L2_CID_MODE_VISIBLE_WIDTH		(V4L2_CID_MODE_CLASS_BASE+3)
> +#define V4L2_CID_MODE_VISIBLE_HEIGHT		(V4L2_CID_MODE_CLASS_BASE+4)
> +#define V4L2_CID_MODE_PIXELCLOCK		(V4L2_CID_MODE_CLASS_BASE+5)
> +#define V4L2_CID_MODE_SENSITIVITY		(V4L2_CID_MODE_CLASS_BASE+6)
> +#define V4L2_CID_MODE_OPSYSCLOCK		(V4L2_CID_MODE_CLASS_BASE+7)

The new controls need to be added to v4l2-ctrls.c and documented in DocBook.
But I would take a look at the existing Image Source and Image Process controls:

https://hverkuil.home.xs4all.nl/spec/media.html#image-source-controls

I think these controls belong there and that there is overlap anyway.

Sakari would probably know best what should be done with these controls.

Regards,

	Hans

> +
> +/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> +#define V4L2_CID_FOCUS_AD5820_BASE 		(V4L2_CTRL_CLASS_CAMERA | 0x10af)
> +#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_FOCUS_AD5820_BASE+0)
> +#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_FOCUS_AD5820_BASE+1)
> +
>  #endif
> 

