Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49799 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaKPInz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 03:43:55 -0500
Date: Sun, 16 Nov 2014 09:43:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	sakari.ailus@iki.fi, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141116084353.GC30646@amd>
References: <20141116075928.GA9763@amd>
 <54685C18.1020109@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54685C18.1020109@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun 2014-11-16 09:11:04, Lars-Peter Clausen wrote:
> On 11/16/2014 08:59 AM, Pavel Machek wrote:
> >[...]
> >+	adp1653: adp1653@30 {
> >+		compatible = "ad,adp1653";
> 
> The Analog Devices vendor prefix is adi.

Thanks, will be fixed in next version.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
