Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43359 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754267AbbLDQfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2015 11:35:23 -0500
Message-ID: <1449246920.3451.18.camel@pengutronix.de>
Subject: Re: [PATCH 3/4] drm, ipu-v3: use https://linuxtv.org for LinuxTV URL
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
Date: Fri, 04 Dec 2015 17:35:20 +0100
In-Reply-To: <4a3d0cb06b3e4248ba4a659d7f2a7a8fa1a877fc.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
	 <4a3d0cb06b3e4248ba4a659d7f2a7a8fa1a877fc.1449232861.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 04.12.2015, 10:46 -0200 schrieb Mauro Carvalho Chehab:
> While https was always supported on linuxtv.org, only in
> Dec 3 2015 the website is using valid certificates.
> 
> As we're planning to drop pure http support on some
> future, change the references at DRM include and at
> the ipu-v3 driver to point to the https://linuxtv.org
> URL instead.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

