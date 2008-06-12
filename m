Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K6jjK-0004oK-16
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 12:08:30 +0200
Message-ID: <4850F597.9030603@iki.fi>
Date: Thu, 12 Jun 2008 13:08:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Websdale <websdaleandrew@googlemail.com>
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>	<4850566E.8030001@iki.fi>
	<e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
In-Reply-To: <e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andrew Websdale wrote:
> I've examined the logs, & I can find no mention of a Quantek tuner - 
> your suggestion of a non-working tuner seems likely, as tuning is what 
> doesn't seem to work when I run e.g. w_scan - can you make any 
> suggestion as to where I go from here? I'm more than willing to test new 
> code etc.
> regards Andrew

OK, then the reason might by tuner. Tuner may be changed to other one or 
tuner i2c-address is changed. I doubt whole tuner is changed. Now we 
should identify which tuner is used. There is some ways how to do that.

1) Look from Windows driver files
2) Open stick and look chips
3) Take USB-sniffs and try to identify tuner from there

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
