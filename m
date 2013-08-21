Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <ludwig@salviamo-il-consolato.de>) id 1VCFlt-0006WE-1T
	for linux-dvb@linuxtv.org; Wed, 21 Aug 2013 23:16:53 +0200
Received: from mail.antar.de ([212.60.251.59])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-6) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1VCFlr-0000RQ-5r; Wed, 21 Aug 2013 23:16:52 +0200
Received: from e182112044.adsl.alicedsl.de ([85.182.112.44]
	helo=[192.168.1.164])
	by mail.antar.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72) (envelope-from <ludwig@salviamo-il-consolato.de>)
	id 1VCFlq-0002iY-Kn
	for linux-dvb@linuxtv.org; Wed, 21 Aug 2013 23:16:50 +0200
Message-ID: <52152E95.6080601@salviamo-il-consolato.de>
Date: Wed, 21 Aug 2013 23:18:13 +0200
From: Ludwig Meyerhoff <ludwig@salviamo-il-consolato.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] FM radio with RTL8232u
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hallo!

Probably, this is not the right place to ask, but maybe this is a point 
where to start. I have spent this evening in making some internet 
research and did not find exhaustive information.

I wanted to play around with FM radio tuners, contiously scan for radio 
stations, check the SNR ...
The easiest way to get such a tuner was to buy a DVB-T stick which is 
advertised to support DVB-T, DAB/DAB+ and FM.
So, today I bought a "TerraTec Cinergy T Stick+" which runs a rtl8232 
chipset.

After about one hour of research, I finally got DVB-T to run and was 
able to watch the TV programme. Basically, the hardware works.
The remaining evening I tried to figure out how to get FM radio to work 
with that USB stick.


It looks like if the rtl8232 driver does not support v4l/radio. If I 
wanted to use this, I should either use some SDR o make some extensions 
to the existing driver.


What I wanted to know: is the rtl8232 driver limited to the DVB-T use 
only? Should I use SDR for listening to FM music?



Saluti!

Ludwig

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
