Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]
	helo=spaceymail-a2.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lee.essen@nowonline.co.uk>) id 1JhNQF-0007Iw-Di
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 13:16:00 +0200
Received: from Cartman.owlsbarn.local (dsl-217-155-53-6.zen.co.uk
	[217.155.53.6])
	by spaceymail-a2.g.dreamhost.com (Postfix) with ESMTP id D124AEE3A8
	for <linux-dvb@linuxtv.org>; Thu,  3 Apr 2008 04:15:48 -0700 (PDT)
Message-Id: <F8D2B7C6-300A-4813-BA04-08C22306C678@nowonline.co.uk>
From: Lee Essen <lee.essen@nowonline.co.uk>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 3 Apr 2008 12:15:48 +0100
Subject: [linux-dvb] AF9015 - unknown tuner 30
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

Hi,

I've been experimenting with a very low-cost dual DVB-T tuner  =

(annoyingly I've thrown the packaging away now, but I think it was  =

branded as a Twinhan device, from Maplin (in the UK) on special at  =

only =A329 which interestingly doesn't appear on their web site  =

anymore), the device itself and the installation guide is completely  =

unbranded.

The product is described on the Twinhan site, although my one is white  =

with no markings, but otherwise the same. Interestingly this page  =

isn't linked from the menu on the left, so I'm not sure if this is  =

"new" or "discontinued" or what!!!    http://www.twinhan.com/product_AD-TU7=
00 =

.

It's USB id's are 13D3:3237 and manufacturer is shown as Afatech. The  =

windows driver .ini file suggests that the device is a UDTT704J. (704J  =

seems to match Twinhan's product details as well and is on the label  =

on the back of my device.)

 From digging around a bit (including some of the af9015 drivers on  =

this site) it looks like this is a af9015 based device and I can get  =

it to initialise (albeit with a number of errors), the most  =

interesting is the following:

[290181.920088] af9015_get_biu_config: Tuner type =3D 0x1E
[290181.920128] af9015_get_biu_config: Unknown tuner 30, please report

So hopefully this means something to you guys -- I have dismantled the  =

device and the IC's (do you still call them that? :-)) are covered by  =

a soldered on RF screen/heatsink ... I'm happy to remove this in the  =

name of science if needed.

I have had a dig around the provided Windows drivers with good old  =

'strings' and it looks like their driver supports the following  =

tuners: QT1010, MXL5003D, MXL5005D/R, TDA18271, MT2060 and (I'm  =

guessing) FS803a.

I'm very happy to help in whatever way I can with this as I'd love to  =

get this device working.

Thanks,

Lee.
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
