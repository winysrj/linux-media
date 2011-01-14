Return-path: <mchehab@pedra>
Received: from poutre.nerim.net ([62.4.16.124]:60399 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab1ANQnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 11:43:49 -0500
From: Thierry LELEGARD <tlelegard@logiways.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: RE: [linux-media] API V3 vs SAPI behavior difference in reading
 tuning  parameters
Date: Fri, 14 Jan 2011 16:43:45 +0000
Message-ID: <BA2A2355403563449C28518F517A3C4805AA9CE2@titan.logiways-france.fr>
References: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr>
 <AANLkTi=Y_ikxp2hHHh5B=rQqQLf5w5_5SivzLJ+DfVLm@mail.gmail.com>
 <4D307A80.4050807@linuxtv.org>
In-Reply-To: <4D307A80.4050807@linuxtv.org>
Content-Language: fr-FR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Andreas Oberritter [mailto:obi@linuxtv.org]
> Sent: Friday, January 14, 2011 5:32 PM


> Albeit, DVB-SI data isn't perfect and misconfiguration at the
> transmitter happens (e.g. wrong FEC values), especially where most of
> the parameters are signaled in-band (e.g. TPS for DVB-T). It's a better
> user experience if the reception continues to work, even if the user
> didn't specify AUTO.

Exactly. In the French DVB-T network, there is no regional NIT, only one
common national NIT. As a consequence, all tuning parameters (frequency
but also FEC, guard interval, etc) are wrong in the terrestrial delivery
descriptors because for a given TS they are obviously not identical on all
transmitters. Moreover, these parameters change over time (many transmitters
recently moved from 2/3 - 1/32 to 3/4 - 1/8).

In such networks, nobody "knows" for sure the modulation parameters. This is
why it is a good thing that the tuners can 1) find the actual parameters and
2) report them to the application whenever it requests them.

> I'd rather understand non-AUTO parameters that way: "Try these first,
> but if you want and if you can, you're free to try other parameters."

Exactly, for the same reasons as above.

This is why the new behavior of S2API (compared to API V3) is quite unfortunate.
On a pragmatic standpoint, this is really a major step backward.

-Thierry

