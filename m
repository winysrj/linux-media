Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K4cwa-000268-Pp
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 16:29:32 +0200
Message-ID: <484949C4.8000903@iki.fi>
Date: Fri, 06 Jun 2008 17:29:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Serge Nikitin <sergeniki@googlemail.com>
References: <71798b430806050447g1570a889ld2ad306a8b14b1f1@mail.gmail.com>	<484941CB.8060805@iki.fi>
	<9e5406cc0806060725m1224882bu6c18393e56f96596@mail.gmail.com>
In-Reply-To: <9e5406cc0806060725m1224882bu6c18393e56f96596@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PEAK DVB-T Digital Dual Tuner PCI - anyone got this
 card working?
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

Serge Nikitin wrote:
> I do have PEAK DVB-T Dual tuner PCI (221544AGPK) and it is reported in lsusb as: 
> 
> Bus 2 Device 2: ID 1b80:c160
> 
> Moreover, .ini file for win driver provided on CD listed this card as 
> KWorld PC160 (with USB IDs 1b80:c160 and 1b80:c161) and I've definitely 
> seen "PC160" printed on card's PCB.
> 
> In my case those PEAK and KWorld look like the same card.

Yeah, looks like. Thanks anyhow, I have now added this id to the driver.

Case clear and closed.

> Serge.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
