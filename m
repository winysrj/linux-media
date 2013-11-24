Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35563 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3KXSjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 13:39:16 -0500
Date: Sun, 24 Nov 2013 19:39:08 +0100
From: Gerhard Sittig <gsi@denx.de>
To: linuxppc-dev@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Anatolij Gustschin <agust@denx.de>,
	Mike Turquette <mturquette@linaro.org>
Cc: Scott Wood <scottwood@freescale.com>, Detlev Zundel <dzu@denx.de>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Woodhouse <dwmw2@infradead.org>,
	devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Kumar Gala <galak@kernel.crashing.org>,
	linux-can@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-serial@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Mackerras <paulus@samba.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH v5 00/17] add COMMON_CLK support for PowerPC MPC512x
Message-ID: <20131124183908.GG2760@book.gsilab.sittig.org>
References: <1384729577-7336-1-git-send-email-gsi@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384729577-7336-1-git-send-email-gsi@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 18, 2013 at 00:06 +0100, Gerhard Sittig wrote:
> 
> the series is based on v3.12, but I'll rebase against v3.13-rc1
> (when available) or any other subtree upon request

Now that v3.13-rc1 is out, I noticed that the series no longer
applies cleanly (minor context changes and conflicts) and needs
minor adjustment.

Compilation of 4/17 requires <linux/of_address.h> which no longer
is included implicitly.

PPC_CLOCK removal in 7/17 should remove <asm/clk_interface.h> as
well after all references to this header file have gone.  (And
the context of the patch has changed.)

The context of 16/17 for DIU initialization has changed.

I'll wait for a few more days whether there is more feedback for
v5 (especially on the device tree backwards compat approach),
then will rebase and send out v6 of the series.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
