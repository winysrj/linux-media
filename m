Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60591 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GTLUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 07:20:14 -0400
Date: Fri, 20 Jul 2012 13:19:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-media@vger.kernel.org,
	fabio.estevam@freescale.com, linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	kernel@pengutronix.de, Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] [v3] i.MX27: Fix emma-prp clocks in mx2_camera.c
In-Reply-To: <CACKLOr0hfbv4qnp79XyXzNCE=oXS+7JA31knoXjGU+STG9Fxfg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1207201247500.27906@axis700.grange>
References: <1341572162-29126-1-git-send-email-javier.martin@vista-silicon.com>
 <20120709072809.GP30009@pengutronix.de> <CACKLOr25yb1Cx4XNriyPceBcqmc5T4jDpJXFpve9JCXpP7iMLg@mail.gmail.com>
 <20120709074337.GT30009@pengutronix.de> <CACKLOr05W5N4n9TSKdaCP-6-j+zDSr=aNG4QoTMVWXTrM30x7Q@mail.gmail.com>
 <20120709080703.GU30009@pengutronix.de> <CACKLOr0hfbv4qnp79XyXzNCE=oXS+7JA31knoXjGU+STG9Fxfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

Thanks for the patch

On Mon, 9 Jul 2012, javier Martin wrote:

> On 9 July 2012 10:07, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Mon, Jul 09, 2012 at 09:46:03AM +0200, javier Martin wrote:
> >> On 9 July 2012 09:43, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >> > On Mon, Jul 09, 2012 at 09:37:25AM +0200, javier Martin wrote:
> >> >> On 9 July 2012 09:28, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >> >> > On Fri, Jul 06, 2012 at 12:56:02PM +0200, Javier Martin wrote:
> >> >> >> This driver wasn't converted to the new clock changes
> >> >> >> (clk_prepare_enable/clk_disable_unprepare). Also naming
> >> >> >> of emma-prp related clocks for the i.MX27 was not correct.
> >> >> >> ---
> >> >> >> Enable clocks only for i.MX27.
> >> >> >>
> >> >> >
> >> >> > Indeed,
> >> >> >
> >> >> >>
> >> >> >> -     pcdev->clk_csi = clk_get(&pdev->dev, NULL);
> >> >> >> -     if (IS_ERR(pcdev->clk_csi)) {
> >> >> >> -             dev_err(&pdev->dev, "Could not get csi clock\n");
> >> >> >> -             err = PTR_ERR(pcdev->clk_csi);
> >> >> >> -             goto exit_kfree;
> >> >> >> +     if (cpu_is_mx27()) {
> >> >> >> +             pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
> >> >> >> +             if (IS_ERR(pcdev->clk_csi)) {
> >> >> >> +                     dev_err(&pdev->dev, "Could not get csi clock\n");
> >> >> >> +                     err = PTR_ERR(pcdev->clk_csi);
> >> >> >> +                     goto exit_kfree;
> >> >> >> +             }
> >> >> >
> >> >> > but why? Now the i.MX25 won't get a clock anymore.
> >> >>
> >> >> What are the clocks needed by i.MX25? csi only?
> >> >>
> >> >> By the way, is anybody using this driver with i.MX25?
> >> >
> >> > It seems Baruch (added to Cc) has used it on an i.MX25.
> >>
> >> Baruch,
> >> could you tell us what are the clocks needed by i.MX25?
> >
> > I just had a look and the i.MX25 it needs three clocks: ipg, ahb and
> > peripheral clock. So this is broken anyway and should probably be fixed
> > seperately, that is:
> >
> > - provide dummy clocks for the csi clocks on i.MX27
> > - clk_get ipg, ahb and peripheral clocks on all SoCs
> > - clk_get emma clocks on i.MX27 only
> >
> > As said, this is a separate topic, so your original patch should be fine
> > for now.

Well, sorry, but I don't think I can share this.

1. it touches two areas - arch/ and drivers/ which isnÄt a good thing and 
   should be avoided wherever possible
2. it addresses several problems: (a) missing name for "ahb" camera clock, 
   (b) wrong device and connection names for emma clocks, (c) missing 
   _(un)prepare suffixes in clock API
3. it makes a possibly broken i.MX25 even more broken

IIUC, mx2-camera is broken on i.MX27 in current next because of wrong 
clock entries, right? So, we don't have to be bothered not to break 
bisection - it is already broken. Then we can clean up the problems 
separately under arch/ and drivers/.

So, would it be possible to split this into 3 parts:

(a) arch - fix clocks
(b) media - fix clocks on i.MX27 _without_ breaking it even further on 
    i.MX25. If we think i.MX25 support is already broken, let's schedule 
    its removal and remove properly, or add BROKEN to Kconfig, when built 
    on i.MX25. In your patch this would mean just adding an "else" to your 
    "if (cpu_is_mx27())" statement and moving the current clk_get() there
(c) add _(un)prepare.

Since these are fixes, I won't wait too long for these. If you don't 
resubmit them today, they'll go in after 3.6-rc1.

Thanks
Guennadi

> OK, thanks for your interest.
> 
> Regards.
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
