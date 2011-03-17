Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <linuxtv@nzbaxters.com>) id 1Q09g8-0008K6-Kb
	for linux-dvb@linuxtv.org; Thu, 17 Mar 2011 10:39:37 +0100
Received: from mta03.xtra.co.nz ([210.54.141.252])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Q09g7-0002Zu-4d; Thu, 17 Mar 2011 10:39:36 +0100
Message-ID: <3116D6F9367D43529D2F3ED7938ABF82@wlgl04017>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
References: <DB7182D0-F83D-459A-8706-40E67D0ABD06@googlemail.com>
In-Reply-To: <DB7182D0-F83D-459A-8706-40E67D0ABD06@googlemail.com>
Date: Thu, 17 Mar 2011 22:39:05 +1300
MIME-Version: 1.0
Subject: Re: [linux-dvb] Simultaneous recordings from one frontend
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1359058149=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1359058149==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_001D_01CBE4F4.1ED04570"

This is a multi-part message in MIME format.

------=_NextPart_000_001D_01CBE4F4.1ED04570
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

VDR

Which will also do multiple decoded encrypted channels from the same =
transponder (with the right CAM/CI)


From: Pascal J=FCrgens=20
Sent: Thursday, March 10, 2011 2:41 AM
To: linux-dvb@linuxtv.org=20
Subject: [linux-dvb] Simultaneous recordings from one frontend


Hi all,=20


SUMMARY: What's the best available tool for demultiplexing into multiple =
simultaneous recordings (files)?


I'm looking for a way to record a TS to overlapping files (ie, files2 =
should start 5 minutes before file1 ends). This means that two readers =
need to access the card at once. As far as I can tell from past =
discussions [1], this is not a feature that's currently present or =
planned in the kernel.


So while searching for a userspace app that is capable of this, I found =
two options[3]:


- Adam Charrett's dvbstreamer [2] seems to run a sort-of ringbuffer and =
can output to streams and files. However, it's not all too stable, =
especially when using the remote control protocol.


- the RTP streaming apps (dvblast, mumudvb, dvbyell etc.) are designed =
to allow multiple listeners. The ideal solution would be something like =
an interface-local ipv6 multicast (mumudvb recommends using a TTL of 0 =
to prevent packets from exiting the machine, but that seems like a =
cludge). Sadly, I haven't gotten that to work [4].


Hence my questions are:
- Am I doing something wrong and is there actually an easy way to stream =
to two files locally?
- Is there some other solution that I'm not aware of that fits my =
scenario perfectly?


Thanks in advance,
regards,
Pascal Juergens


[1] http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.html
[2] http://sourceforge.net/projects/dvbstreamer/


[3] There's also the Linux::DVB::DVBT perl extension, but in my tests it =
wasn't happy about recording anything: "timed out waiting for data : =
Inappropriate ioctl for device at /usr/local/bin/dvbt-record line 53"


[4] dvblast, for example, gives "warning: getaddrinfo error: Name or =
service not known
error: Invalid target address for -d switch" when using [ff01::1%eth0] =
as the target address.
Additionally, I wasn't able to consume a regular ipv4 multicast with two =
instances of mplayer - the first one worked, the second one couldn't =
access the url.


-------------------------------------------------------------------------=
-------


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_NextPart_000_001D_01CBE4F4.1ED04570
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type =
content=3Dtext/html;charset=3Diso-8859-1>
<META content=3D"MSHTML 6.00.2900.6049" name=3DGENERATOR></HEAD>
<BODY id=3DMailContainerBody=20
style=3D"PADDING-RIGHT: 10px; PADDING-LEFT: 10px; PADDING-TOP: 15px; =
WORD-WRAP: break-word; webkit-nbsp-mode: space; webkit-line-break: =
after-white-space"=20
leftMargin=3D0 topMargin=3D0 CanvasTabStop=3D"true" name=3D"Compose =
message area">
<DIV><FONT face=3DArial size=3D2>VDR</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Which will also do multiple decoded =
encrypted=20
channels from the same transponder (with the right CAM/CI)</FONT></DIV>
<DIV style=3D"FONT: 10pt Tahoma">
<DIV><BR></DIV>
<DIV style=3D"BACKGROUND: #f5f5f5">
<DIV style=3D"font-color: black"><B>From:</B> <A=20
title=3Dlists.pascal.juergens@googlemail.com=20
href=3D"mailto:lists.pascal.juergens@googlemail.com">Pascal =
J=FCrgens</A> </DIV>
<DIV><B>Sent:</B> Thursday, March 10, 2011 2:41 AM</DIV>
<DIV><B>To:</B> <A title=3Dlinux-dvb@linuxtv.org=20
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> </DIV>
<DIV><B>Subject:</B> [linux-dvb] Simultaneous recordings from one=20
frontend</DIV></DIV></DIV>
<DIV><BR></DIV>Hi all,=20
<DIV><BR></DIV>
<DIV>SUMMARY: What's the best available tool for demultiplexing into =
multiple=20
simultaneous recordings (files)?</DIV>
<DIV><BR></DIV>
<DIV>I'm looking for a way to record a TS to overlapping files (ie, =
files2=20
should start 5 minutes before file1 ends). This means that two readers =
need to=20
access the card at once. As far as I can tell from past discussions [1], =
this is=20
not a feature that's currently present or planned in the kernel.</DIV>
<DIV><BR></DIV>
<DIV>So while searching for a userspace app that is capable of this, I =
found two=20
options[3]:</DIV>
<DIV><BR></DIV>
<DIV>-&nbsp;Adam&nbsp;Charrett's&nbsp;dvbstreamer [2] seems to run a =
sort-of=20
ringbuffer and can output to streams and files. However, it's not all =
too=20
stable, especially when using the remote control protocol.</DIV>
<DIV><BR></DIV>
<DIV>- the RTP streaming apps (dvblast, mumudvb, dvbyell etc.) are =
designed to=20
allow multiple listeners. The ideal solution would be something like an=20
interface-local ipv6 multicast (mumudvb recommends using a TTL of 0 to =
prevent=20
packets from exiting the machine, but that seems like a cludge). Sadly, =
I=20
haven't gotten that to work [4].</DIV>
<DIV><BR></DIV>
<DIV>Hence my questions are:</DIV>
<DIV>- Am I doing something wrong and is there actually an easy way to =
stream to=20
two files locally?</DIV>
<DIV>- Is there some other solution that I'm not aware of that fits my =
scenario=20
perfectly?</DIV>
<DIV><BR></DIV>
<DIV>Thanks in advance,</DIV>
<DIV>regards,</DIV>
<DIV>Pascal Juergens</DIV>
<DIV><BR></DIV>
<DIV>[1]&nbsp;<A=20
href=3D"http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.h=
tml">http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.html=
</A></DIV>
<DIV>[2]&nbsp;<A=20
href=3D"http://sourceforge.net/projects/dvbstreamer/">http://sourceforge.=
net/projects/dvbstreamer/</A></DIV>
<DIV><BR></DIV>
<DIV>[3] There's also the&nbsp;Linux::DVB::DVBT perl extension, but in =
my tests=20
it wasn't happy about recording anything: "timed out waiting for data :=20
Inappropriate ioctl for device at /usr/local/bin/dvbt-record line =
53"</DIV>
<DIV><BR></DIV>
<DIV>[4] dvblast, for example, gives "warning: getaddrinfo error: Name =
or=20
service not known</DIV>
<DIV>error: Invalid target address for -d switch" when using =
[ff01::1%eth0] as=20
the target address.</DIV>
<DIV>Additionally, I wasn't able to consume a regular ipv4 multicast =
with two=20
instances of mplayer - the first one worked, the second one couldn't =
access the=20
url.</DIV>
<P>
<HR>

<P></P>_______________________________________________<BR>linux-dvb =
users=20
mailing list<BR>For V4L/DVB development, please use instead=20
linux-media@vger.kernel.org<BR>linux-dvb@linuxtv.org<BR>http://www.linuxt=
v.org/cgi-bin/mailman/listinfo/linux-dvb</BODY></HTML>

------=_NextPart_000_001D_01CBE4F4.1ED04570--



--===============1359058149==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1359058149==--
