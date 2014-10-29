Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:36141 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaJ2ELJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 00:11:09 -0400
Date: Wed, 29 Oct 2014 13:11:04 +0900
From: Simon Horman <horms@verge.net.au>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
 input support
Message-ID: <20141029041103.GB29787@verge.net.au>
References: <1413868129-22121-1-git-send-email-ykaneko0929@gmail.com>
 <544633D3.5010805@cogentembedded.com>
 <CAH1o70Jk=dCf3VWqdAJmGzd6TSQFeN=x+FCKExDzaf0BZF0L1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH1o70Jk=dCf3VWqdAJmGzd6TSQFeN=x+FCKExDzaf0BZF0L1A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san, Hi Sergei,

On Tue, Oct 21, 2014 at 08:33:52PM +0900, Yoshihiro Kaneko wrote:
> Hello Sergei,
> 
> 2014-10-21 19:22 GMT+09:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> > Hello.
> >
> > On 10/21/2014 9:08 AM, Yoshihiro Kaneko wrote:
> >
> >> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> >
> >
> >> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> >> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> >> ---
> >
> >
> >> This patch is against master branch of linuxtv.org/media_tree.git.
> >
> >
> >> v2 [Yoshihiro Kaneko]
> >> * remove unused/useless definition as suggested by Sergei Shtylyov
> >
> >
> >    I didn't say it's useless, I just suspected that you missed the necessary
> > test somewhere...
> 
> Sorry for my inaccurate description.
> 
> >
> >>   drivers/media/platform/soc_camera/rcar_vin.c | 9 +++++++++
> >>   1 file changed, 9 insertions(+)
> >
> >
> >> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> >> b/drivers/media/platform/soc_camera/rcar_vin.c
> >> index 20defcb..cb5e682 100644
> >> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> >> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> >> @@ -74,6 +74,7 @@
> >>   #define VNMC_INF_YUV10_BT656  (2 << 16)
> >>   #define VNMC_INF_YUV10_BT601  (3 << 16)
> >>   #define VNMC_INF_YUV16                (5 << 16)
> >> +#define VNMC_INF_RGB888                (6 << 16)
> >>   #define VNMC_VUP              (1 << 10)
> >>   #define VNMC_IM_ODD           (0 << 3)
> >>   #define VNMC_IM_ODD_EVEN      (1 << 3)
> >
> > [...]
> >>
> >> @@ -331,6 +336,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
> >>         if (output_is_yuv)
> >>                 vnmc |= VNMC_BPS;
> >>
> >> +       if (vnmc & VNMC_INF_RGB888)
> >> +               vnmc ^= VNMC_BPS;
> >> +
> >
> >
> >    Hm, this also changes the behavior for VNMC_INF_YUV16 and
> > VNMC_INF_YUV10_BT{601|656}. Is this actually intended?
> 
> Probably this code is incorrect.
> Thank you for your review.

Thanks, I have confirmed with Matsuoka-san that there is a problem here.

He has provided the following fix. Could you see about squashing it into
the above patch and reposting?


From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

[PATCH] media: soc_camera: rcar_vin: Fix bit field check

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 013d75c..da62d94 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -94,7 +94,7 @@
 #define VNMC_INF_YUV8_BT601	(1 << 16)
 #define VNMC_INF_YUV16		(5 << 16)
 #define VNMC_INF_RGB888		(6 << 16)
-#define VNMC_INF_RGB_MASK	(6 << 16)
+#define VNMC_INF_MASK		(7 << 16)
 #define VNMC_VUP		(1 << 10)
 #define VNMC_IM_ODD		(0 << 3)
 #define VNMC_IM_ODD_EVEN	(1 << 3)
@@ -675,7 +675,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	if (output_is_yuv)
 		vnmc |= VNMC_BPS;
 
-	if (vnmc & VNMC_INF_RGB_MASK)
+	if ((vnmc & VNMC_INF_MASK) == VNMC_INF_RGB888)
 		vnmc ^= VNMC_BPS;
 
 	/* progressive or interlaced mode */
