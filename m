Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:55880 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbcFJKWb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 06:22:31 -0400
Date: Fri, 10 Jun 2016 03:22:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH 5/7] ARM: OMAP: dmtimer: Do not call PM runtime functions
 when not needed.
Message-ID: <20160610102225.GS22406@atomide.com>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160509193624.GH5995@atomide.com>
 <5730F840.3050807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5730F840.3050807@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160509 13:52]:
> Hi,
> 
> On  9.05.2016 22:36, Tony Lindgren wrote:
> > * Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160507 08:24]:
> > > once omap_dm_timer_start() is called, which calls omap_dm_timer_enable()
> > > and thus pm_runtime_get_sync(), it doesn't make sense to call PM runtime
> > > functions again before omap_dm_timer_stop is called(). Otherwise PM runtime
> > > functions called in omap_dm_timer_enable/disable lead to long and unneeded
> > > delays.
> > > 
> > > Fix that by implementing an "enabled" counter, so the PM runtime functions
> > > get called only when really needed.
> > > 
> > > Without that patch Nokia N900 IR TX driver (ir-rx51) does not function.
> > 
> 
> Well, I just tested again, with the $subject patch reverted and
> contradictory to my own words, it worked just fine. I believe the reason is
> that I did hrtimer "migration" after I did the $subject patch. I was
> thinking the reason for the slow transmission was PWM dmtimer, but now it
> turns out it has been the "pulse" dmtimer. So, I think the $subject patch
> should be dropped.
> 
> > We should use pm_runtime for the refcounting though and call PM runtime
> > unconditionally. Can you try to follow the standard PM runtime usage
> > like this:
> > 
> 
> It works without that, but on the other hand, I finally have some reference
> on how PM runtime API should be called :).

OK. And I just applied the related dts changes. Please repost the driver
changes and DT binding doc with Rob's ack to the driver maintainers to
apply.

Regards,

Tony
