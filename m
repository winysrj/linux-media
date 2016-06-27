Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34823 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbcF0STn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 14:19:43 -0400
Subject: Re: [RESEND PATCH v2 1/5] ir-rx51: Fix build after multiarch changes
 broke it
To: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>
References: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1466623341-30130-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <201606231948.51640@pali>
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pavel@ucw.cz,
	Neil Armstrong <narmstrong@baylibre.com>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <57716E27.2040702@gmail.com>
Date: Mon, 27 Jun 2016 21:19:19 +0300
MIME-Version: 1.0
In-Reply-To: <201606231948.51640@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 23.06.2016 20:48, Pali Rohár wrote:
> On Wednesday 22 June 2016 21:22:17 Ivaylo Dimitrov wrote:
>> The ir-rx51 driver for n900 has been disabled since the multiarch
>> changes as plat include directory no longer is SoC specific.
>>
>> Let's fix it with minimal changes to pass the dmtimer calls in
>> pdata. Then the following changes can be done while things can
>> be tested to be working for each change:
>>
>> 1. Change the non-pwm dmtimer to use just hrtimer if possible
>>
>> 2. Change the pwm dmtimer to use Linux PWM API with the new
>>     drivers/pwm/pwm-omap-dmtimer.c and remove the direct calls
>>     to dmtimer functions
>>
>> 3. Parse configuration from device tree and drop the pdata
>>
>> Note compilation of this depends on the previous patch
>> "ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51".
>
> I think that this extensive description is not needed for commit
> message. Just for email discussion.
>

I guess Tony can strip the description a bit before applying.

Ivo
