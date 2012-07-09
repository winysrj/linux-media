Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:41446 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GIICd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 04:02:33 -0400
Date: Mon, 9 Jul 2012 10:52:25 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-media@vger.kernel.org,
	fabio.estevam@freescale.com, linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] [v3] i.MX27: Fix emma-prp clocks in mx2_camera.c
Message-ID: <20120709075225.GI22116@sapphire.tkos.co.il>
References: <1341572162-29126-1-git-send-email-javier.martin@vista-silicon.com>
 <20120709072809.GP30009@pengutronix.de>
 <CACKLOr25yb1Cx4XNriyPceBcqmc5T4jDpJXFpve9JCXpP7iMLg@mail.gmail.com>
 <20120709074337.GT30009@pengutronix.de>
 <CACKLOr05W5N4n9TSKdaCP-6-j+zDSr=aNG4QoTMVWXTrM30x7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr05W5N4n9TSKdaCP-6-j+zDSr=aNG4QoTMVWXTrM30x7Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Mon, Jul 09, 2012 at 09:46:03AM +0200, javier Martin wrote:
> On 9 July 2012 09:43, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Mon, Jul 09, 2012 at 09:37:25AM +0200, javier Martin wrote:
> >> On 9 July 2012 09:28, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >> > On Fri, Jul 06, 2012 at 12:56:02PM +0200, Javier Martin wrote:
> >> >> This driver wasn't converted to the new clock changes
> >> >> (clk_prepare_enable/clk_disable_unprepare). Also naming
> >> >> of emma-prp related clocks for the i.MX27 was not correct.
> >> >> ---
> >> >> Enable clocks only for i.MX27.
> >> >
> >> > Indeed,
> >> >
> >> >> -     pcdev->clk_csi = clk_get(&pdev->dev, NULL);
> >> >> -     if (IS_ERR(pcdev->clk_csi)) {
> >> >> -             dev_err(&pdev->dev, "Could not get csi clock\n");
> >> >> -             err = PTR_ERR(pcdev->clk_csi);
> >> >> -             goto exit_kfree;
> >> >> +     if (cpu_is_mx27()) {
> >> >> +             pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
> >> >> +             if (IS_ERR(pcdev->clk_csi)) {
> >> >> +                     dev_err(&pdev->dev, "Could not get csi clock\n");
> >> >> +                     err = PTR_ERR(pcdev->clk_csi);
> >> >> +                     goto exit_kfree;
> >> >> +             }
> >> >
> >> > but why? Now the i.MX25 won't get a clock anymore.
> >>
> >> What are the clocks needed by i.MX25? csi only?
> >>
> >> By the way, is anybody using this driver with i.MX25?
> >
> > It seems Baruch (added to Cc) has used it on an i.MX25.
> could you tell us what are the clocks needed by i.MX25?

According to the code the csi clock is sufficient for i.MX25. Unfortunately I 
don't have access to a running system anymore, so I can't test current code.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
