Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <eddie500@bigpond.com>) id 1QW5qv-0007po-BG
	for linux-dvb@linuxtv.org; Mon, 13 Jun 2011 14:03:09 +0200
Received: from nskntmtas03p.mx.bigpond.com ([61.9.168.143])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1QW5qu-00000u-Iw; Mon, 13 Jun 2011 14:02:45 +0200
Received: from nskntotgx02p.mx.bigpond.com ([58.164.224.34])
	by nskntmtas03p.mx.bigpond.com with ESMTP id
	<20110613120239.ZIJC2063.nskntmtas03p.mx.bigpond.com@nskntotgx02p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Mon, 13 Jun 2011 12:02:39 +0000
Received: from [10.0.0.5] (really [58.164.224.34])
	by nskntotgx02p.mx.bigpond.com with ESMTP
	id <20110613120239.GRMQ29310.nskntotgx02p.mx.bigpond.com@[10.0.0.5]>
	for <linux-dvb@linuxtv.org>; Mon, 13 Jun 2011 12:02:39 +0000
Message-ID: <4DF5FC5E.7020201@bigpond.com>
Date: Mon, 13 Jun 2011 20:02:38 +0800
From: "E.John Brown" <eddie500@bigpond.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Avermedia Aver3D CaptureHD Hybrid (H727)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0028341181=="
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0028341181==
Content-Type: multipart/alternative;
 boundary="------------050102000603050007010600"

This is a multi-part message in MIME format.
--------------050102000603050007010600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Does anyone know, if any work  has been started on a driver for this card ?

It does not have a driver in the latest kernel 2.6.38.8

lspci -k command output
01:05.0 Multimedia video controller: Internext Compression Inc iTVC16
(CX23416) MPEG-2 Encoder (rev 01)
         Subsystem: Hauppauge computer works Inc. WinTV PVR 150
         Kernel driver in use: ivtv
         Kernel modules: ivtv
01:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
         Subsystem: Twinhan Technology Co. Ltd Device 0014
         Kernel driver in use: Mantis
         Kernel modules: mantis
_02:00.0 Multimedia video controller: Device 1a0a:6200 (rev 01)
         Subsystem: Avermedia Technologies Inc Device 6205_



as we can see there is no kernel driver loaded for the Avermedia card

Yours Sincerely
John Brown


--------------050102000603050007010600
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body bgcolor="#ffffff" text="#000000">
    <pre>Does anyone know, if any work  has been started on a driver for this card ?

It does not have a driver in the latest kernel 2.6.38.8

lspci -k command output
01:05.0 Multimedia video controller: Internext Compression Inc iTVC16 
(CX23416) MPEG-2 Encoder (rev 01)
        Subsystem: Hauppauge computer works Inc. WinTV PVR 150
        Kernel driver in use: ivtv
        Kernel modules: ivtv
01:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Twinhan Technology Co. Ltd Device 0014
        Kernel driver in use: Mantis
        Kernel modules: mantis
<u>02:00.0 Multimedia video controller: Device 1a0a:6200 (rev 01)
        Subsystem: Avermedia Technologies Inc Device 6205</u>



as we can see there is no kernel driver loaded for the Avermedia card

Yours Sincerely
John Brown
</pre>
  </body>
</html>

--------------050102000603050007010600--


--===============0028341181==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0028341181==--
