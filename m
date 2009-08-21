Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7L90FMJ025280
	for <video4linux-list@redhat.com>; Fri, 21 Aug 2009 05:00:15 -0400
Received: from owa.mail24.ee (owa.mail24.ee [88.196.5.45])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7L900vo005423
	for <video4linux-list@redhat.com>; Fri, 21 Aug 2009 05:00:01 -0400
From: Avo Aasma <Avo.Aasma@webit.ee>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 21 Aug 2009 11:59:57 +0300
Message-ID: <CC0519432816B04CA17FCEC83F6D189061AF451633@ExchBE.Mail24.ee>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1257"
Content-Transfer-Encoding: quoted-printable
Subject: Error installing v4l driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

I=92m using Ubuntu Jaunty 9.04 with kernel 2.6.28-15-generic. I=92m using M=
ythTV with Hauppauge Nova-T 500 dual DVB card. After updating system with n=
ew linux-headres, I should reinstall v4l driver in order to get IR receiver=
 to work. I have made this several times when linux-headers are updated wit=
hout any problems.
For reinstall I have used:
hg pull
hg update
make clean
rm v4l/.version
make all
sudo make install

Now I get errors during command make all.
Error is listed below.

  CC [M]  /home/avo/v4l-dvb/v4l/stb6100.o
/home/avo/v4l-dvb/v4l/stb6100.c: In function 'stb6100_set_frequency':
/home/avo/v4l-dvb/v4l/stb6100.c:377: error: implicit declaration of functio=
n 'DIV_ROUND_CLOSEST'
make[3]: *** [/home/avo/v4l-dvb/v4l/stb6100.o] Error 1
make[2]: *** [_module_/home/avo/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/avo/v4l-dvb/v4l'
make: *** [all] Error 2

Can you help me to fix this problem?

Regards,

Avo Aasma, CISA
Webit O=DC<http://www.webit.ee/>
+372 50 34999
MSN: avo.aasma@intral.net<mailto:avo.aasma@intral.net>
Skype: avoaasma5272

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
