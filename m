Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KBQRw-0002kj-1Y
	for linux-dvb@linuxtv.org; Wed, 25 Jun 2008 10:33:56 +0200
Message-ID: <486202ED.9020601@iki.fi>
Date: Wed, 25 Jun 2008 11:33:49 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mailrobot <spam@mrplanlos.de>
References: <200806250929.28930.spam@mrplanlos.de>
In-Reply-To: <200806250929.28930.spam@mrplanlos.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fwd: Terratec Cinergy USB XE Rev.2
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

Mailrobot wrote:
> af9015: af9015_read_config: tuner id:133 not supported, please report!

It has Freescale MC44S803 tuner which is a little bit problematic due to 
missing GPL'd driver.
You an try:
http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025769.html
http://git.bocc.de/cgi-bin/gitweb.cgi?p=cinergy.git;a=summary

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
