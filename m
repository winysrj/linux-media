Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ville.skytta@iki.fi>) id 1OKpvf-0000nC-Jf
	for linux-dvb@linuxtv.org; Sat, 05 Jun 2010 11:44:36 +0200
Received: from filtteri1.pp.htv.fi ([213.243.153.184])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OKpvf-00005Z-3i; Sat, 05 Jun 2010 11:44:35 +0200
Received: from localhost (localhost [127.0.0.1])
	by filtteri1.pp.htv.fi (Postfix) with ESMTP id 2DE5F18B3F4
	for <linux-dvb@linuxtv.org>; Sat,  5 Jun 2010 12:44:33 +0300 (EEST)
Received: from smtp6.welho.com ([213.243.153.40])
	by localhost (filtteri1.pp.htv.fi [213.243.153.184]) (amavisd-new,
	port 10024) with ESMTP id A4ms+yWIuoH5 for <linux-dvb@linuxtv.org>;
	Sat,  5 Jun 2010 12:44:24 +0300 (EEST)
Received: from viper.bobcat.mine.nu (cs181085020.pp.htv.fi [82.181.85.20])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp6.welho.com (Postfix) with ESMTPS id B7E665BC004
	for <linux-dvb@linuxtv.org>; Sat,  5 Jun 2010 12:44:24 +0300 (EEST)
From: Ville =?iso-8859-1?q?Skytt=E4?= <ville.skytta@iki.fi>
To: linux-dvb@linuxtv.org
Date: Sat, 5 Jun 2010 12:44:23 +0300
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3xhCMD4xb+3RpLL"
Message-Id: <201006051244.23796.ville.skytta@iki.fi>
Subject: [linux-dvb] [PATCH] Fix dvbnet -h crash when invoked without a path
	to dvbnet
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_3xhCMD4xb+3RpLL
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

The attached patch fixes a dvbnet -h crash when invoked without a path to 
dvbnet.

--Boundary-00=_3xhCMD4xb+3RpLL
Content-Type: text/x-patch;
  charset="UTF-8";
  name="dvb-apps-1.1.1-dvbnet-h-597604.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dvb-apps-1.1.1-dvbnet-h-597604.patch"

# HG changeset patch
# User Ville Skytt=C3=A4 <ville.skytta@iki.fi>
# Date 1275729484 -10800
# Node ID acb8124295190a9ee1de02a45ffdc6059eae0e63
# Parent  5631d8b9250c3c9e6f35542851e3fe0460f0315e
=46ix dvbnet -h crash when invoked without a path to dvbnet.

diff -r 5631d8b9250c -r acb812429519 util/dvbnet/dvbnet.c
=2D-- a/util/dvbnet/dvbnet.c	Tue Jun 01 16:25:03 2010 +0200
+++ b/util/dvbnet/dvbnet.c	Sat Jun 05 12:18:04 2010 +0300
@@ -178,8 +178,8 @@
 			exit(OK);
 		case 'h':
 		default:
=2D			s =3D strrchr(argv[0], '/') + 1;
=2D			usage((s) ? s : argv[0]);
+			s =3D strrchr(argv[0], '/');
+			usage((s) ? s + 1 : argv[0]);
 			exit(FAIL);
 		}
 	}

--Boundary-00=_3xhCMD4xb+3RpLL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_3xhCMD4xb+3RpLL--
