Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from karen.lavabit.com ([72.249.41.33])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robkate@nerdshack.com>) id 1Jojz3-0000EG-Bc
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 20:46:28 +0200
Received: from b.earth.lavabit.com (b.earth.lavabit.com [192.168.111.11])
	by karen.lavabit.com (Postfix) with ESMTP id AADEEC86A2
	for <linux-dvb@linuxtv.org>; Wed, 23 Apr 2008 13:46:11 -0500 (CDT)
Received: from 192.168.0.4 (host86-169-176-16.range86-169.btcentralplus.com
	[86.169.176.16]) by nerdshack.com with ESMTP id K1LMKJ2JIQPA
	for <linux-dvb@linuxtv.org>; Wed, 23 Apr 2008 13:45:27 -0500
Message-ID: <480F83F6.6000409@nerdshack.com>
Date: Wed, 23 Apr 2008 19:46:14 +0100
From: Rob & Kate <RobKate@nerdshack.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Avermedia M103 TV Card
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

Hi,

I'm still trying to get my avermedia M103 TV card working.

I have a Philips-Freevents LX3000 PC, on which I=92m running PCLInuxOS, =

kernel 2.6.22.17.tex3 , this has an Avermedia m103 card installed (it=92s =

a mini PCI card). The chips used in the card are the same as those used =

in the E506,
U5
Philips
SAA7135HL/203
CE9498 04
TSG05422

U4
Zarlink
MT352 CG
0537A WS

U2
XCEIVE
XC3018ACQ (cache)
0536ATW
K42996 2

and very similar to those used in the A16D, however following the =

instructions on mcentral.de I seem unable to get TV in XAWTV, TVTime or =

Kaffine.

The following site has managed to get this card working with the =

experimental code

http://plone.lucidsolutions.co.nz/dvb/t/compiling-mcentral-experimental-v4l=
-dvb-drivers =



Can you please offer some advice, a couple of things that I think may be =

the problem are

o Do I need to remove the card before I install the experimental code? =

until now I haven=92t because its under the fan, but will if needs must.

o Do I need to disable the installed V4L modules in the kernel, and then =

re-compile the kernel? This seems very scary, but someone on the gentoo =

pages did it this way, so I=92ll give it ago if necessary

o How do I get the xc3028 to work, there seems to be 3 different =

approaches, either download the windows firmware and convert, download =

the picnnicale firmware =

(http://mcentral.de/firmware/firmware_pinnacle.tgz), or download the =

xc3028 firmware (http://mcentral.de/firmware/firmware_v5.tgz) .


Thanks in advance for any help, this is much appreciated, & will =

hopefully mean I can stop using Vista.

Regards

Rob


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
