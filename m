Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <bistory@gmail.com>) id 1X044K-0001LV-4Y
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2014 09:26:05 +0200
Received: from mail-wg0-f42.google.com ([74.125.82.42])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-5) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1X044H-0005no-9D; Thu, 26 Jun 2014 09:26:03 +0200
Received: by mail-wg0-f42.google.com with SMTP id z12so3119571wgg.13
	for <linux-dvb@linuxtv.org>; Thu, 26 Jun 2014 00:26:01 -0700 (PDT)
Received: from [192.168.1.100] ([109.89.128.81])
	by mx.google.com with ESMTPSA id fq2sm21287418wib.2.2014.06.26.00.26.00
	for <linux-dvb@linuxtv.org>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Thu, 26 Jun 2014 00:26:00 -0700 (PDT)
From: =?windows-1252?Q?Thomas_L=E9t=E9?= <bistory@gmail.com>
Message-Id: <9FC53147-8519-4BFC-9E42-D449B057C0E3@gmail.com>
Date: Thu, 26 Jun 2014 09:25:59 +0200
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: [linux-dvb] Terratec Cinergy C support
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi everyone !
I just discovered that Terratec made an other revision of their Cinergy C P=
CI card (it is a DVB-C lci card). I tried to install it on a debian system =
with the kernel 3.2.0 and with back port 3.14 without success, I have no de=
vice in /dev/dvb.
The wiki page ( http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DV=
B-C ) shows a card with a black PCB but mine has a white one. The weird thi=
ng is that the box says it supports HDTV so I guess I own a HD version even=
 it is not mentioned on the product name.

lspci -vnn shows that :

04:00.0 Multimedia controller [0480]: InfiniCon Systems Inc. Device [1820:4=
e35] (rev 01)
	Subsystem: ATELIER INFORMATIQUES et ELECTRONIQUE ETUDES S.A. Device [1539:=
1178]
	Flags: bus master, medium devsel, latency 32, IRQ 8
	Memory at 90100000 (32-bit, prefetchable) [disabled] [size=3D4K]

I found no information on this hardware yet=85

I=92m currently building latest sources but I don=92t think it will help so=
 much.

Do you have any clue that could lead supporting this device on linux ?

Thanks !
_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
