Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:58473 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab1ASSMN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 13:12:13 -0500
Message-ID: <4D372979.4050300@linuxtv.org>
Date: Wed, 19 Jan 2011 19:12:09 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Thierry LELEGARD <tlelegard@logiways.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [linux-media] API V3 vs SAPI behavior difference in reading
 tuning  parameters
References: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr> <AANLkTi=Y_ikxp2hHHh5B=rQqQLf5w5_5SivzLJ+DfVLm@mail.gmail.com> <4D307A80.4050807@linuxtv.org> <BA2A2355403563449C28518F517A3C4805AA9CE2@titan.logiways-france.fr> <BA2A2355403563449C28518F517A3C4805AAD036@titan.logiways-france.fr>
In-Reply-To: <BA2A2355403563449C28518F517A3C4805AAD036@titan.logiways-france.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/19/2011 06:03 PM, Thierry LELEGARD wrote:
> OK, then what? Is the S2API behavior (returning cached - but incorrect - tuning
> parameter values) satisfactory for everyone or shall we adapt S2API to mimic the
> API V3 behavior (return the actual tuning parameter values as automatically
> adjusted by the driver)?

To quote myself:

if that's still the case in Git (I didn't verify), then it should indeed
be changed to behave like v3 does. Would you mind to submit a patch, please?

I haven't heard any objections, so just go on if you want. Otherwise I
might prepare a patch once time permits.

Regards,
Andreas
