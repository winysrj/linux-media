Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:32873 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1ANPGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 10:06:18 -0500
Message-ID: <4D306667.2070300@linuxtv.org>
Date: Fri, 14 Jan 2011 16:06:15 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Thierry LELEGARD <tlelegard@logiways.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [linux-media] API V3 vs SAPI behavior difference in reading tuning
 parameters
References: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr>
In-Reply-To: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Thierry,

On 01/14/2011 02:35 PM, Thierry LELEGARD wrote:
> Dear all,
> 
> I would like to report an annoying behavior difference between S2API and the
> legacy DVB API (V3) when _reading_ the current tuning configuration.
> 
> In short, API V3 is able to report the _actual_ tuning parameters as used by
> the driver and corresponding to the actual broadcast steam. On the other hand,
> S2API reports cached values which were specified in the tuning operation and
> these values may be generic (*_AUTO symbols) or even wrong.

if that's still the case in Git (I didn't verify), then it should indeed
be changed to behave like v3 does. Would you mind to submit a patch, please?

> But there is worse. If I set a wrong parameter in the tuning operation,
> for instance guard interval 1/32, the API V3 returns the correct value
> which is actually used by the tuner (GUARD_INTERVAL_1_8), while S2API
> returns the "cached" value which was set while tuning (GUARD_INTERVAL_1_32).

That behaviour, however, is implementation specific and can't be relied
upon. In theory, the driver should always use the specified parameters,
unless set to *_AUTO. But there are cases like yours, where the driver
forces automatic detection of some parameters. This may or may not be
required by the underlying device.

Regards,
Andreas
