Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33833 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbDCRQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:16:46 -0400
Date: Fri, 3 Apr 2015 18:16:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Daniel Mack <daniel@zonque.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Jason Cooper <jason@lakedaemon.net>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Turquette <mturquette@linaro.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Roland Stigge <stigge@antcom.de>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Takashi Iwai <tiwai@suse.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 00/14] Fix fallout from per-user struct clk patches
Message-ID: <20150403171637.GA29798@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 03, 2015 at 06:11:49PM +0100, Russell King - ARM Linux wrote:
> Sorry for posting this soo close to the 4.1 merge window, I had
> completely forgotten about this chunk of work I did earlier this
> month.

Correction - earlier _last_ month - 1st/2nd March to be exact.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
