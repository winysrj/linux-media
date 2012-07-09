Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44593 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2GIIWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 04:22:50 -0400
Received: by wgbdr13 with SMTP id dr13so11188850wgb.1
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 01:22:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120709080703.GU30009@pengutronix.de>
References: <1341572162-29126-1-git-send-email-javier.martin@vista-silicon.com>
	<20120709072809.GP30009@pengutronix.de>
	<CACKLOr25yb1Cx4XNriyPceBcqmc5T4jDpJXFpve9JCXpP7iMLg@mail.gmail.com>
	<20120709074337.GT30009@pengutronix.de>
	<CACKLOr05W5N4n9TSKdaCP-6-j+zDSr=aNG4QoTMVWXTrM30x7Q@mail.gmail.com>
	<20120709080703.GU30009@pengutronix.de>
Date: Mon, 9 Jul 2012 10:22:49 +0200
Message-ID: <CACKLOr0hfbv4qnp79XyXzNCE=oXS+7JA31knoXjGU+STG9Fxfg@mail.gmail.com>
Subject: Re: [PATCH] [v3] i.MX27: Fix emma-prp clocks in mx2_camera.c
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de,
	Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9 July 2012 10:07, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, Jul 09, 2012 at 09:46:03AM +0200, javier Martin wrote:
>> On 9 July 2012 09:43, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Mon, Jul 09, 2012 at 09:37:25AM +0200, javier Martin wrote:
>> >> On 9 July 2012 09:28, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> >> > On Fri, Jul 06, 2012 at 12:56:02PM +0200, Javier Martin wrote:
>> >> >> This driver wasn't converted to the new clock changes
>> >> >> (clk_prepare_enable/clk_disable_unprepare). Also naming
>> >> >> of emma-prp related clocks for the i.MX27 was not correct.
>> >> >> ---
>> >> >> Enable clocks only for i.MX27.
>> >> >>
>> >> >
>> >> > Indeed,
>> >> >
>> >> >>
>> >> >> -     pcdev->clk_csi = clk_get(&pdev->dev, NULL);
>> >> >> -     if (IS_ERR(pcdev->clk_csi)) {
>> >> >> -             dev_err(&pdev->dev, "Could not get csi clock\n");
>> >> >> -             err = PTR_ERR(pcdev->clk_csi);
>> >> >> -             goto exit_kfree;
>> >> >> +     if (cpu_is_mx27()) {
>> >> >> +             pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
>> >> >> +             if (IS_ERR(pcdev->clk_csi)) {
>> >> >> +                     dev_err(&pdev->dev, "Could not get csi clock\n");
>> >> >> +                     err = PTR_ERR(pcdev->clk_csi);
>> >> >> +                     goto exit_kfree;
>> >> >> +             }
>> >> >
>> >> > but why? Now the i.MX25 won't get a clock anymore.
>> >>
>> >> What are the clocks needed by i.MX25? csi only?
>> >>
>> >> By the way, is anybody using this driver with i.MX25?
>> >
>> > It seems Baruch (added to Cc) has used it on an i.MX25.
>>
>> Baruch,
>> could you tell us what are the clocks needed by i.MX25?
>
> I just had a look and the i.MX25 it needs three clocks: ipg, ahb and
> peripheral clock. So this is broken anyway and should probably be fixed
> seperately, that is:
>
> - provide dummy clocks for the csi clocks on i.MX27
> - clk_get ipg, ahb and peripheral clocks on all SoCs
> - clk_get emma clocks on i.MX27 only
>
> As said, this is a separate topic, so your original patch should be fine
> for now.

OK, thanks for your interest.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
