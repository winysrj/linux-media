Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57723 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbcGDHHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 03:07:19 -0400
Date: Mon, 4 Jul 2016 00:07:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz
Subject: Re: [RESEND PATCH v2 0/5] ir-rx51 driver fixes
Message-ID: <20160704070709.GT28140@atomide.com>
References: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160623044436.GK22406@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160623044436.GK22406@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [160622 21:47]:
> * Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160622 12:25]:
> > ir-rx51 is a driver for Nokia N900 IR transmitter. The current series
> > fixes the remaining problems in the driver:
> 
> Thanks for updating these.
> 
> Trierry, care to ack the PWM patch?
> 
> Mauro, do you want me to set up an immutable branch with all
> these against v4.7-rc1 that we can all merge as needed?
> 
> If you want to set up the branch instead, please feel free
> to add my ack.

OK so no comments from Mauro, so I've applied these with
Thierry's ack and pushed out into omap-for-v4.8/legacy branch.

Regards,

Tony
