Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:39005 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944Ab1ANQcD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 11:32:03 -0500
Message-ID: <4D307A80.4050807@linuxtv.org>
Date: Fri, 14 Jan 2011 17:32:00 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Thierry LELEGARD <tlelegard@logiways.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [linux-media] API V3 vs SAPI behavior difference in reading tuning
 parameters
References: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr> <AANLkTi=Y_ikxp2hHHh5B=rQqQLf5w5_5SivzLJ+DfVLm@mail.gmail.com>
In-Reply-To: <AANLkTi=Y_ikxp2hHHh5B=rQqQLf5w5_5SivzLJ+DfVLm@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/14/2011 04:12 PM, Devin Heitmueller wrote:
> On Fri, Jan 14, 2011 at 8:35 AM, Thierry LELEGARD
> <tlelegard@logiways.com> wrote:
>> But there is worse. If I set a wrong parameter in the tuning operation,
>> for instance guard interval 1/32, the API V3 returns the correct value
>> which is actually used by the tuner (GUARD_INTERVAL_1_8), while S2API
>> returns the "cached" value which was set while tuning (GUARD_INTERVAL_1_32).
> 
> This is actually a bad thing.  If you specify the wrong parameter and
> it still works, then that can lead to all sort of misleading behavior.
>  For example, imagine the next person who submits scan results based
> on using such a driver.  It works for him because his driver lied, but
> the resulting file works for nobody else.

Scan results should contain the input parameters, because the
transmission parameters can change any time (not included in any
official frequency sheet of the provider) and because some parameters
vary slightly with environmental influences (e.g. DVB-S frequency - i've
heard of that a lot and there's code to handle it in dvb_frontend.c, but
is it actually true?) and some might be read back too imprecisely to be
usable with a different chipset (e.g. symbol rate).

> If you specify an explicit value incorrectly (not auto) and it still
> works, that is a driver bug which should be fixed.

It's not possible to manually specify every single parameter or every
combination of parameters (i.e. some AUTO, some not) with all devices.

If you want to catch this, you'd have to compare the data read back to
the data from userspace to clear the lock status on mismatch, even if a
valid TS is being received. This would be worse, in my opinion. How much
tolerance would you allow for parameters that aren't enums, e.g.
frequency and symbol rate?

Albeit, DVB-SI data isn't perfect and misconfiguration at the
transmitter happens (e.g. wrong FEC values), especially where most of
the parameters are signaled in-band (e.g. TPS for DVB-T). It's a better
user experience if the reception continues to work, even if the user
didn't specify AUTO.

I'd rather understand non-AUTO parameters that way: "Try these first,
but if you want and if you can, you're free to try other parameters."

After all, most of the users tune to a mux in order to acquire a lock
and not to prove that there's no signal.

Regards,
Andreas
