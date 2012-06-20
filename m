Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:43305 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab2FTOEJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 10:04:09 -0400
Date: Wed, 20 Jun 2012 22:03:56 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	<fabio.estevam@freescale.com>, <dirk.behme@googlemail.com>,
	<r.schwebel@pengutronix.de>, <kernel@pengutronix.de>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for 'Coda' video codec IP.
Message-ID: <20120620140354.GB2513@S2101-09.ap.freescale.net>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
 <20120619181717.GE28394@pengutronix.de>
 <CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
 <20120620090126.GO28394@pengutronix.de>
 <20120620100015.GA30243@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120620100015.GA30243@sirena.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:00:15AM +0100, Mark Brown wrote:
> The approach a lot of platforms have been taking is that it's OK to keep
> on maintaining existing boards using board files (especially for trivial
> things like adding new devices).

If the device is added without introducing any platform_data, we may
take it as trivial things, but otherwise we are just creating something
making the later device tree conversion difficult.

-- 
Regards,
Shawn

