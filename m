Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout.arqiva.com ([80.169.174.69]
	helo=pdz-crw-msg02.local.arqiva.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert.martin@arqiva.com>) id 1Koc0A-0002Ko-9R
	for linux-dvb@linuxtv.org; Sat, 11 Oct 2008 12:47:14 +0200
Received: from mail2.arqiva.com (unverified [10.161.45.149]) by
	pdz-crw-msg02.local.arqiva.com (Clearswift SMTPRS 5.2.9) with ESMTP
	id <T89f823847e0aa12f7d1774@pdz-crw-msg02.local.arqiva.com> for
	<linux-dvb@linuxtv.org>; Sat, 11 Oct 2008 11:46:36 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Sat, 11 Oct 2008 11:44:54 +0100
Message-ID: <24FD17B66348C84282C591AA9BE3602E490EA8@paq-cft-exc01.Arqiva.Local>
From: "Bob Martin" <robert.martin@arqiva.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb]  TechnoTrend S2-3600
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0559773442=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0559773442==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
    boundary="----_=_NextPart_001_01C92B8E.A3F52E55"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C92B8E.A3F52E55
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Igor,

Testing this it was found to work after it had been previously run with Win=
dows on a dual boot machine, but not if used cold.

The following was seen.  Please let me know how I can provide any additiona=
l debug information or assistance.

Regards,
Bob.


After having run Windows XP and the TT viewer application.

robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335> ./sza=
p-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIVERSAL
reading channels from file 'channels.conf-dvbs-sirius'
zapping to 1 'Ent':
delivery 0x4, modulation 0x0
sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5, rolloff 0x0
vpid 0x0065, apid 0x0066, sid 0x0001
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
status 1e | signal 01a0 | snr 0069 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK
status 1e | signal 01a0 | snr 0068 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK
status 1e | signal 01a0 | snr 0067 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK
status 1e | signal 01a0 | snr 0069 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK
^C
robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335>


Disconnect USB cable, but unit is left powered.

robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335> ./sza=
p-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIVERSAL
reading channels from file 'channels.conf-dvbs-sirius'
zapping to 1 'Ent':
delivery 0x4, modulation 0x0
sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5, rolloff 0x0
vpid 0x0065, apid 0x0066, sid 0x0001
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
^C
robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335>


This email, its content and any files transmitted with it are for the perso=
nal attention of the addressee only, any other usage or access is unauthori=
sed. It may contain information which could be confidential or privileged. =
If you are not the intended addressee you may not copy, disclose, circulate=
 or use it.
If you have received this email in error, please destroy it and notify the =
sender by email. Any representations or commitments expressed in this email=
 are subject to contract.=A0=20
Although we use reasonable endeavours to virus scan all sent emails, it is =
the responsibility of the recipient to ensure that they are virus free and =
we advise you to carry out your own virus check before opening any attachme=
nts.  We cannot accept liability for any damage sustained as a result of so=
ftware viruses.  We reserve the right to monitor email communications throu=
gh our networks.
Arqiva Limited. Registered office: Crawley Court, Winchester, Hampshire SO2=
1 2QA United Kingdom Registered in England and Wales number 2487597


------_=_NextPart_001_01C92B8E.A3F52E55
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Diso-8859-=
1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version 6.5.7652.24">
<TITLE>[linux-dvb] TechnoTrend S2-3600</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Hi Igor,<BR>
<BR>
Testing this it was found to work after it had been previously run with Win=
dows on a dual boot machine, but not if used cold.<BR>
<BR>
The following was seen.&nbsp; Please let me know how I can provide any addi=
tional debug information or assistance.<BR>
<BR>
Regards,<BR>
Bob.<BR>
<BR>
<BR>
After having run Windows XP and the TT viewer application.<BR>
<BR>
robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335&gt; ./=
szap-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIVERSAL<B=
R>
reading channels from file 'channels.conf-dvbs-sirius'<BR>
zapping to 1 'Ent':<BR>
delivery 0x4, modulation 0x0<BR>
sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5, rolloff 0x=
0<BR>
vpid 0x0065, apid 0x0066, sid 0x0001<BR>
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<BR>
status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |<BR>
status 1e | signal 01a0 | snr 0069 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK<BR>
status 1e | signal 01a0 | snr 0068 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK<BR>
status 1e | signal 01a0 | snr 0067 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK<BR>
status 1e | signal 01a0 | snr 0069 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK<BR>
^C<BR>
robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335&gt;<BR>
<BR>
<BR>
Disconnect USB cable, but unit is left powered.<BR>
<BR>
robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335&gt; ./=
szap-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIVERSAL<B=
R>
reading channels from file 'channels.conf-dvbs-sirius'<BR>
zapping to 1 'Ent':<BR>
delivery 0x4, modulation 0x0<BR>
sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5, rolloff 0x=
0<BR>
vpid 0x0065, apid 0x0066, sid 0x0001<BR>
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<BR>
status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |<BR>
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |<BR>
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |<BR>
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |<BR>
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |<BR>
status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |<BR>
^C<BR>
robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335&gt;<BR>
<BR>
</FONT>
</P>


<p><span style=3D"font-family:'Verdana';font-size:8pt;">This email, its con=
tent and any files transmitted with it are for the personal attention of th=
e addressee only, any other usage or access is unauthorised. It may contain=
 information which could be confidential or privileged. If you are not the =
intended addressee you may not copy, disclose, circulate or use it.</span><=
/p>
<p><span style=3D"font-family:'Verdana';font-size:8pt;">If you have receive=
d this email in error, please destroy it and notify the sender by email. An=
y representations or commitments expressed in this email are subject to con=
tract.&nbsp; </span></p>
<p><span style=3D"font-family:'Verdana';font-size:8pt;">Although we use rea=
sonable endeavours to virus scan all sent emails, it is the responsibility =
of the recipient to ensure that they are virus free and we advise you to ca=
rry out your own virus check before opening any attachments.  We cannot acc=
ept liability for any damage sustained as a result of software viruses.  We=
 reserve the right to monitor email communications through our networks.</s=
pan></p>
<p><span style=3D"font-family:'Verdana';font-size:8pt;">Arqiva Limited. Reg=
istered office: Crawley Court, Winchester, Hampshire SO21 2QA United Kingdo=
m Registered in England and Wales number 2487597</span></p>
<p><span style=3D"font-family:'Verdana';font-size:8pt;">&nbsp;</span></p></=
BODY>
</HTML>

------_=_NextPart_001_01C92B8E.A3F52E55--


--===============0559773442==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0559773442==--
