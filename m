Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ke2705@gmx.de>) id 1KWsxT-0008Ko-GD
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 15:15:12 +0200
Message-ID: <48B00D6C.8080302@gmx.de>
Date: Sat, 23 Aug 2008 15:15:24 +0200
From: Eberhard Kaltenhaeuser <ke2705@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Support of Nova S SE DVB card missing
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0551216524=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0551216524==
Content-Type: multipart/alternative;
 boundary="------------070004030101040705020702"

This is a multi-part message in MIME format.
--------------070004030101040705020702
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Actual kernel does not support the Hauppauge WinTV Nova S SE PCI card 
anymore:

Aug 10 16:00:43 linvdr user.info kernel: [   13.464026] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
Aug 10 16:00:43 linvdr user.warn kernel: [   13.472474] adapter has MAC addr = 00:d0:5c:23:72:54
Aug 10 16:00:43 linvdr user.warn kernel: [   13.590880] budget: A frontend driver was not found for device 1131/7146 subsystem 13c2/1016

Tested with kernel 2.6.25.11

Previous kernel versions (i.e. 2.6.20.1) did not show this problem:

Aug 10 16:14:12 linvdr user.info kernel: DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
Aug 10 16:14:12 linvdr user.warn kernel: adapter has MAC addr = 00:d0:5c:23:72:54
Aug 10 16:14:12 linvdr user.warn kernel: DVB: registering frontend 1 (Samsung S5H1420 DVB-S)...

Regards
-- 


--------------070004030101040705020702
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Times New Roman">Actual kernel does not support the
Hauppauge WinTV Nova S SE PCI card anymore:<br>
</font>
<pre>Aug 10 16:00:43 linvdr user.info kernel: [   13.464026] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
Aug 10 16:00:43 linvdr user.warn kernel: [   13.472474] adapter has MAC addr = 00:d0:5c:23:72:54
Aug 10 16:00:43 linvdr user.warn kernel: [   13.590880] budget: A frontend driver was not found for device 1131/7146 subsystem 13c2/1016</pre>
Tested with kernel 2.6.25.11<br>
<br>
Previous kernel versions (i.e. 2.6.20.1) did not show this problem:<br>
<pre>Aug 10 16:14:12 linvdr user.info kernel: DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
Aug 10 16:14:12 linvdr user.warn kernel: adapter has MAC addr = 00:d0:5c:23:72:54
Aug 10 16:14:12 linvdr user.warn kernel: DVB: registering frontend 1 (Samsung S5H1420 DVB-S)...</pre>
Regards<br>
<div class="moz-signature">-- <br>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<title>Signatur_2</title>
<font size="-1"><span
 style="font-family: Courier New,Courier,monospace;"></span></font><br
 style="font-family: Courier New,Courier,monospace;">
</div>
</body>
</html>

--------------070004030101040705020702--


--===============0551216524==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0551216524==--
