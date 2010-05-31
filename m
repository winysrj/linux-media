Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52961 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754032Ab0EaNCB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 09:02:01 -0400
Date: Mon, 31 May 2010 14:01:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	George Joseph <george.joseph@fairview5.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Guillaume Ligneul <guillaume.ligneul@gmail.com>,
	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Alessandro Rubini <rubini@ipvvis.unipv.it>,
	Richard Purdie <rpurdie@rpsys.net>,
	Colin Leroy <colin@colino.net>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Paul Gortmaker <p_gortmaker@yahoo.com>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Greg Kroah-Hartman <gregkh@suse.de>, lm-sensors@lm-sensors.org,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	linuxppc-dev@ozlabs.org, linux-media@vger.kernel.org,
	linux-mtd@lists.infradead.org, rtc-linux@googlegroups.com,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: remove all i2c_set_clientdata(client, NULL)
Message-ID: <20100531130157.GA10507@rakim.wolfsonmicro.main>
References: <1275310552-14685-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275310552-14685-1-git-send-email-w.sang@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 31, 2010 at 02:55:48PM +0200, Wolfram Sang wrote:
> I2C-drivers can use the clientdata-pointer to point to private data. As I2C
> devices are not really unregistered, but merely detached from their driver, it
> used to be the drivers obligation to clear this pointer during remove() or a
> failed probe(). As a couple of drivers forgot to do this, it was agreed that it
> was cleaner if the i2c-core does this clearance when appropriate, as there is
> no guarantee for the lifetime of the clientdata-pointer after remove() anyhow.
> This feature was added to the core with commit
> e4a7b9b04de15f6b63da5ccdd373ffa3057a3681 to fix the faulty drivers.
> 
> As there is no need anymore to clear the clientdata-pointer, remove all current
> occurrences in the drivers to simplify the code and prevent confusion.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
