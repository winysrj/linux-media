Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:55216 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZASPca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 10:32:30 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: Color FX User control proposal
Date: Mon, 19 Jan 2009 16:32:26 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Curran, Dominic" <dcurran@ti.com>,
	"Kulkarni, Pallavi" <p-kulkarni@ti.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"mikko.hurskainen@nokia.com" <mikko.hurskainen@nokia.com>
References: <A24693684029E5489D1D202277BE8944164DF963@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944164DF963@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191632.26404.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 13 January 2009, Aguirre Rodriguez, Sergio Alberto wrote:
> Hi,
>
> Recently in TI and Nokia, we are working towards having for acceptance an
> OMAP3 camera driver, which uses an on-chip Image Signal Processor that has
> one feature of color effects. We were using a V4L2 private CID for that,
> but have been suggested that this could be common enough to propose to the
> V4L2 spec aswell for other devices to use.
>
> Below patch adds the control to include/linux/videodev2.h file, should this
> be enough? (This patch is taking as a codebase the latest linux-omap
> kernel, which I believe is v2.6.28 still)
>
> Thanks and Regards,
> Sergio
>
> From 022b87f3e7f3c3be141ab271a110948ea9567a69 Mon Sep 17 00:00:00 2001
> From: Sergio Aguirre <saaguirre@ti.com>
> Date: Tue, 13 Jan 2009 16:25:31 -0600
> Subject: [PATCH] V4L2: Add COLORFX user control
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
> index 4669d7e..b02a10d 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -876,8 +876,15 @@ enum v4l2_power_line_frequency {
>  #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
>  #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
>  #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
> +#define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
> +enum v4l2_colorfx {
> +	V4L2_COLORFX_DEFAULT	= 0,

If this option disables color effects, shouldn't it be called 
V4L2_COLORFX_NONE instead ?

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

Best regards,

Laurent Pinchart
