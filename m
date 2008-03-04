Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hal.hiof.no ([158.39.160.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andreas.bergstrom@hiof.no>) id 1JWTB4-0006u6-F2
	for linux-dvb@linuxtv.org; Tue, 04 Mar 2008 10:11:15 +0100
Received: from pc165-102.hiof.no (pc165-102.hiof.no [158.39.165.102])
	by hal.hiof.no (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id
	m249B0mZ028607
	for <linux-dvb@linuxtv.org>; Tue, 4 Mar 2008 10:11:00 +0100
Message-Id: <B41F75A9-4AC5-44B7-B02B-284EB8B3D377@hiof.no>
From: =?ISO-8859-1?Q?Andreas_Bergstr=F8m?= <andreas.bergstrom@hiof.no>
To: linux-dvb@linuxtv.org
In-Reply-To: <20080225182049.GJ21162@edu.joroinen.fi>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Tue, 4 Mar 2008 10:10:59 +0100
References: <20080223150126.GH21162@edu.joroinen.fi>
	<E1JSzEm-000AW0-00.goga777-bk-ru@f106.mail.ru>
	<20080225182049.GJ21162@edu.joroinen.fi>
Subject: Re: [linux-dvb] HVR4000 Update?
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


On 25. feb.. 2008, at 19:20, Pasi K=E4rkk=E4inen wrote:
> Some code/features missing? Or just more testing needed?
>
>>> - What needs to be done to get it merged?
>>
>> tests and reports to Manu :)

I have bought a second  WinTV-NOVA-HD-S2, (having discovered the first  =

ones problems were related to the cable / LNB and not the card), and  =

have tested multiproto with http://www.linuxtv.org/pipermail/linux-dvb/atta=
chments/20080128/adee4c88/attachment-0001.bin =

  against the http://dev.kewl.org/hauppauge/ drivers.

Using regular scan and the kewl.org HVR-4000 drivers, I find 322  =

services on Sirius, using Manu's scan for multiproto from http://jusst.de/m=
anu/scan.tar.bz2 =

, it finds 177 services, but most are just repeats of the first ten  =

results. (And I can't seem to get the DVB-S2 channels on Sirius  =

scanned just to check if reception works (even if they are encrypted).)

Tuning using the scan results from the kewl.org drivers and with szap2  =

work flawlessly with multiproto, but I have been unable to test it  =

against any DVB-S2 channels. But tuning to regular channels take 1 to  =

2 seconds tops.

Regards,

--
Andreas Bergstr=F8m
=D8stfold University College
Dept. of Computer Sciences
Tel: +47 69 21 53 71
http://media.hiof.no/






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
