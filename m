Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m48FdlRd014484
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 11:39:47 -0400
Received: from bay0-omc1-s13.bay0.hotmail.com (bay0-omc1-s13.bay0.hotmail.com
	[65.54.246.85])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m48FdYdp017478
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 11:39:35 -0400
Message-ID: <BAY109-W240853DDEBBA5891A3DD0ECBD00@phx.gbl>
From: =?iso-8859-1?Q?Vicent_Jord=E0?= <vjorda@hotmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 8 May 2008 15:39:29 +0000
In-Reply-To: <20080507155819.2df442b5@gaivota>
References: <BAY109-W5337BE0CEB1701C6AC945ACBDE0@phx.gbl>
	<20080428114741.040ccfd6@gaivota>
	<BAY109-W23742D6ECAA5EF9CDEF632CBDE0@phx.gbl>
	<20080507155819.2df442b5@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: RE: Trying to set up a NPG Real DVB-T PCI Card
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

Hi,
=20
I have sent in other message the output of regspy.exe.
=20
I hope you can help me to solve the problem.
=20
Thanks,
Vicent Jord=E0
=20



> Date: Wed, 7 May 2008 15:58:19 -0300> From: mchehab@infradead.org> To: vj=
orda@hotmail.com> CC: video4linux-list@redhat.com> Subject: Re: Trying to s=
et up a NPG Real DVB-T PCI Card> > On Mon, 28 Apr 2008 20:26:43 +0000> Vice=
nt Jord=E0 <vjorda@hotmail.com> wrote:> > > > > Hi,> > > > (2) tuner-callba=
ck is sending a wrong reset. Xc3028 needs to receive a reset, gia a GPIO pi=
n, for firmware to load. If you don't send a reset, firmware won't load; Th=
e better is to use regspy.exe (provided together with DCALER) and see what =
gpio changes during firmware load.> > > > But regspy.exe is a Windows progr=
am. I tried to run it from wine but doesn't work.> > True. This software he=
lps to identify what the windows proprietary driver is> doing at the device=
. I guess your device uses a different pin for XC3028 reset.> > > > Cheers,=
> Mauro
_________________________________________________________________
La vida de los famosos al desnudo en MSN Entretenimiento
http://entretenimiento.es.msn.com/=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
