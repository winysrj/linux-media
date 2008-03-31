Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sage.wingpath.co.uk ([62.3.234.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timufea@fastmail.co.uk>) id 1JgGom-0000NH-UD
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 12:00:51 +0200
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by nettle.wingpath.private (8.14.2/8.14.2) with ESMTP id m2VA09wc002741
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 11:00:09 +0100
Message-ID: <47F0B629.3030903@fastmail.co.uk>
Date: Mon, 31 Mar 2008 11:00:09 +0100
From: timufea <timufea@fastmail.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Nova-T 500 disconnects - solved?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0979341313=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0979341313==
Content-Type: multipart/alternative;
 boundary="------------070106030509050808070108"

This is a multi-part message in MIME format.
--------------070106030509050808070108
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It's probably unwise to celebrate just yet, but...

I was running a vanilla 2.6.24.2 kernel, and was getting 2 or 3 USB 
disconnects each day. 5 days ago I upgraded to 2.6.24.4, and haven't had 
a USB disconnect since!

There is a fix in 2.6.24.4 for a USB bug that was introduced in Oct 2007 
- see: 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81

Hopefully this was the cause of the USB disconnects.

Some details of my setup, in case it's relevant:
  Nova-T 500
  v4l-dvb rev 127f67dea087 (Feb 26)
  Vanilla 2.6.24.4 kernel
  Slackware 11
  IR remote control in use
  Continual EIT scanning
  Poor reception (MythTV reports 51-53%)

Frank


--------------070106030509050808070108
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
<font face=3D"sans-serif">It's probably unwise to celebrate just yet,
but...<br>
<br>
I was running a vanilla 2.6.24.2 kernel, and was getting 2 or 3 USB
disconnects each day. 5 days ago I upgraded to 2.6.24.4, and haven't
had a USB disconnect since!<br>
<br>
There is a fix in 2.6.24.4 for a USB bug that was introduced in Oct
2007 - see:
<a class=3D"moz-txt-link-freetext"
 href=3D"http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.24.=
y.git;a=3Dcommit;h=3D5475187c2752adcc6d789592b5f68c81c39e5a81">http://git=
=2Ekernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.24.y.git;a=3Dcommit;=
h=3D5475187c2752adcc6d789592b5f68c81c39e5a81</a><br>
<br>
Hopefully this was the cause of the USB disconnects.<br>
<br>
Some details of my setup, in case it's relevant:<br>
=C2=A0 Nova-T 500<br>
=C2=A0 v4l-dvb rev 127f67dea087 (Feb 26)<br>
=C2=A0 Vanilla 2.6.24.4 kernel<br>
=C2=A0 Slackware 11<br>
=C2=A0 IR remote control in use<br>
=C2=A0 Continual EIT scanning<br>
=C2=A0 Poor reception (MythTV reports 51-53%)<br>
<br>
Frank<br>
</font>
<br>
</body>
</html>

--------------070106030509050808070108--


--===============0979341313==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0979341313==--
