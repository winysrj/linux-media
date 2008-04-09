Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <p.pettinato@gmail.com>) id 1Jjb0W-0001PD-DU
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 16:10:37 +0200
Received: by fg-out-1718.google.com with SMTP id 22so2238073fge.25
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 07:10:33 -0700 (PDT)
Message-ID: <79f9d6350804090710h240dd1den27985e8ad8bf042@mail.gmail.com>
Date: Wed, 9 Apr 2008 16:10:29 +0200
From: "Paolo Pettinato" <p.pettinato@gmail.com>
To: "Aidan Thornton" <makosoft@googlemail.com>, "Thomas Pinz" <dc2rpt@gmx.de>,
	albert.comerma@gmail.com
In-Reply-To: <c8b4dbe10804081402y71bb0de4q6ee3d928b8aaf1c9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <79f9d6350804081125h5a480222gd33c5b44a6630204@mail.gmail.com>
	<c8b4dbe10804081402y71bb0de4q6ee3d928b8aaf1c9@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with unsupported DVB-T usb stick (CE6230)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thank you very much,
I've opened my brand-new device with a pair of scissors and found that
inside there are the following components:
- intel WJCE6230
- maxlinear MXL5003S.

I've done also a bit of searching, and found this:
http://download.intel.com/design/celect/refdesign/31543301.pdf

It's a reference design for a PC-TV Usb "Stick". It's very similar to
what I saw when I opened mine.
On the second page it's possible to read:

Supported by:
=96 Data sheet and design manual for the
Intel CE 6230 DVB-T demodulator
=96 Bill of material, schematics and diagrams
=96 Full software GUI for operational performance
verifi cation testing
=96 Source-code driver software including BDA
MCE binary drivers (provided under license by
LN Systems UK Ltd.*)
=96 Performance test results including: NorDig
Unified 1.0.2, USB 2.0, ESD and EMC

AND my CE6230 driver (under windows) has two files which are not
digitally signed by Microsoft, and whose copyright is "LN Systems
Limited". I may be wrong, but I think that my device is provided with
Windows drivers which are very similar to the ones proposed by intel
on their reference design.

So, the matter would be getting this stuff from intel.

Paolo

2008/4/8 Aidan Thornton <makosoft@googlemail.com>:
>
> On Tue, Apr 8, 2008 at 7:25 PM, Paolo Pettinato <p.pettinato@gmail.com> w=
rote:
>  > Hi all,
>  >  I'm new to this mailing list so please excuse me if I do some mistakes
>  >  :) also I feel sorry for my English :)
>  >  I've recently bought a cheap DVB-T dongle on ebay. Works like a charm
>  >  on windows XP, but it seems that there's no support on linux (I've
>  >  done some searching).
>  >  The vendorid:productid codes are 8086:9500. On "Device Manager" it is
>  >  listed as "CE6230 Standalone Driver (BDA)". On its properties, it says
>  >  that it's manufactured by Realfine Ltd and is on Location 0
>  >  (CE9500B1).
>  >  Since I can't stand the fact that I can't use some hardware on linux,
>  >  I'm asking two questions:
>  >  1. Has any work be done to support this device (or similar ones, like
>  >  - I think - the "AVerMedia USB2.0 DVB-T A310")?
>  >  2. If so, how can I help further developing?
>  >
>  >  I'm a student in computer engineering, so I won't mind spending some
>  >  time on driver developing (though I have never done till now).
>  >  Paolo
>
>  Hi,
>
>  I'm not aware of any drivers for the CE6230 (in fact, this is the
>  first device I've heard of that uses it so far). Someone will have to
>  try and get the docs from Intel - I don't think these are exactly
>  simple devices. (They have a full programmable 8051 microprocessor
>  core on-chip in addition to stuff like a seperate hardware PID filter
>  and a fairly intelligent demodulator. OTOH, the demodulator is
>  probably based on one of the Zarlink designs, which makes life
>  slightly easier).
>
>
>  >  CE6230 is a demodulator of Intel
>  >  (http://www.intel.com/design/celect/demodulators/ce6230.htm) . Its se=
ems to
>  >  be a successor of the Zarlink MT352/MT353 (Intel bought Zarlink some =
time
>  >  ago).
>  >
>  >  So you should have a look on the 352/353 drivers, maybe there are some
>  >  parallels.
>
>  Yep - it's an integrated USB interface and demodulator on a chip. They
>  seem to be becoming more common these days, possibly due to potential
>  cost savings. Probably has more in common with the ZL10353/CE6353 and
>  company - the MT352/MT353 had been throughly obsoleted by them by the
>  time Intel bought out Zarlink, to the point that Intel didn't even
>  bother giving them new Intel part numbers.
>
>  Aidan
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
