Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41051 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750729AbdKYSJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 13:09:39 -0500
Date: Sat, 25 Nov 2017 16:09:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Reynaldo H. Verdejo Pinochet" <r.verdejo@samsung.com>
Subject: Re: dvbv5-scan: Channel auto detection fails
Message-ID: <20171125160933.685063ee@vento.lan>
In-Reply-To: <cbd47f94-7852-63e5-a449-265d75aa7e35@googlemail.com>
References: <cbd47f94-7852-63e5-a449-265d75aa7e35@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Nov 2017 18:50:28 +0100
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> I found the culprit why dvbv5-scan only find some of the channels in my
> DVB-T2 region: Some broadcasted NIT tables announce the 578MHz channel
> transmission mode as 16k where it should be 32k.

Ah! Yeah, it is hard for it to work properly when the MPEG tables
are wrong :-)

> The tables at 578MHz
> look ok, but that does not help with discovery.
> 
> Long story:
> 
> I have the following initial scan file:
> 
> T2 538000000 8MHz AUTO NONE     AUTO  32k 1/16 NONE
> T2 642000000 8MHz AUTO NONE     AUTO  32k 1/16 NONE 1
> T2 618000000 8MHz AUTO NONE     AUTO  32k 19/256 NONE
> T2 754000000 8MHz AUTO NONE     AUTO  16k 19/128 NONE
> T2 578000000 8MHz AUTO NONE     AUTO  32k 19/256 NONE
> 
> The last line was added manually because even w_scan gets confused.
> 
> > Scanning frequency #1 538000000
> > Lock   (0x1f) C/N= 21.50dB UCB= 3790 postBER= 166x10^-3
> > Service SAT.1 HD, provider ProSiebenSat.1 Media: reserved
> > Service ProSieben HD, provider ProSiebenSat.1 Media: reserved
> > Service kabel eins HD, provider ProSiebenSat.1 Media: reserved
> > Service SIXX HD, provider ProSiebenSat.1 Media: reserved
> > Service Pro7 MAXX HD, provider ProSiebenSat.1 Media: reserved
> > Service SAT.1 Gold HD, provider ProSiebenSat.1 Media: reserved
> > Service Sport1 HD, provider ProSiebenSat.1 Media: reserved
> > New transponder/channel found: #6: 578000000
> > New transponder/channel found: #7: 522000000
> > New transponder/channel found: #8: 658000000
> > New transponder/channel found: #9: 626000000
> > New transponder/channel found: #10: 602000000
> > New transponder/channel found: #11: 586000000
> > New transponder/channel found: #12: 698000000
> > New transponder/channel found: #13: 554000000
> > New transponder/channel found: #14: 498000000
> > New transponder/channel found: #15: 650000000
> > New transponder/channel found: #16: 738000000
> > New transponder/channel found: #17: 690000000
> > New transponder/channel found: #18: 594000000
> > New transponder/channel found: #19: 778000000
> > New transponder/channel found: #20: 666000000
> > New transponder/channel found: #21: 498000000
> > Scanning frequency #2 642000000  
> 
> Scanning #5 (from manually added table works):
> 
> > Scanning frequency #5 578000000
> > FREQUENCY = 578000000
> > MODULATION = QAM/AUTO
> > BANDWIDTH_HZ = 8000000
> > INVERSION = AUTO
> > CODE_RATE_HP = AUTO
> > CODE_RATE_LP = NONE
> > GUARD_INTERVAL = 19/256
> > TRANSMISSION_MODE = 32K
> > HIERARCHY = NONE
> > STREAM_ID = 4294967295
> > DELIVERY_SYSTEM = DVBT2
> > Carrier(0x03) Signal= -54.00dBm
> > Got parameters for DVBT2:
> > FREQUENCY = 578000000
> > MODULATION = QAM/AUTO
> > BANDWIDTH_HZ = 8000000
> > INVERSION = AUTO
> > CODE_RATE_HP = AUTO
> > CODE_RATE_LP = AUTO
> > GUARD_INTERVAL = 19/256
> > TRANSMISSION_MODE = 32K
> > HIERARCHY = NONE
> > STREAM_ID = 4294967295  
> 
> Scanning #6 (detected at #1) fails:
> 
> > Scanning frequency #6 578000000
> > FREQUENCY = 578000000
> > MODULATION = QAM/AUTO
> > BANDWIDTH_HZ = 8000000
> > INVERSION = AUTO
> > CODE_RATE_HP = AUTO
> > CODE_RATE_LP = NONE
> > GUARD_INTERVAL = 19/128
> > TRANSMISSION_MODE = 16K
> > HIERARCHY = NONE
> > STREAM_ID = 1
> > DELIVERY_SYSTEM = DVBT2
> > Carrier(0x03) Signal= -47.00dBm  
> 
> Is there anything that could / should be done at dvbv5-scan side? Maybe
> re-trying a frequency with different parameters if tuning failed?

Well, deep scan software (like w_scan) can read the device's 
capabilities and, for all parameters that aren't auto-detected, try
all possible combinations when a channel is not found.

The problem is that, while a normal channel scan lasts a couple of
minutes, a deep scan can take several hours.

There is one additional issue: we didn't add all possible
capabilities that are present on modern DTV standards. The
rationale is simple: we would need additional bits, as we're almost
out of capabilities bits with the current API.

So, a complete solution would very likely require DVB core, DVB
driver and libv4l5 changes.

-- 
Thanks,
Mauro
