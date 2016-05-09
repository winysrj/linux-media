Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36467 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbcEIUvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 16:51:17 -0400
Subject: Re: [PATCH 5/7] ARM: OMAP: dmtimer: Do not call PM runtime functions
 when not needed.
To: Tony Lindgren <tony@atomide.com>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160509193624.GH5995@atomide.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5730F840.3050807@gmail.com>
Date: Mon, 9 May 2016 23:51:12 +0300
MIME-Version: 1.0
In-Reply-To: <20160509193624.GH5995@atomide.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On  9.05.2016 22:36, Tony Lindgren wrote:
> * Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> [160507 08:24]:
>> once omap_dm_timer_start() is called, which calls omap_dm_timer_enable()
>> and thus pm_runtime_get_sync(), it doesn't make sense to call PM runtime
>> functions again before omap_dm_timer_stop is called(). Otherwise PM runtime
>> functions called in omap_dm_timer_enable/disable lead to long and unneeded
>> delays.
>>
>> Fix that by implementing an "enabled" counter, so the PM runtime functions
>> get called only when really needed.
>>
>> Without that patch Nokia N900 IR TX driver (ir-rx51) does not function.
>

Well, I just tested again, with the $subject patch reverted and 
contradictory to my own words, it worked just fine. I believe the reason 
is that I did hrtimer "migration" after I did the $subject patch. I was 
thinking the reason for the slow transmission was PWM dmtimer, but now 
it turns out it has been the "pulse" dmtimer. So, I think the $subject 
patch should be dropped.

> We should use pm_runtime for the refcounting though and call PM runtime
> unconditionally. Can you try to follow the standard PM runtime usage
> like this:
>

It works without that, but on the other hand, I finally have some 
reference on how PM runtime API should be called :).

> init:
> pm_runtime_use_autosuspend(&timer->pdev->dev);
> pm_runtime_set_autosuspend_delay(&timer->pdev->dev, 200);
> pm_runtime_enable(&timer->pdev->dev);
> ...
> enable:
> pm_runtime_get_sync(&timer->pdev->dev);
> ...
> disable:
> pm_runtime_mark_last_busy(&timer->pdev->dev);
> pm_runtime_put_autosuspend(&timer->pdev->dev);
> ...
> exit:
> pm_runtime_dont_use_autosuspend(&timer->pdev->dev);
> pm_runtime_put_sync(&timer->pdev->dev);
> pm_runtime_disable(&timer->pdev->dev);
>
> No idea what the timeout should be, maybe less than 200 ms. Also we need
> to test that off idle still works with timer1, that might need special
> handling.
>

Thanks,
Ivo
