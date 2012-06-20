Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34017 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2FTOZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 10:25:56 -0400
Received: by yenl2 with SMTP id l2so5231321yen.19
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 07:25:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120620130941.GB2253@S2101-09.ap.freescale.net>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
	<20120619181717.GE28394@pengutronix.de>
	<CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
	<20120620090126.GO28394@pengutronix.de>
	<20120620100015.GA30243@sirena.org.uk>
	<20120620130941.GB2253@S2101-09.ap.freescale.net>
Date: Wed, 20 Jun 2012 16:25:54 +0200
Message-ID: <CACKLOr28vm9n08VSOim=riB54os665be1CHdUqFXk+3MqPqtWQ@mail.gmail.com>
Subject: Re: [RFC] Support for 'Coda' video codec IP.
From: javier Martin <javier.martin@vista-silicon.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	fabio.estevam@freescale.com, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de, kernel@pengutronix.de,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 June 2012 15:09, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Jun 20, 2012 at 11:00:15AM +0100, Mark Brown wrote:
>> The approach a lot of platforms have been taking is that it's OK to keep
>> on maintaining existing boards using board files (especially for trivial
>> things like adding new devices).
>
> I think that's the approach being taken during the transition to device
> tree.  But it's definitely a desirable thing to remove those board
> files with device tree support at some point, because not having non-DT
> users will ease platform maintenance and new feature adoption a lot
> easier, for example linear irqdomain.

Do you plan to add pinctrl support for i.MX27 and i.MX21?


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
