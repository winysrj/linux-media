Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39638 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2GTNEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 09:04:54 -0400
Received: by wgbdr13 with SMTP id dr13so3621611wgb.1
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 06:04:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1207201247500.27906@axis700.grange>
References: <1341572162-29126-1-git-send-email-javier.martin@vista-silicon.com>
	<20120709072809.GP30009@pengutronix.de>
	<CACKLOr25yb1Cx4XNriyPceBcqmc5T4jDpJXFpve9JCXpP7iMLg@mail.gmail.com>
	<20120709074337.GT30009@pengutronix.de>
	<CACKLOr05W5N4n9TSKdaCP-6-j+zDSr=aNG4QoTMVWXTrM30x7Q@mail.gmail.com>
	<20120709080703.GU30009@pengutronix.de>
	<CACKLOr0hfbv4qnp79XyXzNCE=oXS+7JA31knoXjGU+STG9Fxfg@mail.gmail.com>
	<Pine.LNX.4.64.1207201247500.27906@axis700.grange>
Date: Fri, 20 Jul 2012 15:04:51 +0200
Message-ID: <CACKLOr3jPjmN25HVU+8Gw95USuGmDAZRAn2zGuC=TCMerjt9Nw@mail.gmail.com>
Subject: Re: [PATCH] [v3] i.MX27: Fix emma-prp clocks in mx2_camera.c
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-media@vger.kernel.org,
	fabio.estevam@freescale.com, linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	kernel@pengutronix.de, Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 July 2012 13:19, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Javier
>
> Thanks for the patch
>
> On Mon, 9 Jul 2012, javier Martin wrote:
>
>> On 9 July 2012 10:07, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Mon, Jul 09, 2012 at 09:46:03AM +0200, javier Martin wrote:
>> >> On 9 July 2012 09:43, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> >> > On Mon, Jul 09, 2012 at 09:37:25AM +0200, javier Martin wrote:
>> >> >> On 9 July 2012 09:28, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> >> >> > On Fri, Jul 06, 2012 at 12:56:02PM +0200, Javier Martin wrote:
>> >> >> >> This driver wasn't converted to the new clock changes
>> >> >> >> (clk_prepare_enable/clk_disable_unprepare). Also naming
>> >> >> >> of emma-prp related clocks for the i.MX27 was not correct.
>> >> >> >> ---
>> >> >> >> Enable clocks only for i.MX27.
>> >> >> >>
>> >> >> >
>> >> >> > Indeed,
>> >> >> >
>> >> >> >>
>> >> >> >> -     pcdev->clk_csi = clk_get(&pdev->dev, NULL);
>> >> >> >> -     if (IS_ERR(pcdev->clk_csi)) {
>> >> >> >> -             dev_err(&pdev->dev, "Could not get csi clock\n");
>> >> >> >> -             err = PTR_ERR(pcdev->clk_csi);
>> >> >> >> -             goto exit_kfree;
>> >> >> >> +     if (cpu_is_mx27()) {
>> >> >> >> +             pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
>> >> >> >> +             if (IS_ERR(pcdev->clk_csi)) {
>> >> >> >> +                     dev_err(&pdev->dev, "Could not get csi clock\n");
>> >> >> >> +                     err = PTR_ERR(pcdev->clk_csi);
>> >> >> >> +                     goto exit_kfree;
>> >> >> >> +             }
>> >> >> >
>> >> >> > but why? Now the i.MX25 won't get a clock anymore.
>> >> >>
>> >> >> What are the clocks needed by i.MX25? csi only?
>> >> >>
>> >> >> By the way, is anybody using this driver with i.MX25?
>> >> >
>> >> > It seems Baruch (added to Cc) has used it on an i.MX25.
>> >>
>> >> Baruch,
>> >> could you tell us what are the clocks needed by i.MX25?
>> >
>> > I just had a look and the i.MX25 it needs three clocks: ipg, ahb and
>> > peripheral clock. So this is broken anyway and should probably be fixed
>> > seperately, that is:
>> >
>> > - provide dummy clocks for the csi clocks on i.MX27
>> > - clk_get ipg, ahb and peripheral clocks on all SoCs
>> > - clk_get emma clocks on i.MX27 only
>> >
>> > As said, this is a separate topic, so your original patch should be fine
>> > for now.
>
> Well, sorry, but I don't think I can share this.
>
> 1. it touches two areas - arch/ and drivers/ which isnÄt a good thing and
>    should be avoided wherever possible
> 2. it addresses several problems: (a) missing name for "ahb" camera clock,
>    (b) wrong device and connection names for emma clocks, (c) missing
>    _(un)prepare suffixes in clock API
> 3. it makes a possibly broken i.MX25 even more broken
>
> IIUC, mx2-camera is broken on i.MX27 in current next because of wrong
> clock entries, right? So, we don't have to be bothered not to break
> bisection - it is already broken. Then we can clean up the problems
> separately under arch/ and drivers/.
>
> So, would it be possible to split this into 3 parts:
>
> (a) arch - fix clocks
> (b) media - fix clocks on i.MX27 _without_ breaking it even further on
>     i.MX25. If we think i.MX25 support is already broken, let's schedule
>     its removal and remove properly, or add BROKEN to Kconfig, when built
>     on i.MX25. In your patch this would mean just adding an "else" to your
>     "if (cpu_is_mx27())" statement and moving the current clk_get() there
> (c) add _(un)prepare.
>
> Since these are fixes, I won't wait too long for these. If you don't
> resubmit them today, they'll go in after 3.6-rc1.
>
> Thanks
> Guennadi
>
>> OK, thanks for your interest.
>>
>> Regards.
>> --
>> Javier Martin
>> Vista Silicon S.L.
>> CDTUC - FASE C - Oficina S-345
>> Avda de los Castros s/n
>> 39005- Santander. Cantabria. Spain
>> +34 942 25 32 60
>> www.vista-silicon.com
>>
>

Hi Guennadi,
thanks for your review.

I could agree with some of your reasons for not accepting this patch.
Specially (1) and (2).
As regards of reason (3), i.MX25 has been broken for months and I
refuse that a broken chip that no known board in the mainline uses is
constantly slowing the development process.

Furthermore, I sent v3 of this patch 11 days ago. I know you are a
busy developer but, honestly, it doesn't seem fair that, having sent
the patch with plenty of time I am now given only this little time to
fix it. I'm out of the office right now and I won't come back until
monday. Couldn't you either make an exception and accept the path or
give me until monday in the morning to send the new version?

Alternatively, Sascha, Fabio or any other i.MX27 user could send it
too if they have the time.

Otherwise, as you stated it'll have to wait to 3.6-rc1. So 3.5 will be
broken for i.MX27.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
