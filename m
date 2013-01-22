Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab3AVPlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 10:41:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 09/15] media: coda: don't build on multiplatform
Date: Tue, 22 Jan 2013 15:41:05 +0000
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	arm@kernel.org, Javier Martin <javier.martin@vista-silicon.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-10-git-send-email-arnd@arndb.de> <20130122082158.GC9414@pengutronix.de>
In-Reply-To: <20130122082158.GC9414@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221541.05636.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 22 January 2013, Sascha Hauer wrote:
> On Mon, Jan 21, 2013 at 05:16:02PM +0000, Arnd Bergmann wrote:
> > The coda video codec driver depends on a mach-imx or mach-mxs specific
> > header file "mach/iram.h". This is not available when building for
> > multiplatform, so let us disable this driver for v3.8 when building
> > multiplatform, and hopefully find a proper fix for v3.9.
> > 
> > drivers/media/platform/coda.c:27:23: fatal error: mach/iram.h: No such file or directory
> 
> I just sent a pull request for this with a proper fix.

Ok, even better. Thanks for taking care of it!

	Arnd
