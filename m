Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:41623 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaJQMiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 08:38:54 -0400
Date: Fri, 17 Oct 2014 14:38:41 +0200
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Add r8a7794, r8a7793
 device support
Message-ID: <20141017123841.GA20290@verge.net.au>
References: <1413529659-7752-1-git-send-email-ykaneko0929@gmail.com>
 <2001400.nVOdqiCF3c@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2001400.nVOdqiCF3c@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 17, 2014 at 11:01:07AM +0300, Laurent Pinchart wrote:
> Hi Kaneko-san,
> 
> Thank you for the patch.
> 
> Could you please also update 
> Documentation/devicetree/bindings/media/rcar_vin.txt with the new compatible 
> strings ?

Hi Laurent,

thanks for pointing that out. It is true that we want DT support for the
new SoCs for this driver and in that case updating the bindings
documentation would be necessary.  However, this patch adds platform device
support.

What I suggest is dropping this patch for now and working on
a replacement that adds DT support only. I do not believe there
are any plans to use a platform device in mainline for this driver on the
new SoCs.

> On Friday 17 October 2014 16:07:39 Yoshihiro Kaneko wrote:
> > From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> > 
> > Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> > Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> > Acked-by: Simon Horman <horms+renesas@verge.net.au>
> > 
> > ---
> > 
> > This patch is against master branch of linuxtv.org/media_tree.git.
> > 
> > v2 [Yoshihiro Kaneko]
> > * Squashed r8a7793 and r8a7794 patches
> > 
> >  drivers/media/platform/soc_camera/rcar_vin.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> > b/drivers/media/platform/soc_camera/rcar_vin.c index 234cf86..4acae8f
> > 100644
> > --- a/drivers/media/platform/soc_camera/rcar_vin.c
> > +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> > @@ -1881,6 +1881,8 @@ MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
> >  #endif
> > 
> >  static struct platform_device_id rcar_vin_id_table[] = {
> > +	{ "r8a7794-vin",  RCAR_GEN2 },
> > +	{ "r8a7793-vin",  RCAR_GEN2 },
> >  	{ "r8a7791-vin",  RCAR_GEN2 },
> >  	{ "r8a7790-vin",  RCAR_GEN2 },
> >  	{ "r8a7779-vin",  RCAR_H1 },
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
