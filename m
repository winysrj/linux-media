Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imo-m14.mx.aol.com ([64.12.138.204])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dbox2alpha@netscape.net>) id 1LEX3S-0008Ds-BV
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 23:45:46 +0100
Received: from dbox2alpha@netscape.net
	by imo-m14.mx.aol.com  (mail_out_v39.1.) id m.c8f.39c30ff8 (34899)
	for <linux-dvb@linuxtv.org>; Sun, 21 Dec 2008 17:44:55 -0500 (EST)
To: linux-dvb@linuxtv.org
Date: Sun, 21 Dec 2008 17:44:49 -0500
MIME-Version: 1.0
From: dbox2alpha@netscape.net
Message-Id: <8CB31D4DD3B74C2-C48-6AA@WEBMAIL-MC16.sysops.aol.com>
Subject: [linux-dvb] TT-3600 on kernel 2.6.27 doesn't work... any help?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0513576893=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0513576893==
Content-Type: multipart/alternative;
 boundary="--------MB_8CB31D4DD403972_C48_DEA_WEBMAIL-MC16.sysops.aol.com"


----------MB_8CB31D4DD403972_C48_DEA_WEBMAIL-MC16.sysops.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"

hi, 
I'm trying to get the TT-3600 USB DVB-S2 to work on a PlayStation 3 but so far I have not been successful.

I'm using the latest DVB-S2 API and driver: s2-liplianin-aed3dd42ac28
which compiles and installs fine.
Driver also seems to initialize fine.
But when I use szap-s2 FE_SET_PROPERTY DTV_CLEAR fails.
problem with the following ioctl: 
ioctl32(szap-s2:32528): Unknown cmd fd(3) cmd(80086f52){t:'o';sz:8} arg(ff835360) on /dev/dvb/adapter0/frontend0

[root@ps3 szap-s2-a75cabee2e95]# ./szap-s2 -c channels.conf -rn 2
reading channels from file 'channels.conf'
zapping to 2 'SAT.1;ProSiebenSat.1':
delivery DVB-S, modulation QPSK
sat 0, frequency 12544 MHz H, symbolrate 22000000, coderate 5/6, rolloff 0.35
vpid 0x00ff, apid 0x0100, sid 0x0020
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_SET_PROPERTY DTV_CLEAR failed: Invalid argument
[root@ps3 szap-s2-a75cabee2e95]#

Any help? Thanks.

----------MB_8CB31D4DD403972_C48_DEA_WEBMAIL-MC16.sysops.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/html; charset="us-ascii"

<font face="Arial, Helvetica, sans-serif">hi, <br>
I'm trying to get the TT-3600 USB DVB-S2 to work on a PlayStation 3 but so far I have not been successful.<br>
<br>
I'm using the latest DVB-S2 API and driver: s2-liplianin-aed3dd42ac28<br>
which compiles and installs fine.<br>
Driver also seems to initialize fine.<br>
But when I use szap-s2 FE_SET_PROPERTY DTV_CLEAR fails.<br>
problem with the following ioctl: <br>
ioctl32(szap-s2:32528): Unknown cmd fd(3) cmd(80086f52){t:'o';sz:8} arg(ff835360) on /dev/dvb/adapter0/frontend0<br>
<br>
[root@ps3 szap-s2-a75cabee2e95]# ./szap-s2 -c channels.conf -rn 2<br>
reading channels from file 'channels.conf'<br>
zapping to 2 'SAT.1;ProSiebenSat.1':<br>
delivery DVB-S, modulation QPSK<br>
sat 0, frequency 12544 MHz H, symbolrate 22000000, coderate 5/6, rolloff 0.35<br>
vpid 0x00ff, apid 0x0100, sid 0x0020<br>
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<br>
FE_SET_PROPERTY DTV_CLEAR failed: Invalid argument<br>
[root@ps3 szap-s2-a75cabee2e95]#<br>
<br>
Any help? Thanks.<br>
</font><div id='MAILCIADA018-5bb8494ec6e12c2' class='aol_ad_footer'><BR/><FONT style="color: black; font: normal 10pt ARIAL, SAN-SERIF;"><HR style="MARGIN-TOP: 10px"></HR>Listen to 350+ music, sports, & news radio stations &#150; including songs for the holidays &#150; FREE while you browse. <a href="http://toolbar.aol.com/aolradio/download.html?ncid=emlweusdown00000013">Start Listening Now</a>! </div>

----------MB_8CB31D4DD403972_C48_DEA_WEBMAIL-MC16.sysops.aol.com--


--===============0513576893==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0513576893==--
