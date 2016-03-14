Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:45000 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbcCNASm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 20:18:42 -0400
Date: Mon, 14 Mar 2016 09:18:41 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Kaneko <ykaneko0929@gmail.com>
Subject: Re: [PATCH v3 1/2] media: soc_camera: rcar_vin: add R-Car Gen 2 and
 3 fallback compatibility strings
Message-ID: <20160314001841.GC32221@verge.net.au>
References: <1457666737-10519-1-git-send-email-horms+renesas@verge.net.au>
 <1457666737-10519-2-git-send-email-horms+renesas@verge.net.au>
 <CAMuHMdUQnY-o220E0EwtiJrWUc1AyyVmp_Kudvt8zWmn+zdu-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUQnY-o220E0EwtiJrWUc1AyyVmp_Kudvt8zWmn+zdu-Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 11, 2016 at 09:04:14AM +0100, Geert Uytterhoeven wrote:
> On Fri, Mar 11, 2016 at 4:25 AM, Simon Horman
> <horms+renesas@verge.net.au> wrote:
> > From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> >
> > Add fallback compatibility string for R-Car Gen 1 and 2.
> >
> > In the case of Renesas R-Car hardware we know that there are generations of
> > SoCs, e.g. Gen 2 and 3. But beyond that its not clear what the relationship
> > between IP blocks might be. For example, I believe that r8a7790 is older
> > than r8a7791 but that doesn't imply that the latter is a descendant of the
> > former or vice versa.
> >
> > We can, however, by examining the documentation and behaviour of the
> > hardware at run-time observe that the current driver implementation appears
> > to be compatible with the IP blocks on SoCs within a given generation.
> >
> > For the above reasons and convenience when enabling new SoCs a
> > per-generation fallback compatibility string scheme being adopted for
> > drivers for Renesas SoCs.
> >
> > Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> 
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> > --- a/drivers/media/platform/soc_camera/rcar_vin.c
> > +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> > @@ -1845,6 +1845,8 @@ static const struct of_device_id rcar_vin_of_table[] = {
> >         { .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
> >         { .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
> >         { .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> > +       { .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
> > +       { .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
> 
> Your patch is correct, but I would sort gen2 before gen3, though.

I don't feel strongly about this but I chose the order above to reflect the
sorting of the per-soc compat strings in this driver: numerically from
largest to smallest.

> >         { },
