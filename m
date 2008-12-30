Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out1.iinet.net.au ([203.59.1.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1LHoEl-0003vU-Tt
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 00:43:01 +0100
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: linux-dvb@linuxtv.org
Date: Wed, 31 Dec 2008 08:42:52 +0900
Message-Id: <58382.1230680572@iinet.net.au>
Subject: [linux-dvb] DVICO dual express incorrect readback of firmware
	message (2.6.28 kernel)
Reply-To: sonofzev@iinet.net.au
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1248036682=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1248036682==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<HTML>
Hi <BR>
<BR>
Since loading on the new kernel I get the following message constantly bein=
g printed in dmesg<BR>
<BR>
xc2028 4-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 4-0061: Incorrect readback of firmware version.<BR>
<BR>
Also CPU usage is high being used by a process kdvb-ad-2-fe-0. This causing=
 a jitter with video playback. <BR>
<BR>
I am using the DVICO Fusion Dual Express (card 11 on cx-23885). <BR>
<BR>
I don't have the original driver disk, the firmware I got from somewhere on=
 the web. However, I have not had this error until installing 2.6.28 with t=
he in-kernel dvb drivers. <BR>
<BR>
I did not have this problem in the past with mercurial drivers. <BR>
<BR>
Is this something to do with my kernel config, firmware I am using, or poss=
ibly an issue with the in-kernel driver?<BR>
<BR>
Any help would be appreciated. <BR>
<BR>
cheers<BR>
<BR>
Allan<BR>
 </HTML>
<BR>=


--===============1248036682==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1248036682==--
