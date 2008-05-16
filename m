Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway06.websitewelcome.com ([67.18.15.14])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1Jwu5A-0004Pn-9x
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 09:10:24 +0200
Message-ID: <482D3359.2020506@kipdola.com>
Date: Fri, 16 May 2008 09:10:17 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Jens_Krehbiel-Gr=E4ther?=
	<linux-dvb@okg-computer.de>, LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
References: <482D1AB7.3070101@kipdola.com>	<E1Jwsxt-000E0b-00.goga777-bk-ru@f151.mail.ru>
	<482D2A0E.1030307@okg-computer.de>
In-Reply-To: <482D2A0E.1030307@okg-computer.de>
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
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

Jens Krehbiel-Gr=E4ther schreef:
> I postet a patch a few weeks ago (here again).
> These szap and scan patches prepare the apps for actual multiproto =

> (well for multiproto a few weeks ago, if the api hasn't changed again, =

> these should work).
>
> you have to patch the szap and scan from this sources:
>
> http://abraham.manu.googlepages.com/szap.c
> http://abraham.manu.googlepages.com/szap.c
I fear things have changed too much for the patches to work. (Or I'm =

messing up a simple command like patch)

Szap: (Using the other szap.c file I can actually apply the patch, but =

the new szap.c seems to be incompatible)
# wget http://abraham.manu.googlepages.com/szap.c
# sudo mv szap.c.1 szap.c
# patch < szap-multiproto-apiv33.diff
patching file szap.c
# make
CC lnb.o
CC azap
CC czap
CC szap
szap.c: In function =91do_tune=92:
szap.c:243: error: storage size of =91fe_params=92 isn=92t known
szap.c:282: error: =91DVBFE_SET_PARAMS=92 undeclared (first use in this =

function)
szap.c:282: error: (Each undeclared identifier is reported only once
szap.c:282: error: for each function it appears in.)
szap.c:243: warning: unused variable =91fe_params=92
szap.c: In function =91zap_to=92:
szap.c:353: error: storage size of =91fe_info=92 isn=92t known
szap.c:354: error: storage size of =91delivery=92 isn=92t known
szap.c:369: error: =91DVBFE_DELSYS_DVBS=92 undeclared (first use in this =

function)
szap.c:373: error: =91DVBFE_DELSYS_DSS=92 undeclared (first use in this =

function)
szap.c:377: error: =91DVBFE_DELSYS_DVBS2=92 undeclared (first use in this =

function)
szap.c:395: error: =91DVBFE_SET_DELSYS=92 undeclared (first use in this =

function)
szap.c:397: error: =91DVBFE_GET_INFO=92 undeclared (first use in this funct=
ion)
szap.c:354: warning: unused variable =91delivery=92
szap.c:353: warning: unused variable =91fe_info=92
make: *** [szap] Error 1

Scan: (I'm using the original file, since I can't find another version =

on Manu's googlepages)
# patch -i scan-multiproto-3.3.patch

patching file scan.c
Hunk #1 FAILED at 1674.
Hunk #2 FAILED at 1693.
Hunk #3 FAILED at 1704.
3 out of 3 hunks FAILED -- saving rejects to file scan.c.rej

Thank you for your time

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
