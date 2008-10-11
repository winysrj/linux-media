Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout.arqiva.com ([80.169.174.69]
	helo=pdz-crw-msg02.local.arqiva.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert.martin@arqiva.com>) id 1KoiZo-0006Kz-C3
	for linux-dvb@linuxtv.org; Sat, 11 Oct 2008 19:48:29 +0200
Received: from mail2.arqiva.com (unverified [10.161.45.149]) by
	pdz-crw-msg02.local.arqiva.com (Clearswift SMTPRS 5.2.9) with ESMTP
	id <T89f9a5260c0aa12f7d1774@pdz-crw-msg02.local.arqiva.com> for
	<linux-dvb@linuxtv.org>; Sat, 11 Oct 2008 18:47:49 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C92BC9.7B490533"
Date: Sat, 11 Oct 2008 18:45:56 +0100
Message-ID: <24FD17B66348C84282C591AA9BE3602E490EAA@paq-cft-exc01.Arqiva.Local>
References: <24FD17B66348C84282C591AA9BE3602E490EA8@paq-cft-exc01.Arqiva.Local>
	<200810111530.01594.liplianin@tut.by>
From: "Bob Martin" <robert.martin@arqiva.com>
To: <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] TechnoTrend S2-3600
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C92BC9.7B490533
Content-Type: multipart/alternative;
    boundary="----_=_NextPart_002_01C92BC9.7B490533"

------_=_NextPart_002_01C92BC9.7B490533
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Re-post due to error in e-mail addressing.  Apologies.

Hi Igor,

Please find attached the parsed log.  I hope it contains enough information=
.  If I left the Windows application running too long Windows would crash a=
nd I would get the blue screen.  This only happened when the sniffing was i=
nstalled.

If it's not enough I'll try again.

Regards,
Bob.



-----Original Message-----
From: Igor M. Liplianin [mailto:liplianin@tut.by]
Sent: Sat 11/10/2008 1:30 PM
To: linux-dvb@linuxtv.org
Cc: Bob Martin
Subject: Re: [linux-dvb]  TechnoTrend S2-3600
=20
? ????????? ?? 11 October 2008 13:44:54 Bob Martin ???????(?):
> Hi Igor,
>
>  Testing this it was found to work after it had been previously run with
> Windows on a dual boot machine, but not if used cold.
>
>  The following was seen.=A0 Please let me know how I can provide any
> additional debug information or assistance.
Hi Bob,
Useful links

http://www.usb.org

FAQ Usbsnoop: http://mxhaard.free.fr/spca50x/Download/snoopy.pdf

USB sniffer to sniff Windows USB drivers, which makes logs:=20
http://benoit.papillault.free.fr/usbsnoop/sniff-bin-1.8.zip

Parser for usbsnoop.log: http://www.isely.net/downloads/pvrusb2-mci-2007042=
8a.tar.bz2

Project Usbreplay (and yet another parser for usbsnoop log files):=20
http://mcentral.de/wiki/index.php/Usbreplay

Command:

perl parser.pl < usbsnoop.log > usbsnoopparsed.log

Now we have usbsnoopparsed.log.=20
It is very informative :)
Generally, You start snooping, then insert card, tune to channel and close =
sniffer.
Usually, log is about 100MB, but most part is DVB data, that can be omitted.
If You make log in Windows and compress it, You may send it to me and I wil=
l look on it.
But better parsing it first with parser. That makes log smaller and more cl=
ean.
>
>  Regards,
>  Bob.
>
>
>  After having run Windows XP and the TT viewer application.
>
>  robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335>
> ./szap-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIVERS=
AL
> reading channels from file 'channels.conf-dvbs-sirius'
>  zapping to 1 'Ent':
>  delivery 0x4, modulation 0x0
>  sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5, rolloff
> 0x0 vpid 0x0065, apid 0x0066, sid 0x0001
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
>  status 1e | signal 01a0 | snr 0069 | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK status 1e | signal 01a0 | snr 0068 | ber 00000000 | unc
> fffffffe | FE_HAS_LOCK status 1e | signal 01a0 | snr 0067 | ber 00000000 |
> unc fffffffe | FE_HAS_LOCK status 1e | signal 01a0 | snr 0069 | ber
> 00000000 | unc fffffffe | FE_HAS_LOCK ^C
>  robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335>
>
>
>  Disconnect USB cable, but unit is left powered.
>
>  robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335>
> ./szap-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIVERS=
AL
> reading channels from file 'channels.conf-dvbs-sirius'
>  zapping to 1 'Ent':
>  delivery 0x4, modulation 0x0
>  sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5, rolloff
> 0x0 vpid 0x0065, apid 0x0066, sid 0x0001
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
>  status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
>  status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
>  status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
>  status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
>  status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
>  ^C
>  robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f959335>



--=20
Igor M. Liplianin




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


------_=_NextPart_002_01C92BC9.7B490533
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Diso-8859-=
1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version 6.5.7652.24">
<TITLE>RE: [linux-dvb]  TechnoTrend S2-3600</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Re-post due to error in e-mail addressing.&nbsp; Apologie=
s.<BR>
<BR>
Hi Igor,<BR>
<BR>
Please find attached the parsed log.&nbsp; I hope it contains enough inform=
ation.&nbsp; If I left the Windows application running too long Windows wou=
ld crash and I would get the blue screen.&nbsp; This only happened when the=
 sniffing was installed.<BR>
<BR>
If it's not enough I'll try again.<BR>
<BR>
Regards,<BR>
Bob.<BR>
<BR>
<BR>
<BR>
-----Original Message-----<BR>
From: Igor M. Liplianin [<A HREF=3D"mailto:liplianin@tut.by">mailto:liplian=
in@tut.by</A>]<BR>
Sent: Sat 11/10/2008 1:30 PM<BR>
To: linux-dvb@linuxtv.org<BR>
Cc: Bob Martin<BR>
Subject: Re: [linux-dvb]&nbsp; TechnoTrend S2-3600<BR>
<BR>
? ????????? ?? 11 October 2008 13:44:54 Bob Martin ???????(?):<BR>
&gt; Hi Igor,<BR>
&gt;<BR>
&gt;&nbsp; Testing this it was found to work after it had been previously r=
un with<BR>
&gt; Windows on a dual boot machine, but not if used cold.<BR>
&gt;<BR>
&gt;&nbsp; The following was seen.=A0 Please let me know how I can provide =
any<BR>
&gt; additional debug information or assistance.<BR>
Hi Bob,<BR>
Useful links<BR>
<BR>
<A HREF=3D"http://www.usb.org">http://www.usb.org</A><BR>
<BR>
FAQ Usbsnoop: <A HREF=3D"http://mxhaard.free.fr/spca50x/Download/snoopy.pdf=
">http://mxhaard.free.fr/spca50x/Download/snoopy.pdf</A><BR>
<BR>
USB sniffer to sniff Windows USB drivers, which makes logs:<BR>
<A HREF=3D"http://benoit.papillault.free.fr/usbsnoop/sniff-bin-1.8.zip">htt=
p://benoit.papillault.free.fr/usbsnoop/sniff-bin-1.8.zip</A><BR>
<BR>
Parser for usbsnoop.log: <A HREF=3D"http://www.isely.net/downloads/pvrusb2-=
mci-20070428a.tar.bz2">http://www.isely.net/downloads/pvrusb2-mci-20070428a=
.tar.bz2</A><BR>
<BR>
Project Usbreplay (and yet another parser for usbsnoop log files):<BR>
<A HREF=3D"http://mcentral.de/wiki/index.php/Usbreplay">http://mcentral.de/=
wiki/index.php/Usbreplay</A><BR>
<BR>
Command:<BR>
<BR>
perl parser.pl &lt; usbsnoop.log &gt; usbsnoopparsed.log<BR>
<BR>
Now we have usbsnoopparsed.log.<BR>
It is very informative :)<BR>
Generally, You start snooping, then insert card, tune to channel and close =
sniffer.<BR>
Usually, log is about 100MB, but most part is DVB data, that can be omitted=
.<BR>
If You make log in Windows and compress it, You may send it to me and I wil=
l look on it.<BR>
But better parsing it first with parser. That makes log smaller and more cl=
ean.<BR>
&gt;<BR>
&gt;&nbsp; Regards,<BR>
&gt;&nbsp; Bob.<BR>
&gt;<BR>
&gt;<BR>
&gt;&nbsp; After having run Windows XP and the TT viewer application.<BR>
&gt;<BR>
&gt;&nbsp; robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f95=
9335&gt;<BR>
&gt; ./szap-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIV=
ERSAL<BR>
&gt; reading channels from file 'channels.conf-dvbs-sirius'<BR>
&gt;&nbsp; zapping to 1 'Ent':<BR>
&gt;&nbsp; delivery 0x4, modulation 0x0<BR>
&gt;&nbsp; sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5,=
 rolloff<BR>
&gt; 0x0 vpid 0x0065, apid 0x0066, sid 0x0001<BR>
&gt;&nbsp; using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux=
0'<BR>
&gt;&nbsp; status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe=
 |<BR>
&gt;&nbsp; status 1e | signal 01a0 | snr 0069 | ber 00000000 | unc fffffffe=
 |<BR>
&gt; FE_HAS_LOCK status 1e | signal 01a0 | snr 0068 | ber 00000000 | unc<BR>
&gt; fffffffe | FE_HAS_LOCK status 1e | signal 01a0 | snr 0067 | ber 000000=
00 |<BR>
&gt; unc fffffffe | FE_HAS_LOCK status 1e | signal 01a0 | snr 0069 | ber<BR>
&gt; 00000000 | unc fffffffe | FE_HAS_LOCK ^C<BR>
&gt;&nbsp; robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f95=
9335&gt;<BR>
&gt;<BR>
&gt;<BR>
&gt;&nbsp; Disconnect USB cable, but unit is left powered.<BR>
&gt;<BR>
&gt;&nbsp; robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f95=
9335&gt;<BR>
&gt; ./szap-s2 -S 0 -C 56 -M 2 -c channels.conf-dvbs-sirius -n 1 -D -l UNIV=
ERSAL<BR>
&gt; reading channels from file 'channels.conf-dvbs-sirius'<BR>
&gt;&nbsp; zapping to 1 'Ent':<BR>
&gt;&nbsp; delivery 0x4, modulation 0x0<BR>
&gt;&nbsp; sat 5, frequency 12111 MHz H, symbolrate 27500000, coderate 0x5,=
 rolloff<BR>
&gt; 0x0 vpid 0x0065, apid 0x0066, sid 0x0001<BR>
&gt;&nbsp; using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux=
0'<BR>
&gt;&nbsp; status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe=
 |<BR>
&gt;&nbsp; status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe=
 |<BR>
&gt;&nbsp; status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe=
 |<BR>
&gt;&nbsp; status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe=
 |<BR>
&gt;&nbsp; status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe=
 |<BR>
&gt;&nbsp; status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe=
 |<BR>
&gt;&nbsp; ^C<BR>
&gt;&nbsp; robert.martin@phenom001:~/downloads/dvb/stb0899/szap-s2-80703f95=
9335&gt;<BR>
<BR>
<BR>
<BR>
--<BR>
Igor M. Liplianin<BR>
<BR>
<BR>
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

------_=_NextPart_002_01C92BC9.7B490533--

------_=_NextPart_001_01C92BC9.7B490533
Content-Type: application/x-bzip; name="usbsnoopparsed.log.bz2"
Content-Transfer-Encoding: base64
Content-Description: usbsnoopparsed.log.bz2
Content-Disposition: attachment; filename="usbsnoopparsed.log.bz2"

QlpoOTFBWSZTWVSoeGkBNrxfgHCwQGJ/9T/t3oq/798AYJ5+++BQAAAUAAAAAPmmZAc9OvN7tCDU
IllVYLAME7wCzyXAAAAAAAAAIagiq893UJXsDL0ZtptggQpDAAAAAADyAE+mzRIAUAkAUAFABx6L
1qfCHg+3vigAAAAAAAAAAoAEPXo52xVUqqFHuvVpJb3OzxTbHe3ewANgDmT42vPH093PXvd3c22Z
KN27s0ogDcXwnBd53ZpbNs0CktsQBunjbg8KKLtkrW7ZKUgDDxGC5pVKVKqVAGHHvkd4L5StKa0o
W2AN8JnTbSqW2lKUpANwWdIttKKUpSlswBnCdwS22zSqKlbNIA3D24PLbSlF23ZpSkAAAASJAlCA
KAAAAAWAdPG1GI6YjvuHCEhAFTGj1NGPVVSKGgAAAAAABFPDBSlKkjepNMCaYEGRiaMmTEwMNSBJ
VKepiADQAAAAAAk9UpCImkSZADQAAGgAaAIkgIEIlMiTyaQ2p6gaNNpPU3qjAghSEIgVU9TAEwAA
BGEwB512VVEFQFfCKS1rKigp4dKKcb/D9Lf8EKoAH9P6EMEmJiYmIIhKTJkyUklJkyZKTJkyZMlJ
kyZMmSkyZMmTJSZMmVMlLKSUSVFUsmzVirG1FG0bUW0W0W0a0bUyU2o1GqNaNY1RajaxpaRaQaVK
EKVKFKFKCZLBZLJslksFksmyWSybJZNkslk2SyWCyWTZLJZNkslgslk2SyWCyWTZLJZNg2SyWTZL
JZNkslgoxZLBZLJYLBZLJYLBslksmyWSybJZNkslk2SyWDZLJZLBYLJZLBslksFksmyWSwWCyWCy
WTZLJslksmyWSybJZNkshpKa1r+j8gP05/M4B/Q/3v6H7vH7vgD/g59Pt/UeP+I9v7j08e35eA/Q
AD+f13gAAAA+n6fb09ufs4H24AAfpzwB+7gfbh8cAP2cAPHD9OAH04AB44AAAAAAAAAAAAAAAAAA
AAAAAAAAAAB+HA9OAAAAAAAAAAAAAAAAAAAH8r08fb6fwH90c+N9PH0Pw5f/Kvm5fN1dX1fl935f
dlu6vV5btWrVqqgAA5zxw+nD4/YeD+L6H7j7fwfl+XOfl+B6c9OH7Pt4Pg/d+X6H5fxe3xvj6B7c
AAAD9n8HjHpz237PH259uAAAAAAAAAAAAAAAAAAAHj7ePHj456foeDx9vj0+PHjxz2+DwePj6enD
nP3eOHPHOeDxznDnjnPHj459vHPH4c+3pw/d9uex6HPp48ePjx8fwfHp/B9PQPTx+njnOc5znOc5
znOc5z8Oc5znOc5znOc5znOc5zntz4+PQPTx8eOc5znOc5znOc5znPjnOc5znOc5znOc5znOc57c
+Pj0D08fHjnOc5znOc5znOc5z45znOc5znOc5znOc5znOe3Pj49A9PHx45znOc5znOc5znOc+Oc5
znOc5znOc5znOc5zntz4+PQPTx8eOc5znOc5znOc5znPjnOc5znOc5znOc5znOc57HPj49A9PHx4
5znOc5znOc5znOc+Oc5znOc5znOc5znOc5zntz4+PQPTx8eOc5znOc5znOc5znPjnOc5znOc5znO
c5znOc57c+Pj0D08fHjnOc5znOc5znOc5z45znOc5znOc5znOc5znOe3Pj49A9PHx45znOc5znOc
5znOc+Oc5znOc5znOc5znOc5zntz4+PQPTx8eOc5znOc5znOc5znPjnOc5znOc5znOc5znOc57eO
c9vseh+z49OfHtznOc5znOc5znOc5znOc5znOc5znOc5zhznPjnjnjx48fl7fh8eAPbwfT037PTx
z6ePy8ePHPT6BJCfwn8Jk9PTJkyehNwhNSzU3MmTIQhMmTJkIQmTJkyEISQnJkyWEk9GXzctTVVy
6tW6tWrVu+7dq/LV8Xdq7vpkyZCEJkyZMnJkyZNTJkyEISQhCEISTUyZMhCEkIQhCEkIQnYT9P2e
PTnOflz8vt4/L7eD7cPyNzGMYxjGMYxjc5jGMZcuXu3fNl7nKqru1avdu93k8vVq3bvVWrVq+r3f
Ny5ZZZeWXdl6vUmr8svyy0545454549vHpz0545+XPYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AD+Tu9vpzwAAAAAAAAAAAAD1X89WrbLz+tQVH+xQVH9d+dTv59evPnr8ffvVtc/XaBuKiV+MW/Hl
J1N6p4ieoindVjHHrHHnHOL3z517rVqGaHeImven9Pmmr7761VQDw8b2e97NT3qWvOefOvffXXnH
ZPQJ6EbzvHFjcREPXrB7PV7AagMipXG7z0dlcG/fG5xu/fU176z11zVZrXv063q++i673JlkfFoh
oAvMq6soqpCES2a75qTqJ6g+pxx1ZXd6KqkCr15anksST/KVazpi+3OZjC2JVTLQltEKwoAAAAyK
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
bYw1Jzu3t3U+cqnhrqjjdXOqUc25VF1yfy+NQCgTR4VFdag8l91TLurP2VnWKQOavrV3YpV0zLuw
otpKXdva0VF8fi+HKpL4PruZbqfB7ldLdSU7vaAsznVE1nVyTS51ZvS1m9zyOas6eUWYvKqCaTTY
h8VUUVsWM6xwFYNTJm5kyFYONYEEUQ07PP0EpSEVQf5iggMCGuYWNqKsikRsM1irFUW0bUbWNUax
bY2JBVFTbWtsWoiTRU0CKCwElJIqDNECpEq5jBFERREURFERREURFERREURFERREURFERjEURFER
REURFERREUREREREREREREQQREREREREREEEREREREREQQREREREREREREQ62rVbuRERERE7rkRE
REREQQRERERERBEQRERERERERERAREREREREREQQREREREREREREREQERERERERERERREURFERjE
YxGMRjEYxGMRjEYxGMRjEYxGMRjEYxGMRjEYxPx79/t2ve9sRjEYxGfXbkYxGMRjO65jEYxGMTu3
MRjEQRO7kRERERO65EEERRO65REURFETurkRREURFOt1yKIijGKJ1uuURRGMURTuuRRjGMURTuuU
URRjFGM7q5jFFGIiM7rmMUYxRFE7utctFotFo3GMRjFO7cxQsd1coyrmuxRiXLTuZq5aLRaLRaLR
aLRaLTtyijGKKKMZ3VyjE25aLRaLRcURjFEU7q5mzGd25mrldRihuaud261y0Wi0Wi0Wi0Wi0aup
3blFGMUUUYzurlCrlotFotHRjGIoxindu2Yop3da5cUUZrlXYctFotFotFotFotFo24op3bmKKMY
ooozu3GrlotFotO3IojGKMYzluoxQ5aOKKMtzbsLlotFotFotFotFotPPfv55r3b4UUU+duYooxi
iijOWi0Wi0auzurkRRjFFC5XFFGblp25jGbc1xlctFotFotFotFotFo12MYop3VzGKKIoooctFot
Fo24xndcxijGKG5uKKMrmrs7q5iVcrjNctFotFotFotFotForsUYxRTurmMUUYxm5aLRaLRbiiKd
1yiKKM1y7GMZrm3GM7q41c3GW5aLRaLRaLRaLRaLRcYxRRjFO6uUYxRQrlotPl1rlo14URjO6uRR
RludiihbluKKM5aLsNuWi0Wi0Wi0Wi0Wi0cUUYxRRjO6uUUYw1y0Wi0WiuxjEUTurlGJY7q5jDbm
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
0u1x++jr+40yzMzPME81rUCUFCWJtLlZz7JxY5nlYj2mppxrAbvvMno6/vNWePz3Nqpha1pal+Tb
hHlPNV6vORfb8X33b/Nf5NynUA0oWGCv39/O/kUEBlEETsUEB89bQumdYQ+szWAZYrNrPOfhjs/l
5/Pt2r3rv1CiKgJl0sdSlUN2XGgwqYtTne44bSdKN3nN3LrrsMVOoSturvjTl2BZh0DLuWtNZW2t
V3ebpoWKmjLWUKn279vVcGo1CZV/dr64aSu5bVYYbvFdmUhuUxZwqjJbzK4uZXXZaNSgYr6otC36
ZqTftmTVvtnFxRl5JFT+VNNGptVfLiPlwWeW+LiuaRziFx1vFHNXm6miGYJrC5amoUFYomoUEq0o
opKDE0ANq2iiaoEiaCl5r77uc76eN5n8wz3vJe80kSfIlkP999VffffV9Tfs6vejrYerqq6tdXem
dEk1ySOF7EkwpampKVNSUVTRQbQUFW24U3UkyGYNJYXBCkE2paBbz7ffc/cvOb+D7774Pe5znpJA
ALH6q+++r3KsrK9St0tpgq8VC0tpdtRRY2pbyokRI5GlLSoigmraCVTRaVKpotK6mi0roo0pQqUT
UgCQmoUHU0WhIe5xb4d7s3+z3v3N++4klF5k93bnffvvq+zJUr1GPa2NunWmnTrDvs6tiZd6TWii
kLM1hkQqVmtPFjbZMwg2raUkQmpaV1IUTlBtZebu19WZm+rK+ruztu0UlJ+kALfkkl5v0O6Li1Kv
31fUTfq9RVKslFUqQ83ta62mt7vLUiSNS0iaCkTVlKmi0iapSJiiUKRNEpU1aGKJoLhC6+73vp+9
73ve973pJJJJJG223++r6vvqqvsUrJ6u/fev3OT3qjz973d748TV5RqJoKPsVSwht5oITLNTvQm9
5tohMs1BimtUajQo1CiUTVKJRNBQhc7znt8nOdEsXTf3tHveZ95ju7w/V9999X1V9q9WV6vSmb4z
vZWzZs2b1vYWE1q1oMEtarBBsQUKONqU7ViahciapSJoKZU8USnZyrK+rezrr6t3NzczPOSJmGax
zn6PW4ve33dCNP76vvvqwX6mVfzBujRHzsra+oezsTQUjYo4UiaAG1YFTQUiaoDaCkYo3CkTVlF9
Muud77973ve9376/ZMIzZIVCHOr9VV95Ksr1Nw/OLXWOlyq+cia7u9qqahSJolKmKJy04qmiGVNF
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
lKimTYxWDS7fMNuL5nWg0TRnOc7jlP6txdJVznOALkO5mcnTvG6zcedczm/ofdLV9HDG8VeLdnXX
5s1I7m9MzNxd5HmPL2x6x5vfvjn3aUoHv1Xqs4w2QQPQoID2l2CLFBQgoIDrIoID9CAKiHrrOOM/
OfWvmseYkkktzgvW7ySSTFbta1kkktttttuAC9S7BdW+/fw+2jZ/J/Jr9rVqxir831mWCoiPlLYi
3vo37xXea8T11xjnN7wv1j51b317z51zzvHPNueec88yjoRUA78K5viKXveQkqSTZfhzWpgMmXd+
8adNx3q+KOYzlYd3znOeP6on2973KSqgV6r1t+usR2/bbbm+93maqjLZy9jvccxErvZlq5jxM91n
Oe69Eemsc2e7Yzxx6559e5v3me/YAeHvGlX2ly9IHGN7oDGLzAKKbvZAwKCA460AqId5wjvNjjjH
wURT62KoG4iJeInMTiIiqe4ADJPJFTkUUUUUUERERGIiI1eK3NW8vi9vvvrfWzjvsZtnP5fjX3Wn
LpqPx1+v53d3d3d4htTMzMzEJLe975TT+Wneuee1cvq7ly2wnb29jux84W4rOc5qZiSvJJVznKDy
52O9MznJFe43hru/ev2sTiqL7MtyivdS35MPfzdnWc5R2vL+vd8GfMZ959cce/d6514IjBEcCggN
Y8uKCAzHoUEB9txQQHHoy0CtYAVEKRRC6gqP0CIii/POTcyHS07+6vidd1x1ngVFLefXv3jW+da1
rWta3OuvjJbYfWmb8mZTPM/ge79mLuZzWcubxPWvGabNdkMd1qeTqKznOdnene73vYlEh5T22947
hXqO3Tk654at5M59Z+D5fM3qEor07UObpa73Wc5H35811blYxErlLXekXv2DljNf/X/Bb761vrWt
8c8iggP6vwiqgif+VBUYg/+v9bf88n6uq+vhR8/VJD5H8b2T2fnSm5opfpBFIo7s7/n+o/f0erve
973ve9777v1/v0XVwqZnfvJe5ziT8hmeDyLD41im9wvl7pEZ5wMeFujOc5miIju973KUgeXN5me9
M1nIt4758aOzrb3DWDFOX3ae643NLsXqG0eo5pm6UDT6dX3Ot83TvQ2KFBAcedicMEwzAggEPPSP
rkUEBt0KCA8iggNNhQQHkUEB5FBAdiggNhQQHoXfszOBLBbAoIDjIoID+pABUR/Y/4f1/rP5T9sv
n/L/pQIIgNv2/7f6H+7SgqO/9dYrxQVHhQVG0P27UFR/2BBEB9dqCo34UFRmONc/03tj/t1//F3J
FOFCQVKh4aQ=

------_=_NextPart_001_01C92BC9.7B490533
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------_=_NextPart_001_01C92BC9.7B490533--
