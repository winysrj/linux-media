Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42CG1Ou022356
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:16:01 -0400
Received: from bay0-omc1-s38.bay0.hotmail.com (bay0-omc1-s38.bay0.hotmail.com
	[65.54.246.110])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42CFig0025687
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:15:44 -0400
Message-ID: <BAY109-W3800F2CA38902019DCBA2FCBDA0@phx.gbl>
From: =?Windows-1252?Q?Vicent_Jord=E0?= <vjorda@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Fri, 2 May 2008 12:15:38 +0000
In-Reply-To: <BAY109-W348B1C456A85D25DD8FC24CBD90@phx.gbl>
References: <BAY109-W5337BE0CEB1701C6AC945ACBDE0@phx.gbl>
	<20080428114741.040ccfd6@gaivota>
	<BAY109-W55EF752D25B0EAF1361C40CBDE0@phx.gbl>
	<Pine.LNX.4.64.0804290444440.22785@bombadil.infradead.org>
	<BAY109-W348B1C456A85D25DD8FC24CBD90@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Subject: FW: Trying to set up a NPG Real DVB-T PCI Card
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

Sorry, I resend this message because I've received response.=20
> From: vjorda@hotmail.com> To: video4linux-list@redhat.com> Date: Tue, 29 =
Apr 2008 11:25:46 +0000> Subject: RE: Trying to set up a NPG Real DVB-T PCI=
 Card> > > I'm not sure that I have understoo your instructions.> > I've ma=
de three state dumps.> > 1) When The TV Program isn't running.> 2) When I t=
urned on the TV Program> 3) When I selected a channel.> > I cannot change t=
o NTSC.> > I hope this may help us!> > Thanks> Vicent> > CX2388x Card [0]:>=
 > Vendor ID: 0x14f1> Device ID: 0x8800> Subsystem ID: 0x885214f1> > > 4 st=
ates dumped> > ------------------------------------------------------------=
----------------------> > CX2388x Card - State 0:> MO_GP0_IO: 000000ff * (0=
0000000 00000000 00000000 11111111) > MO_GP1_IO: 0000e09f * (00000000 00000=
000 11100000 10011111) > MO_GP2_IO: 000000ff * (00000000 00000000 00000000 =
11111111) > MO_GP3_IO: 00000000 (00000000 00000000 00000000 00000000) > > >=
 Changes: State 0 -> State 1:> AUD_STATUS: 000002ba -> 000001f6 (-------- -=
------- ------10 -0--10--) > AUD_NICAM_STATUS1: 000067bc -> 0000ef4d (-----=
--- -------- 0---0--- 1011---0) > MO_GP0_IO: 000000ff -> 000004fb (--------=
 -------- -----0-- -----1--) > MO_GP1_IO: 0000e09f -> 0000f39e (-------- --=
------ ---0--00 -------1) > MO_GP2_IO: 000000ff -> 000000a9 (-------- -----=
--- -------- -1-1-11-) > > 5 changes> > > ---------------------------------=
-------------------------------------------------> > CX2388x Card - State 1=
:> MO_GP0_IO: 000004fb (00000000 00000000 00000100 11111011) (was: 000000ff=
)> MO_GP1_IO: 0000f39e (00000000 00000000 11110011 10011110) (was: 0000e09f=
)> MO_GP2_IO: 000000a9 * (00000000 00000000 00000000 10101001) (was: 000000=
ff)> MO_GP3_IO: 00000000 (00000000 00000000 00000000 00000000) > > > Change=
s: State 1 -> State 2:> AUD_STATUS: 000001f6 -> 000000f2 (-------- --------=
 -------1 -----1--) > AUD_NICAM_STATUS1: 0000ef4d -> 0000cc9e (-------- ---=
----- --1---11 01-0--01) > MO_GP2_IO: 000000a9 -> 00000089 (-------- ------=
-- -------- --1-----) > > 3 changes> > > ----------------------------------=
------------------------------------------------> > CX2388x Card - State 2:=
> MO_GP0_IO: 000004fb (00000000 00000000 00000100 11111011) > MO_GP1_IO: 00=
00f39e (00000000 00000000 11110011 10011110) > MO_GP2_IO: 00000089 * (00000=
000 00000000 00000000 10001001) (was: 000000a9)> MO_GP3_IO: 00000000 (00000=
000 00000000 00000000 00000000) > > > Changes: State 2 -> Register Dump:> A=
UD_NICAM_STATUS2: 00000005 -> 00000009 (-------- -------- -------- ----01--=
) > AUD_STATUS: 000000f2 -> 0000fb76 (-------- -------- 00000-00 1----0--) =
> AUD_NICAM_STATUS1: 0000cc9e -> 00009f83 (-------- -------- -1-0--00 ---11=
1-0) > MO_GP2_IO: 00000089 -> 000000c9 (-------- -------- -------- -0------=
) > > 4 changes> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> > CX2388x Card - Register Dump:> M=
O_GP0_IO: 000004fb (00000000 00000000 00000100 11111011) > MO_GP1_IO: 0000f=
39e (00000000 00000000 11110011 10011110) > MO_GP2_IO: 000000c9 (00000000 0=
0000000 00000000 11001001) (was: 00000089)> MO_GP3_IO: 00000000 (00000000 0=
0000000 00000000 00000000) > > end of dump> > > > > > Date: Tue, 29 Apr 200=
8 04:54:57 -0400> > From: mchehab@infradead.org> > To: vjorda@hotmail.com> =
> CC: video4linux-list@redhat.com> > Subject: RE: Trying to set up a NPG Re=
al DVB-T PCI Card> >> > This is what we need:> >> >> MO_GP0_IO: 000004fb (0=
0000000 00000000 00000100 11111011)> >> MO_GP1_IO: 000000ff (00000000 00000=
000 00000000 11111111)> >> MO_GP2_IO: 00000001 (00000000 00000000 00000000 =
00000001)> >> MO_GP3_IO: 00000000 (00000000 00000000 00000000 00000000)> >>=
 > Those GPIO registers controls external devices. you'll need to start> > =
regedit before your video app. There's a mode at regspy that tracks> > chan=
ges on register. After starting, you'll have those values changed.> >> > Th=
e firmware load happens when you change from PAL to NTSC. You may try to> >=
 do this on your software and see what register will change.> >> > For exam=
ple, let's say that GPIO2 has xc3028 reset pin at bit 1. You'll> > notice s=
omething like this, during reset:> >> >> MO_GP2_IO: 00000001 (00000000 0000=
0000 00000000 00000001)> >> MO_GP2_IO: 00000003 (00000000 00000000 00000000=
 00000011)> >> MO_GP2_IO: 00000001 (00000000 00000000 00000000 00000001)> >=
> > Cheers,> > Mauro.> > __________________________________________________=
_______________> Tecnolog=EDa, moda, motor, viajes,=85suscr=EDbete a nuestr=
os boletines para estar siempre a la =FAltima> Guapos y guapas, clips music=
ales y estrenos de cine. > > --> video4linux-list mailing list> Unsubscribe=
 mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe> https://=
www.redhat.com/mailman/listinfo/video4linux-list
_________________________________________________________________
MSN Video.=20
http://video.msn.com/?mkt=3Des-es=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
