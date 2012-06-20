Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58972 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2FTKAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 06:00:21 -0400
Date: Wed, 20 Jun 2012 11:00:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: javier Martin <javier.martin@vista-silicon.com>,
	fabio.estevam@freescale.com, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de, kernel@pengutronix.de,
	shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [RFC] Support for 'Coda' video codec IP.
Message-ID: <20120620100015.GA30243@sirena.org.uk>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
 <20120619181717.GE28394@pengutronix.de>
 <CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
 <20120620090126.GO28394@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620090126.GO28394@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:01:26AM +0200, Sascha Hauer wrote:
> On Wed, Jun 20, 2012 at 09:51:32AM +0200, javier Martin wrote:

> > Our platfrom, 'visstrim_m10' doesn't currently support devicetree yet,
> > so it would be highly difficult for us to test it at the moment.
> > Couldn't you add devicetree support in a later patch?

> I try to motivate people moving to devicetree. At some point I'd like to
> get rid of the platform based boards in the tree. Adding new platform
> seems like delaying this instead of working towards a platform board
> free Kernel.
> Any other opinions on this?

The approach a lot of platforms have been taking is that it's OK to keep
on maintaining existing boards using board files (especially for trivial
things like adding new devices).
