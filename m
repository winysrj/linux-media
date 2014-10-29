Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:58262 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbaJ2XvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 19:51:07 -0400
Date: Thu, 30 Oct 2014 08:51:00 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
 input support
Message-ID: <20141029235100.GA4599@verge.net.au>
References: <1413868129-22121-1-git-send-email-ykaneko0929@gmail.com>
 <544633D3.5010805@cogentembedded.com>
 <CAH1o70Jk=dCf3VWqdAJmGzd6TSQFeN=x+FCKExDzaf0BZF0L1A@mail.gmail.com>
 <20141029041103.GB29787@verge.net.au>
 <5450D01D.9060701@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5450D01D.9060701@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 29, 2014 at 02:31:41PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/29/2014 7:11 AM, Simon Horman wrote:
> 
> >>>>From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> >>>>Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> >>>>Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> >>>>---
> 
> >>>>This patch is against master branch of linuxtv.org/media_tree.git.
> 
> >>>>v2 [Yoshihiro Kaneko]
> >>>>* remove unused/useless definition as suggested by Sergei Shtylyov
> 
> >>>    I didn't say it's useless, I just suspected that you missed the necessary
> >>>test somewhere...
> 
> >>Sorry for my inaccurate description.
> 
> >>>>   drivers/media/platform/soc_camera/rcar_vin.c | 9 +++++++++
> >>>>   1 file changed, 9 insertions(+)
> 
> >>>>diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> >>>>b/drivers/media/platform/soc_camera/rcar_vin.c
> >>>>index 20defcb..cb5e682 100644
> >>>>--- a/drivers/media/platform/soc_camera/rcar_vin.c
> >>>>+++ b/drivers/media/platform/soc_camera/rcar_vin.c
> >>>>@@ -74,6 +74,7 @@
> >>>>   #define VNMC_INF_YUV10_BT656  (2 << 16)
> >>>>   #define VNMC_INF_YUV10_BT601  (3 << 16)
> >>>>   #define VNMC_INF_YUV16                (5 << 16)
> >>>>+#define VNMC_INF_RGB888                (6 << 16)
> >>>>   #define VNMC_VUP              (1 << 10)
> >>>>   #define VNMC_IM_ODD           (0 << 3)
> >>>>   #define VNMC_IM_ODD_EVEN      (1 << 3)
> 
> >>>[...]
> 
> >>>>@@ -331,6 +336,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
> >>>>         if (output_is_yuv)
> >>>>                 vnmc |= VNMC_BPS;
> >>>>
> >>>>+       if (vnmc & VNMC_INF_RGB888)
> >>>>+               vnmc ^= VNMC_BPS;
> >>>>+
> 
> >>>    Hm, this also changes the behavior for VNMC_INF_YUV16 and
> >>>VNMC_INF_YUV10_BT{601|656}. Is this actually intended?
> 
> >>Probably this code is incorrect.
> >>Thank you for your review.
> 
> >Thanks, I have confirmed with Matsuoka-san that there is a problem here.
> 
> >He has provided the following fix. Could you see about squashing it into
> >the above patch and reposting?
> 
> >From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> >[PATCH] media: soc_camera: rcar_vin: Fix bit field check
> 
> >Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> >diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> >index 013d75c..da62d94 100644
> >--- a/drivers/media/platform/soc_camera/rcar_vin.c
> >+++ b/drivers/media/platform/soc_camera/rcar_vin.c
> >@@ -94,7 +94,7 @@
> >  #define VNMC_INF_YUV8_BT601	(1 << 16)
> >  #define VNMC_INF_YUV16		(5 << 16)
> >  #define VNMC_INF_RGB888		(6 << 16)
> >-#define VNMC_INF_RGB_MASK	(6 << 16)
> >+#define VNMC_INF_MASK		(7 << 16)
> 
>    #define it above VNMC_INF_YUV8_BT656 please.
> 
> >  #define VNMC_VUP		(1 << 10)
> >  #define VNMC_IM_ODD		(0 << 3)
> >  #define VNMC_IM_ODD_EVEN	(1 << 3)
> >@@ -675,7 +675,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
> >  	if (output_is_yuv)
> >  		vnmc |= VNMC_BPS;
> >
> >-	if (vnmc & VNMC_INF_RGB_MASK)
> >+	if ((vnmc & VNMC_INF_MASK) == VNMC_INF_RGB888)
> 
>    Is he sure it shouldn't be (vnmc & VNMC_INF_RGB888) == VNMC_INF_RGB888 to
> also cover 16-bit RGB666 and 12-bit RGB88?

Nice, I think that is a good idea (although the latter formats aren't
supported by the driver yet, right?).

Its somewhat unobvious how that logic works so perhaps we should add a
comment like this

	/* If input and output use the same colorspace, use bypass mode */
	if (output_is_yuv)
		vnmc |= VNMC_BPS;

	/* The above assumes YUV input, toggle BPS for RGB input.
	 * RGB inputs can be detected by checking that the most-significant
	 * two bits of INF are set. This corresponds to the bits
	 * set in VNMC_INF_RGB888. */
	if ((vnmc & VNMC_INF_RGB888)) == VNMC_INF_RGB888)
		vnmc ^= VNMC_BPS;
