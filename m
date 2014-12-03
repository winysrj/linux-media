Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26233 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaLCMlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 07:41:10 -0500
From: Kamil Debski <k.debski@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
	linux-media@vger.kernel.org
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	'Philipp Zabel' <p.zabel@pengutronix.de>,
	'Linux PM list' <linux-pm@vger.kernel.org>,
	'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>
References: <4139875.fkJ48z9AaU@vostro.rjw.lan>
In-reply-to: <4139875.fkJ48z9AaU@vostro.rjw.lan>
Subject: RE: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 13:41:07 +0100
Message-id: <013001d00ef6$6945a520$3bd0ef60$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Wednesday, December 03, 2014 3:14 AM
> To: linux-media@vger.kernel.org
> Cc: Kyungmin Park; Sylwester Nawrocki; Mauro Carvalho Chehab; Kukjin
> Kim; linux-samsung-soc@vger.kernel.org; Kamil Debski; Philipp Zabel;
> Linux PM list; Linux Kernel Mailing List
> Subject: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
> 
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
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME
> if
> PM_SLEEP is selected) which is only in linux-next at the moment (via
> the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Looks good, for the s5p_mfc part,
Acked-by: Kamil Debski <k.debski@samsung.com>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


