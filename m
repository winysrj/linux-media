Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:53725 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbcEITga (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 15:36:30 -0400
Date: Mon, 9 May 2016 12:36:24 -0700
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
Message-ID: <20160509193624.GH5995@atomide.com>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462634508-24961-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160507 08:24]:
> once omap_dm_timer_start() is called, which calls omap_dm_timer_enable()
> and thus pm_runtime_get_sync(), it doesn't make sense to call PM runtime
> functions again before omap_dm_timer_stop is called(). Otherwise PM runtime
> functions called in omap_dm_timer_enable/disable lead to long and unneeded
> delays.
> 
> Fix that by implementing an "enabled" counter, so the PM runtime functions
> get called only when really needed.
> 
> Without that patch Nokia N900 IR TX driver (ir-rx51) does not function.

We should use pm_runtime for the refcounting though and call PM runtime
unconditionally. Can you try to follow the standard PM runtime usage
like this:

init:
pm_runtime_use_autosuspend(&timer->pdev->dev);
pm_runtime_set_autosuspend_delay(&timer->pdev->dev, 200);
pm_runtime_enable(&timer->pdev->dev);
...
enable:
pm_runtime_get_sync(&timer->pdev->dev);
...
disable:
pm_runtime_mark_last_busy(&timer->pdev->dev);
pm_runtime_put_autosuspend(&timer->pdev->dev);
...
exit:
pm_runtime_dont_use_autosuspend(&timer->pdev->dev);
pm_runtime_put_sync(&timer->pdev->dev);
pm_runtime_disable(&timer->pdev->dev);

No idea what the timeout should be, maybe less than 200 ms. Also we need
to test that off idle still works with timer1, that might need special
handling.

Regards,

Tony
