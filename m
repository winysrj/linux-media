Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx1.bredband2.com ([83.219.192.165])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <magnus@upcore.net>) id 1LcRm0-0002LW-PP
	for linux-dvb@linuxtv.org; Wed, 25 Feb 2009 22:58:37 +0100
Received: from yoshi.upcore.net (c-83-233-110-59.cust.bredband2.com
	[83.233.110.59])
	by mx1.bredband2.com (Postfix) with ESMTPA id F235936EF8
	for <linux-dvb@linuxtv.org>; Wed, 25 Feb 2009 22:57:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by yoshi.upcore.net (Postfix) with ESMTP id 93718C000109
	for <linux-dvb@linuxtv.org>; Wed, 25 Feb 2009 22:57:52 +0100 (CET)
Received: from yoshi.upcore.net ([127.0.0.1])
	by localhost (mail.upcore.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id cORIvsUdUp8O for <linux-dvb@linuxtv.org>;
	Wed, 25 Feb 2009 22:57:50 +0100 (CET)
Date: Wed, 25 Feb 2009 22:57:50 +0100
From: Magnus Nilsson <magnus@upcore.net>
To: linux-dvb@linuxtv.org
Message-ID: <20090225215749.GA4385@upcore.net>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Compiling mantis-5292a47772ad
Reply-To: linux-media@vger.kernel.org
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


Hello,

I'm trying to compile mantis-5292a47772ad under 2.6.28.7 (have tried
this under 2.6.28.5 and 2.6.24 (which I'm currently running) with same
results).

The error I'm getting is:

[root@mythbox /usr/local/src/mantis-5292a47772ad]# make all
*snip*
  CC [M]  /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.o
/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c: In function 'snd_card_saa7134_hw_params':
/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:496: error: implicit declaration of function 'snd_assert'
/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:497: error: expected expression before 'return'
/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:498: error: expected expression before 'return'
/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:499: error: expected expression before 'return'
/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c: In function 'snd_card_saa7134_new_mixer':
/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:950: error: expected expression before 'return'
make[3]: *** [/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.o] Error 1
make[2]: *** [_module_/usr/local/src/mantis-5292a47772ad/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.28.7'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/src/mantis-5292a47772ad/v4l'
make: *** [all] Error 2
*snip*

I'm not quite sure which version of the mantis driver I'm using now, but
it's at least from september 2008. I'm running this under Debian lenny,
with a VP-2040 and a Terratec Cinergy 1200C.

Thanks,
Magnus

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
