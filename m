Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CHqAal031565
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 13:52:10 -0400
Received: from ex.volia.net (ex.volia.net [82.144.192.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2CHpPA3007829
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 13:51:26 -0400
Message-ID: <003401c88469$af50f4d0$6401a8c0@LocalHost>
From: "itman" <itman@fm.com.ua>
To: "S G" <stive_z@hotmail.com>, "hermann pitton" <hermann-pitton@arcor.de>
References: <47D6F12C.7040102@fm.com.ua>
	<1205269761.5927.77.camel@pc08.localdom.local>
	<BAY107-W53381D746959C109E3EF0097080@phx.gbl>
Date: Wed, 12 Mar 2008 19:51:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: simon@kalmarkaglan.se, video4linux-list@redhat.com, xyzzy@speakeasy.org,
	midimaker@yandex.ru, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: RE: Re: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status
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

Hi, Steve.


Unfortunately by default initialization for this tuner it does not go in =
right way.=20
So I use this sequence  (see full list of commands) to make it work:



rmmod cx88_alsa=20
rmmod cx8800
rmmod cx88xx=20
rmmod tuner
rmmod tda9887=20
modprobe cx88xx=20
modprobe tda9887 port1=3D0 port2=3D0 qss=3D1=20
modprobe tuner=20
modprobe cx8800


Actually I do not dig deeply with this, but main goal of this is to =
initiate device with port1=3D0 port2=3D0 qss=3D1 option to get sound.
Also v4l devices appears in /dev after cx8800 initialization (could be =
mistaken, because I am writing this by memory ;-) and, lol, from Windows =
PC).

Pls also see Hermann explanation.



Rgs,
    Serge.






----- Original Message -----=20
  From: S G=20
  To: hermann pitton ; itman=20
  Cc: simon@kalmarkaglan.se ; video4linux-list@redhat.com ; Mauro =
Carvalho Chehab ; midimaker@yandex.ru ; xyzzy@speakeasy.org=20
  Sent: Wednesday, March 12, 2008 10:16 AM
  Subject: RE: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status


  Hi,

  I do have a MSI TV Anywhere Master (MSI 8606, cx88) and analog tv =
cable.

  I have a fresh Ubuntu Hardy install, up to date. Kernel =
2.6.24-12-generic

  I did :

  mkdir /usr/src/linux/tmpmsi
  cd tmpmsi
  hg init
  hg pull http://linuxtv.org/hg/v4l-dvb
  make
  make install

  Created a file in /etc/modprobe.d/ and added this line :

  options tda9887 port1=3D0 port2=3D0 qss=3D1

  I still have no sound (tv and radio).

  modinfo tda9887

  filename:       =
/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/tda9887.ko
  license:        GPL
  srcversion:     6E9F018870C816AFE420473
  depends:        i2c-core
  vermagic:       2.6.24-12-generic SMP mod_unload=20
  parm:           debug:enable verbose debug messages (int)
  parm:           port1:int
  parm:           port2:int
  parm:           qss:int
  parm:           adjust:int


  If you want me to try some settings, let me know since I have this =
card also...

  Thanks,

  Steve


  > From: hermann-pitton@arcor.de
  > To: itman@fm.com.ua
  > Date: Tue, 11 Mar 2008 22:09:21 +0100
  > CC: simon@kalmarkaglan.se; video4linux-list@redhat.com; =
mchehab@infradead.org; midimaker@yandex.ru; xyzzy@speakeasy.org
  > Subject: Re: Re: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 =
status
  >=20
  > Am Dienstag, den 11.03.2008, 22:53 +0200 schrieb itman:
  > > Hi Herman, Mauro.
  > >=20
  > > Status with 2.6.24 is OK, BUT with the following changes:
  > >=20
  > > 1) mkdir /usr/src/linux/tmpmsi
  > > 2) cd tmpmsi
  > > 3) hg init
  > > 4) hg pull http://linuxtv.org/hg/v4l-dvb
  > > 5) make
  > > 6) make install
  > >=20
  > > and changes for 2.6.24.3 :
  > >=20
  > > Adding to /etc/modprobe.conf this line:
  > >=20
  > > options tda9887 port1=3D0 port2=3D0 qss=3D1
  > >=20
  > > After reboot it works fine!
  > >=20
  > > In 2.6.23 was used tuner instead tda9887
  > > so it was
  > > options tuner port1=3D0 port2=3D0 qss=3D1
  > >=20
  > >=20
  > > Rgs,
  > > Serge.
  >=20
  > Hi Serge,
  >=20
  > fine, that was what I tried to explain.
  >=20
  > I have started to write a mail on it already, maybe it provides some
  > deeper insights and is useful for the records. So I send it despite =
off
  > you have realized the problem now.
  >=20
  > Thanks,
  > Hermann
  >=20
  >=20
  > --
  > video4linux-list mailing list
  > Unsubscribe =
mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
  > https://www.redhat.com/mailman/listinfo/video4linux-list


-------------------------------------------------------------------------=
-----
  Cr=E9ez un bouton pratique pour que vos amis vous ajoutent =E0 leur =
liste! Cliquez-ici!=20

  __________ =C8=ED=F4=EE=F0=EC=E0=F6=E8=FF NOD32 2762 (20080102) =
__________

  =DD=F2=EE =F1=EE=EE=E1=F9=E5=ED=E8=E5 =EF=F0=EE=E2=E5=F0=E5=ED=EE =
=C0=ED=F2=E8=E2=E8=F0=F3=F1=ED=EE=E9 =F1=E8=F1=F2=E5=EC=EE=E9 NOD32.
  http://www.eset.com
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
