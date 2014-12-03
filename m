Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56792 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaLCMMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 07:12:35 -0500
Message-ID: <1417608753.5124.10.camel@pengutronix.de>
Subject: Re: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kamil Debski <k.debski@samsung.com>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 03 Dec 2014 13:12:33 +0100
In-Reply-To: <4139875.fkJ48z9AaU@vostro.rjw.lan>
References: <4139875.fkJ48z9AaU@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 03.12.2014, 03:13 +0100 schrieb Rafael J. Wysocki:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> replaced with CONFIG_PM too.
> 
> Make these changes everywhere under drivers/media/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

For the coda part,
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

