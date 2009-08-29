Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3220 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZH2NA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 09:00:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 1/6] Updated Support for TVP7002 in v4l2 definitions
Date: Sat, 29 Aug 2009 15:00:50 +0200
Cc: santiago.nunez@ridgerun.com, m-karicheri2@ti.com,
	clark.becker@ridgerun.com, todd.fischer@ridgerun.com,
	linux-media@vger.kernel.org
References: <1251502016-14808-1-git-send-email-santiago.nunez@ridgerun.com>
In-Reply-To: <1251502016-14808-1-git-send-email-santiago.nunez@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908291500.50320.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 29 August 2009 01:26:56 santiago.nunez@ridgerun.com wrote:
> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> 
> This patch provides required std and control definitions in TVP7002
> within v4l2. Removed HD definitions.
> 
> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> ---
>  include/linux/videodev2.h       |   25 +++++++++++++++++++++++++
>  include/media/v4l2-chip-ident.h |    3 +++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 74f1687..685bc7e 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1147,6 +1147,31 @@ enum  v4l2_exposure_auto_type {
>  
>  #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
>  
> +
> +/* tvp7002 control IDs*/
> +#define V4L2_CID_TVP7002_BASE			V4L2_CTRL_CLASS_DECODER
> +#define V4L2_CID_TVP7002_COARSE_GAIN_R		(V4L2_CID_TVP7002_BASE + 1)
> +#define V4L2_CID_TVP7002_COARSE_GAIN_G		(V4L2_CID_TVP7002_BASE + 2)
> +#define V4L2_CID_TVP7002_COARSE_GAIN_B		(V4L2_CID_TVP7002_BASE + 3)
> +#define V4L2_CID_TVP7002_FINE_GAIN_R		(V4L2_CID_TVP7002_BASE + 4)
> +#define V4L2_CID_TVP7002_FINE_GAIN_G		(V4L2_CID_TVP7002_BASE + 5)
> +#define V4L2_CID_TVP7002_FINE_GAIN_B		(V4L2_CID_TVP7002_BASE + 6)
> +#define V4L2_CID_TVP7002_B_CLAMP		(V4L2_CID_TVP7002_BASE + 7)
> +#define V4L2_CID_TVP7002_G_CLAMP		(V4L2_CID_TVP7002_BASE + 8)
> +#define V4L2_CID_TVP7002_R_CLAMP		(V4L2_CID_TVP7002_BASE + 9)
> +#define V4L2_CID_TVP7002_CLAMP_OFF_EN		(V4L2_CID_TVP7002_BASE + 10)
> +#define V4L2_CID_TVP7002_FCTCA			(V4L2_CID_PRIVATE_BASE + 11)
> +#define V4L2_CID_TVP7002_F_CLAMP_GB		(V4L2_CID_TVP7002_BASE + 12)
> +#define V4L2_CID_TVP7002_F_CLAMP_R		(V4L2_CID_TVP7002_BASE + 13)
> +#define V4L2_CID_TVP7002_CLAMP_START		(V4L2_CID_TVP7002_BASE + 14)
> +#define V4L2_CID_TVP7002_CLAMP_W		(V4L2_CID_TVP7002_BASE + 15)
> +#define V4L2_CID_TVP7002_B_COARSE_OFF		(V4L2_CID_TVP7002_BASE + 16)
> +#define V4L2_CID_TVP7002_G_COARSE_OFF		(V4L2_CID_TVP7002_BASE + 17)
> +#define V4L2_CID_TVP7002_R_COARSE_OFF		(V4L2_CID_TVP7002_BASE + 18)
> +#define V4L2_CID_TVP7002_B_FINE_OFF		(V4L2_CID_TVP7002_BASE + 19)
> +#define V4L2_CID_TVP7002_G_FINE_OFF		(V4L2_CID_TVP7002_BASE + 20)
> +#define V4L2_CID_TVP7002_R_FINE_OFF		(V4L2_CID_TVP7002_BASE + 21)

Are there applications that actually need these controls? I do not
feel comfortable exposing such low-level controls to user-space in this way.

This is a recurring topic (if and how to expose low-level functionality) and
I have some ideas on how to solve this in the future. But for now I prefer it
if these are not exported yet.

BTW: only patch 1/6 is cross-posted to the linux-media list. I'm not sure if
that was intentional or an accident.

Regards,

	Hans

> +
>  /*
>   *	T U N I N G
>   */
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index 56b31cb..14c83b5 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -129,6 +129,9 @@ enum {
>  	V4L2_IDENT_SAA6752HS = 6752,
>  	V4L2_IDENT_SAA6752HS_AC3 = 6753,
>  
> +	/* module tvp7002: just ident 7002 */
> +	V4L2_IDENT_TVP7002 = 7002,
> +
>  	/* module adv7170: just ident 7170 */
>  	V4L2_IDENT_ADV7170 = 7170,
>  



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
