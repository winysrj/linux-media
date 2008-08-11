Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KSbwb-0004sm-Gn
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 20:16:39 +0200
Received: from dyn3-82-128-188-116.psoas.suomi.net ([82.128.188.116])
	by mail.kapsi.fi with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50) id 1KSbwX-000558-Q3
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 21:16:33 +0300
Message-ID: <48A08201.6070505@iki.fi>
Date: Mon, 11 Aug 2008 21:16:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] DVB-C / DVB-T combo device multi mode driver
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

hello
I have a brand new Anysee E30 Combo Plus device. Device does have 
ZL10353 DVB-T demodulator and TDA10023 DVB-C demodulator sharing one 
Samsung tuner module. How I can handle this king of hardware? I see some 
  possibilities;
1) add module param for mode select
2) make driver register two adapters
3) use multiproto

I have already done first choice and it is working, but it is not very 
user friendly. I tried second one but didn't found way to lock tuner. 
Multiproto sounds like good decision but it is not ready yet. So what to 
do? Implement as 1) and wait for 3). Implementation of 2) is not 
possible without hacking current dvb-usb-framework?

Any ideas?

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
