Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2105 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZBQHfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 02:35:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Fw: [PATCH v2] V4L2: Add COLORFX user control
Date: Tue, 17 Feb 2009 08:35:19 +0100
Cc: Michael Schimek <mschimek@gmx.at>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20090216160122.7a165792@pedra.chehab.org>
In-Reply-To: <20090216160122.7a165792@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170835.19131.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 February 2009 20:01:22 Mauro Carvalho Chehab wrote:
> Michael/Hans,
>
> As nobody complained, and this seems to be required by some webcams, I'm
> committing this changeset. Please update V4L2 API to reflect this change.

I will do that this week (and also add this control to v4l2-common.c). BTW, 
in the future changesets that modify or add to the v4l2 spec should only be 
accepted if it also includes an update for the v4l2 spec. Now that the spec 
is part of the repository there is no excuse for not updating it.

This change predates the merging of the spec, so it's not a problem here.

Regards,

	Hans

>
> Cheers,
> Mauro.
>
> Forwarded message:
>
> Date: Tue, 20 Jan 2009 16:29:26 -0600
> From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
> To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
> Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
> "Nagalla, Hari" <hnagalla@ti.com>, Sakari Ailus <sakari.ailus@nokia.com>,
> "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
> "mikko.hurskainen@nokia.com" <mikko.hurskainen@nokia.com>, "Curran,
> Dominic" <dcurran@ti.com> Subject: [PATCH v2] V4L2: Add COLORFX user
> control
>
>
> From 07396d67b39bf7bcc81440d3e72d253ad6c54f11 Mon Sep 17 00:00:00 2001
> From: Sergio Aguirre <saaguirre@ti.com>
> Date: Tue, 20 Jan 2009 15:34:43 -0600
> Subject: [PATCH v2] V4L2: Add COLORFX user control
>
> This is a common feature on many cameras. the options are:
> Default colors,
> B & W,
> Sepia
>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  include/linux/videodev2.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4669d7e..89ed395 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -876,8 +876,15 @@ enum v4l2_power_line_frequency {
>  #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
>  #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
>  #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
> +#define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
> +enum v4l2_colorfx {
> +	V4L2_COLORFX_NONE	= 0,
> +	V4L2_COLORFX_BW		= 1,
> +	V4L2_COLORFX_SEPIA	= 2,
> +};
> +
>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+31)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+32)
>
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
