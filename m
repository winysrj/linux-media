Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.citynetwork.se ([62.95.110.81] helo=smtp01.citynetwork.se)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marten.gustafsson@holisticode.se>)
	id 1Kd3H1-0003VU-97
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 15:28:51 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp01.citynetwork.se (Postfix) with ESMTP id E7D46434E03
	for <linux-dvb@linuxtv.org>; Tue,  9 Sep 2008 15:17:25 +0200 (CEST)
Received: from smtp01.citynetwork.se ([127.0.0.1])
	by localhost (smtp01.citynetwork.se [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ENUJ8FulAP7X for <linux-dvb@linuxtv.org>;
	Tue,  9 Sep 2008 15:17:17 +0200 (CEST)
Received: from xplap (c83-250-175-60.bredband.comhem.se [83.250.175.60])
	(Authenticated sender: marten.gustafsson@holisticode.se)
	by smtp01.citynetwork.se (Postfix) with ESMTP id A556A434DDE
	for <linux-dvb@linuxtv.org>; Tue,  9 Sep 2008 15:17:16 +0200 (CEST)
From: <reklam@holisticode.se>
To: <linux-dvb@linuxtv.org>
Date: Tue, 9 Sep 2008 15:27:43 +0200
Message-ID: <6F209492AAB14D439DC4FCBB16A6C5CB@xplap>
MIME-Version: 1.0
Subject: [linux-dvb] Mantis errors on 64 bit openSuse 11 using Conax ci
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0787755702=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0787755702==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0131_01C91290.9B013CF0"

This is a multi-part message in MIME format.

------=_NextPart_000_0131_01C91290.9B013CF0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi

I am having problems with my AzureWave ad-cp300 with Conax ci on 64 bit
openSuse.  The conax card has part number 904180 rev 1.1.

I have downloaded mantis-665091fda845 from http://jusst.de/hg/mantis/,
compiled it and installed using make install and make insmod.=20

>From messages during make insmod:
Sep  9 14:21:52 linux-s2ma kernel: found a VP-2033 PCI DVB-C device on
(05:07.0),
Sep  9 14:21:52 linux-s2ma kernel:     Mantis Rev 1 [1822:0008], irq: =
17,
latency: 32
Sep  9 14:21:52 linux-s2ma kernel:     memory: 0xc6000000, mmio:
0xffffc2001090e000
Sep  9 14:21:58 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:22:49 linux-s2ma syslog-ng[1698]: last message repeated 8 =
times
Sep  9 14:22:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:23:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:23:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:24:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:24:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:25:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:25:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:26:50 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:26:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:27:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:27:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:28:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:28:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:29:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:29:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:30:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:30:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:31:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:31:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:32:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:32:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:33:11 linux-s2ma syslog-ng[1698]: last message repeated 3 =
times
Sep  9 14:33:11 linux-s2ma kernel:     MAC Address=3D[00:08:ca:1c:2b:59]
Sep  9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0): =
DMA=3D0x40120000
cpu=3D0xffff810040120000 size=3D65536
Sep  9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0): =
RISC=3D0x400f7000
cpu=3D0xffff8100400f7000 size=3D1000
Sep  9 14:33:11 linux-s2ma kernel: DVB: registering new adapter (Mantis =
dvb
adapter)
Sep  9 14:21:52 linux-s2ma kernel: found a VP-2033 PCI DVB-C device on
(05:07.0),
Sep  9 14:21:52 linux-s2ma kernel:     Mantis Rev 1 [1822:0008], irq: =
17,
latency: 32
Sep  9 14:21:52 linux-s2ma kernel:     memory: 0xc6000000, mmio:
0xffffc2001090e000
Sep  9 14:21:58 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:22:49 linux-s2ma syslog-ng[1698]: last message repeated 8 =
times
Sep  9 14:22:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:23:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:23:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:24:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:24:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:25:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:25:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:26:50 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:26:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:27:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:27:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:28:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:28:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:29:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:29:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:30:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:30:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:31:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:31:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:32:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times
Sep  9 14:32:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK Fail =
!
Sep  9 14:33:11 linux-s2ma syslog-ng[1698]: last message repeated 3 =
times
Sep  9 14:33:11 linux-s2ma kernel:     MAC Address=3D[00:08:ca:1c:2b:59]
Sep  9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0): =
DMA=3D0x40120000
cpu=3D0xffff810040120000 size=3D65536
Sep  9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0): =
RISC=3D0x400f7000
cpu=3D0xffff8100400f7000 size=3D1000
Sep  9 14:33:11 linux-s2ma kernel: DVB: registering new adapter (Mantis =
dvb
adapter)
........
Sep  9 14:33:15 linux-s2ma kernel: dvb_ca adapter 0: DVB CAM detected =
and
initialised successfully

lspci -v:
05:07.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
    Subsystem: Twinhan Technology Co. Ltd Device 0008
    Flags: bus master, medium devsel, latency 32, IRQ 17
    Memory at c6000000 (32-bit, prefetchable) [size=3D4K]
    Kernel driver in use: Mantis
    Kernel modules: mantis

Starting Caffeine, this was printed to messages:

Sep  9 14:48:57 linux-s2ma su: (to root) more10 on /dev/pts/1
Sep  9 14:50:27 linux-s2ma syslog-ng[1698]: STATS: dropped 0
Sep  9 15:00:44 linux-s2ma kernel: dvb_ca adapter 0: DVB CAM detected =
and
initialised successfully
Sep  9 15:00:47 linux-s2ma kernel: mantis_hif_write_wait (0): Adater(0)
Slot(0): Write operation timed out!
Sep  9 15:00:47 linux-s2ma kernel: mantis_hif_write_iom (0): Adapter(0)
Slot(0): HIF Smart Buffer operation failed
Sep  9 15:00:48 linux-s2ma kernel: mantis_hif_write_wait (0): Adater(0)
Slot(0): Write operation timed out!
Sep  9 15:00:48 linux-s2ma kernel: mantis_hif_write_iom (0): Adapter(0)
Slot(0): HIF Smart Buffer operation failed
Sep  9 15:00:48 linux-s2ma kernel: dvb_ca adapter 0: CAM tried to send a
buffer larger than the link buffer size (512 > 128)!
Sep  9 15:00:49 linux-s2ma kernel: mantis_hif_write_wait (0): Adater(0)
Slot(0): Write operation timed out!
Sep  9 15:00:49 linux-s2ma kernel: mantis_hif_write_iom (0): Adapter(0)
Slot(0): HIF Smart Buffer operation failed
Sep  9 15:00:49 linux-s2ma kernel: dvb_ca adapter 0: DVB CAM link
initialisation failed :(

Removing the conax ci there are no errors in messages. Also no channels =
when
scanning (comhem).

=20

If this information is useful (or not useful) please let me know. I will
gladly help testing the mantis driver.

=20

M=E5rten

=20


------=_NextPart_000_0131_01C91290.9B013CF0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.E-postmall17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span =
style=3D'font-size:9.0pt;
font-family:Arial'>Hi<br>
<br>
I am having problems with my AzureWave ad-cp300 with Conax ci on 64 bit
openSuse. =A0The conax card has part number 904180 rev 1.1.<br>
<br>
I have downloaded mantis-665091fda845 from <a =
href=3D"http://jusst.de/hg/mantis/,"
title=3D"http://jusst.de/hg/mantis/,">http://jusst.de/hg/mantis/,</a> =
compiled it
and installed using make install and make insmod. <br>
<br>
>From messages during make insmod:<br>
Sep&nbsp; 9 14:21:52 linux-s2ma kernel: found a VP-2033 PCI DVB-C device =
on
(05:07.0),<br>
Sep&nbsp; 9 14:21:52 linux-s2ma kernel:&nbsp;&nbsp;&nbsp;&nbsp; Mantis =
Rev 1
[1822:0008], irq: 17, latency: 32<br>
Sep&nbsp; 9 14:21:52 linux-s2ma kernel:&nbsp;&nbsp;&nbsp;&nbsp; memory:
0xc6000000, mmio: 0xffffc2001090e000<br>
Sep&nbsp; 9 14:21:58 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:22:49 linux-s2ma syslog-ng[1698]: last message repeated 8 =
times<br>
Sep&nbsp; 9 14:22:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:23:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:23:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:24:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:24:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:25:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:25:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:26:50 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:26:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:27:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:27:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:28:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:28:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:29:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:29:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:30:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:30:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:31:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:31:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:32:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:32:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:33:11 linux-s2ma syslog-ng[1698]: last message repeated 3 =
times<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel:&nbsp;&nbsp;&nbsp;&nbsp; MAC
Address=3D[00:08:ca:1c:2b:59]<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0):
DMA=3D0x40120000 cpu=3D0xffff810040120000 size=3D65536<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0):
RISC=3D0x400f7000 cpu=3D0xffff8100400f7000 size=3D1000<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel: DVB: registering new adapter =
(Mantis
dvb adapter)<br>
Sep&nbsp; 9 14:21:52 linux-s2ma kernel: found a VP-2033 PCI DVB-C device =
on
(05:07.0),<br>
Sep&nbsp; 9 14:21:52 linux-s2ma kernel:&nbsp;&nbsp;&nbsp;&nbsp; Mantis =
Rev 1
[1822:0008], irq: 17, latency: 32<br>
Sep&nbsp; 9 14:21:52 linux-s2ma kernel:&nbsp;&nbsp;&nbsp;&nbsp; memory:
0xc6000000, mmio: 0xffffc2001090e000<br>
Sep&nbsp; 9 14:21:58 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:22:49 linux-s2ma syslog-ng[1698]: last message repeated 8 =
times<br>
Sep&nbsp; 9 14:22:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:23:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:23:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:24:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:24:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:25:49 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:25:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:26:50 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:26:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:27:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:27:52 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:28:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:28:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:29:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:29:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:30:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:30:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:31:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:31:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:32:51 linux-s2ma syslog-ng[1698]: last message repeated 9 =
times<br>
Sep&nbsp; 9 14:32:53 linux-s2ma kernel: mantis_ack_wait (0): Slave RACK =
Fail !<br>
Sep&nbsp; 9 14:33:11 linux-s2ma syslog-ng[1698]: last message repeated 3 =
times<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel:&nbsp;&nbsp;&nbsp;&nbsp; MAC
Address=3D[00:08:ca:1c:2b:59]<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0):
DMA=3D0x40120000 cpu=3D0xffff810040120000 size=3D65536<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel: mantis_alloc_buffers (0):
RISC=3D0x400f7000 cpu=3D0xffff8100400f7000 size=3D1000<br>
Sep&nbsp; 9 14:33:11 linux-s2ma kernel: DVB: registering new adapter =
(Mantis
dvb adapter)<br>
........<br>
Sep&nbsp; 9 14:33:15 linux-s2ma kernel: dvb_ca adapter 0: DVB CAM =
detected and
initialised successfully<br>
<br>
lspci -v:<br>
05:07.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI =
Bridge
Controller [Ver 1.0] (rev 01)<br>
&nbsp;&nbsp;&nbsp; Subsystem: Twinhan Technology Co. Ltd Device 0008<br>
&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, latency 32, IRQ =
17<br>
&nbsp;&nbsp;&nbsp; Memory at c6000000 (32-bit, prefetchable) =
[size=3D4K]<br>
&nbsp;&nbsp;&nbsp; Kernel driver in use: Mantis<br>
&nbsp;&nbsp;&nbsp; Kernel modules: mantis<br>
<br>
Starting Caffeine, this was printed to messages:<br>
<br>
Sep&nbsp; 9 14:48:57 linux-s2ma su: (to root) more10 on /dev/pts/1<br>
Sep&nbsp; 9 14:50:27 linux-s2ma syslog-ng[1698]: STATS: dropped 0<br>
Sep&nbsp; 9 15:00:44 linux-s2ma kernel: dvb_ca adapter 0: DVB CAM =
detected and
initialised successfully<br>
Sep&nbsp; 9 15:00:47 linux-s2ma kernel: mantis_hif_write_wait (0): =
Adater(0)
Slot(0): Write operation timed out!<br>
Sep&nbsp; 9 15:00:47 linux-s2ma kernel: mantis_hif_write_iom (0): =
Adapter(0)
Slot(0): HIF Smart Buffer operation failed<br>
Sep&nbsp; 9 15:00:48 linux-s2ma kernel: mantis_hif_write_wait (0): =
Adater(0)
Slot(0): Write operation timed out!<br>
Sep&nbsp; 9 15:00:48 linux-s2ma kernel: mantis_hif_write_iom (0): =
Adapter(0)
Slot(0): HIF Smart Buffer operation failed<br>
Sep&nbsp; 9 15:00:48 linux-s2ma kernel: dvb_ca adapter 0: <st1:place =
w:st=3D"on">CAM</st1:place>
tried to send a buffer larger than the link buffer size (512 &gt; =
128)!<br>
Sep&nbsp; 9 15:00:49 linux-s2ma kernel: mantis_hif_write_wait (0): =
Adater(0)
Slot(0): Write operation timed out!<br>
Sep&nbsp; 9 15:00:49 linux-s2ma kernel: mantis_hif_write_iom (0): =
Adapter(0)
Slot(0): HIF Smart Buffer operation failed<br>
Sep&nbsp; 9 15:00:49 linux-s2ma kernel: dvb_ca adapter 0: DVB CAM link
initialisation failed :(<br>
<br>
Removing the conax ci there are no errors in messages. Also no channels =
when
scanning (comhem).<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span =
style=3D'font-size:9.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>If this information is useful (or not useful) please =
let me
know. I will gladly help testing the mantis =
driver.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>M=E5rten<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_0131_01C91290.9B013CF0--



--===============0787755702==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0787755702==--
