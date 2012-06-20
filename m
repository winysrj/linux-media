Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49931 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2FTOK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 10:10:28 -0400
Received: by gglu4 with SMTP id u4so5649292ggl.19
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 07:10:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120620140354.GB2513@S2101-09.ap.freescale.net>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
	<20120619181717.GE28394@pengutronix.de>
	<CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
	<20120620090126.GO28394@pengutronix.de>
	<20120620100015.GA30243@sirena.org.uk>
	<20120620140354.GB2513@S2101-09.ap.freescale.net>
Date: Wed, 20 Jun 2012 16:10:27 +0200
Message-ID: <CACKLOr0PA_+RRu7GEP9KJ1973wUSkE2Ra-DPdZCEPNfjcw6mwA@mail.gmail.com>
Subject: Re: [RFC] Support for 'Coda' video codec IP.
From: javier Martin <javier.martin@vista-silicon.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	fabio.estevam@freescale.com, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de, kernel@pengutronix.de,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 20 June 2012 16:03, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Jun 20, 2012 at 11:00:15AM +0100, Mark Brown wrote:
>> The approach a lot of platforms have been taking is that it's OK to keep
>> on maintaining existing boards using board files (especially for trivial
>> things like adding new devices).
>
> If the device is added without introducing any platform_data, we may
> take it as trivial things, but otherwise we are just creating something
> making the later device tree conversion difficult.
>

in this RFC I've added the firmware name as platform data just because
I don't know what will be the final name that Freescale will use to
upload the firmware to linux-firmware repository.
However, this platform data is not really needed; there are 3 coda
versions out there in different i.MX chips. We can just detect the
i.MX model and load the proper firmware based on this data.

If I drop this platform data it is OK with you if I don't add device
tree support by now?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
