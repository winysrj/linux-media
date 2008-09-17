Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n4.bullet.ukl.yahoo.com ([217.146.182.181])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dirk_vornheder@yahoo.de>) id 1Kg2VH-0005dd-LO
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 21:15:57 +0200
From: Dirk Vornheder <dirk_vornheder@yahoo.de>
To: Antti Palosaari <crope@iki.fi>,
 linux-dvb@linuxtv.org
Date: Wed, 17 Sep 2008 21:15:19 +0200
References: <200809152345.37786.dirk_vornheder@yahoo.de>
	<48CF85C2.1030806@iki.fi> (sfid-20080916_200620_773173_78C7D8C0)
In-Reply-To: <48CF85C2.1030806@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809172115.19851.dirk_vornheder@yahoo.de>
Subject: Re: [linux-dvb] UNS: Re:  New unspported device AVerMedia DVB-T
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Compile produces undefined symbol:

  Building modules, stage 2.
  MODPOST 166 modules
WARNING: "__udivdi3" [/backup/privat/kernel/af9015_test-
c8583d119095/v4l/af9013.ko] undefined!
  CC      /backup/privat/kernel/af9015_test-c8583d119095/v4l/af9013.mod.o
  LD [M]  /backup/privat/kernel/af9015_test-c8583d119095/v4l/af9013.ko
  CC      /backup/privat/kernel/af9015_test-c8583d119095/v4l/au8522.mod.o
  LD [M]  /backup/privat/kernel/af9015_test-c8583d119095/v4l/au8522.ko


> > Hi !
> >
> > I buy a new notebook HP Pavilion dv7-1070eg which includes one
> >
> > AVerMedia DVB-T-Device.
>
> It is Afatech AF9015 based device. Please test driver from:
> http://linuxtv.org/hg/~anttip/af9015_test
> and firmware from:
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_=
fi
>les/4.95.0/
>
> regards
> Antti


	=

		=

___________________________________________________________ =

Der fr=FChe Vogel f=E4ngt den Wurm. Hier gelangen Sie zum neuen Yahoo! Mail=
: http://mail.yahoo.de


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
