Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate04.web.de ([217.72.192.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <SebastianMarskamp@web.de>) id 1KruBS-00029C-Cu
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 14:48:30 +0200
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id A9DB85F0D937
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 14:47:56 +0200 (CEST)
Date: Mon, 20 Oct 2008 14:47:44 +0200
Message-Id: <1546986099@web.de>
MIME-Version: 1.0
From: Sebastian Marskamp <SebastianMarskamp@web.de>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [ERROR] New Alsa misses snd_assert macro
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

When you try to build a driver for a dvb-t device which uses the  afatech 9=
015 chip, and maybe for others too  , you will get an error,cos  in alsa  1=
.0.18 , snd_assert macro is replaced by a snd_BUG_ON , which needs diffrent=
 paramters .


make[2]: Entering directory `/usr/src/linux-2.6.27-desktop586-0.rc8.2mnb'
CC [M] /home/dosenpfand/af9015/v4l/saa7134-alsa.o
/home/dosenpfand/af9015/v4l/saa7134-alsa.c: In function 'snd_card_saa7134_h=
w_params':
/home/dosenpfand/af9015/v4l/saa7134-alsa.c:496: error: implicit declaration=
 of function 'snd_assert'
/home/dosenpfand/af9015/v4l/saa7134-alsa.c:497: error: expected expression =
before 'return'
/home/dosenpfand/af9015/v4l/saa7134-alsa.c:498: error: expected expression =
before 'return'
/home/dosenpfand/af9015/v4l/saa7134-alsa.c:499: error: expected expression =
before 'return'
/home/dosenpfand/af9015/v4l/saa7134-alsa.c: In function 'snd_card_saa7134_n=
ew_mixer':
/home/dosenpfand/af9015/v4l/saa7134-alsa.c:950: error: expected expression =
before 'return'
make[3]: *** [/home/dosenpfand/af9015/v4l/saa7134-alsa.o] Error 1
make[2]: *** [_module_/home/dosenpfand/af9015/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.27-desktop586-0.rc8.2mnb'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/home/dosenpfand/af9015/v4l'
make: *** [all] Fehler 2 =

__________________________________________________________________________
Verschicken Sie SMS direkt vom Postfach aus - in alle deutschen und viele =

ausl=E4ndische Netze zum gleichen Preis! =

https://produkte.web.de/webde_sms/sms




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
