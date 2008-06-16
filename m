Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout3.freenet.de ([195.4.92.93])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1K8KXB-0002uo-W6
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 21:38:34 +0200
Message-ID: <4856C134.1020309@freenet.de>
Date: Mon, 16 Jun 2008 21:38:28 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <482EB3E5.7090607@freenet.de> <482F49BB.4060300@gmail.com>
	<48327AEF.1060809@freenet.de> <48371567.8080304@gmail.com>
In-Reply-To: <48371567.8080304@gmail.com>
Cc: "linux-dvb: linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CAM of Mantis 2033 still not working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0248208159=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0248208159==
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-15"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<span style="font-family: Adobe Helvetica;"></span>Dear Manu,<br>
<br>
since my kernel 2.6.22.19 always crashed with   <br>
<br>
changeset 7348 (28.Mai.08) <br>
<br>
I switched to <br>
<br>
uname -a  <br>
    -&gt; 2.6.24.7 #2 PREEMPT Tue Jun 3 23:33:24 CEST 2008 x86_64
x86_64 x86_64 GNU/Linux<span style="font-family: Adobe Helvetica;"><br>
<br>
The last stable version for </span>2.6.22.19 was changeset 7328
(21.Mai.08)<br>
<br>
2.6.24.7 works with changeset 7348 as long as the CAM is not inserted.<br>
When I start "vdr" with the CAM plugged in, then the computer gets very
slow and I must do "init 6".<br>
<br>
Below you find /var/log/messages with the CAM inserted. Firstly, you
see logging while booting. Secondly, the logging when starting vdr.<br>
<br>
<small>/***********************************************************************
<br>
* I            Log while booting<br>
************************************************************************/<br>
<br>
</small>
<div class="moz-signature"><font size="-1"><span
 style="font-family: Adobe Helvetica;"></span><span
 style="font-family: Adobe Helvetica;"></span><span
 style="font-family: Adobe Helvetica;"></span></font><small> 20:34:27 
kernel: ACPI: PCI Interrupt 0000:02:01.0[A] -&gt; GSI 21 (level, low)
-&gt; IRQ 21<br>
 20:34:27  kernel: irq: 21, latency: 64<br>
 20:34:27  kernel:  memory: 0xdfeff000, mmio: 0xffffc2000006a000<br>
 20:34:27  kernel: found a VP-2033 PCI DVB-C device on (02:01.0),<br>
 20:34:27  kernel:     Mantis Rev 1 [1822:0008], irq: 21, latency: 64<br>
 20:34:27  kernel:     memory: 0xdfeff000, mmio: 0xffffc2000006a000<br>
 20:34:27  kernel:         mantis_i2c_write: Address=[0x50] &lt;W&gt;[
08 ]<br>
 20:34:27  kernel:         mantis_i2c_read:  Address=[0x50] &lt;R&gt;[
00 08 ca 19 e9 b6 ]<br>
 20:34:27  kernel:     MAC Address=[00:08:ca:19:e9:b6]<br>
 20:34:27  kernel: mantis_alloc_buffers (0): DMA=0x57150000
cpu=0xffff810057150000 size=65536<br>
 20:34:27  kernel: mantis_alloc_buffers (0): RISC=0x76432000
cpu=0xffff810076432000 size=1000<br>
 20:34:27  kernel: DVB: registering new adapter (Mantis dvb adapter)<br>
 20:34:27  kernel: mantis_frontend_init (0): Probing for CU1216 (DVB-C)<br>
 20:34:27  kernel:         mantis_i2c_write: Address=[0x50] &lt;W&gt;[
ff ]<br>
 20:34:27  kernel:         mantis_i2c_read:  Address=[0x50] &lt;R&gt;[
22 ]<br>
 20:34:27  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
1a ]<br>
 20:34:27  kernel:         mantis_i2c_read:  Address=[0x0c] &lt;R&gt;[
7c ]<br>
 20:34:27  kernel: TDA10021: i2c-addr = 0x0c, id = 0x7c<br>
 20:34:27  kernel: mantis_frontend_init (0): found Philips CU1216 DVB-C
frontend (TDA10021) @ 0x0c<br>
 20:34:27  kernel: mantis_frontend_init (0): Mantis DVB-C Philips
CU1216 frontend attach success<br>
 20:34:27  kernel: DVB: registering frontend 0 (Philips TDA10021
DVB-C)...<br>
 20:34:27  kernel: mantis_ca_init (0): Registering EN50221 device<br>
 20:34:27  kernel: mantis_ca_init (0): Registered EN50221 device<br>
 20:34:27  kernel: mantis_hif_init (0): Adapter(0) Initializing Mantis
Host Interface<br>
 20:34:28  gconfd (rudi-6693): GConf server is not in use, shutting
down.<br>
 20:34:28  gconfd (rudi-6693): Exiting<br>
 20:34:28  kernel: dvb_ca adapter 0: DVB CAM detected and initialised
successfully<br>
 20:34:29  kernel: ACPI: PCI interrupt for device 0000:02:02.0 disabled<br>
 20:34:29  kernel: ACPI: PCI Interrupt 0000:02:02.0[A] -&gt; GSI 22
(level, low) -&gt; IRQ 22<br>
 20:34:29  kernel: ice1724: Using board model M Audio Revolution-7.1<br>
 20:34:58  gconfd (rudi-8688): starting (version 2.20.0), pid 8688 user
'rudi'<br>
<br>
/***********************************************************************
<br>
* II            Start VDR<br>
************************************************************************/<br>
<br>
 
20:56:40  vdr: [18332] cTimeMs: using monotonic clock (resolution is
999848 ns)<br>
 20:56:40  vdr: [18332] VDR version 1.6.0-1 started<br>
 20:56:40  vdr: [18332] codeset is 'UTF-8' - known<br>
 20:56:40  vdr: [18332] ERROR: ./locale: Datei oder Verzeichnis nicht
gefunden<br>
 20:56:40  vdr: [18332] no locale for language code 'deu,ger'<br>
 20:56:40  vdr: [18332] loading plugin:
/GIGA1/SOURCES/DVB/VDR/vdr/PLUGINS/lib/libvdr-xineliboutput.so.1.6.0<br>
 20:56:40  vdr: [18332] loading /video/setup.conf<br>
 20:56:40  vdr: [18332] ERROR: unknown config parameter:
MenuButtonCloses = 0<br>
 20:56:40  vdr: [18332] unknown locale: '0'<br>
 20:56:40  vdr: [18332] ERROR: unknown config parameter: SortTimers = 1<br>
 20:56:40  vdr: [18332] loading /video/sources.conf<br>
 20:56:40  vdr: [18332] loading /video/diseqc.conf<br>
 20:56:40  vdr: [18332] loading /video/channels.conf<br>
 20:56:40  vdr: [18332] loading /video/timers.conf<br>
 20:56:40  vdr: [18332] loading /video/commands.conf<br>
 20:56:40  vdr: [18332] loading /video/svdrphosts.conf<br>
 20:56:40  vdr: [18332] loading /video/remote.conf<br>
 20:56:40  vdr: [18332] loading /video/keymacros.conf<br>
 20:56:40  vdr: [18333] video directory scanner thread started
(pid=18332, tid=18333)<br>
 20:56:40  vdr: [18333] video directory scanner thread ended
(pid=18332, tid=18333)<br>
 20:56:40  vdr: [18334] video directory scanner thread started
(pid=18332, tid=18334)<br>
 20:56:40  vdr: [18334] video directory scanner thread ended
(pid=18332, tid=18334)<br>
 20:56:40  vdr: [18332] reading EPG data from /video/epg.data<br>
 20:56:40  vdr: [18332] probing /dev/dvb/adapter0/frontend0<br>
 20:56:40  vdr: [18336] CI adapter on device 0 thread started
(pid=18332, tid=18336)<br>
 20:56:41  vdr: [18336] CAM 1: module present<br>
 20:56:42  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
00 dvb_ca adapter 0: DVB CAM detected and initialised successfully<br>
 20:56:42  vdr: [18336] CAM 1: module ready<br>
 20:56:44  kernel: mantis_ack_wait (0): Slave RACK Fail !<br>
 20:56:44  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x00, val == 0x73, ret == -121)<br>
 20:56:47  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
01 &lt;3&gt;mantis_ack_wait (0): Slave RACK Fail !<br>
 20:56:47  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x01, val == 0x6a, ret == -121)<br>
 20:56:49  vdr: [18336] CAM 1: AlphaCrypt Light, 01, 4A20, 4A20<br>
 20:56:50  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
02 &lt;3&gt;mantis_ack_wait (0): Slave RACK Fail !<br>
 20:56:50  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x02, val == 0x23, ret == -121)<br>
 20:56:53  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
03 &lt;3&gt;mantis_ack_wait (0): Slave RACK Fail !<br>
 20:56:53  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x03, val == 0x0a, ret == -121)<br>
 20:56:55  vdr: [18336] CAM 1: doesn't reply to QUERY - only a single
channel can be decrypted<br>
 20:56:56  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
04 &lt;3&gt;mantis_ack_wait (0): Slave RACK Fail !<br>
 20:56:56  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x04, val == 0x02, ret == -121)<br>
 20:56:59  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
05 &lt;3&gt;mantis_hif_write_wait (0): Adater(0) Slot(0): Write
operation timed out!<br>
 20:56:59  kernel: mantis_hif_write_iom (0): Adapter(0) Slot(0): HIF
Smart Buffer operation failed<br>
 20:56:59  kernel: dvb_ca adapter 0: CAM tried to send a buffer larger
than the link buffer size (512 &gt; 128)!<br>
 20:57:00  kernel: mantis_ack_wait (0): Slave RACK Fail !<br>
 20:57:00  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x05, val == 0x37, ret == -121)<br>
 20:57:00  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
06 &lt;3&gt;mantis_hif_write_wait (0): Adater(0) Slot(0): Write
operation timed out!<br>
 20:57:00  kernel: mantis_hif_write_iom (0): Adapter(0) Slot(0): HIF
Smart Buffer operation failed<br>
 20:57:00  kernel: dvb_ca adapter 0: DVB CAM link initialisation failed
:(<br>
 20:57:00  vdr: [18336] ERROR: can't write to CI adapter on device 0:
Ein-/Ausgabefehler der Gegenstelle (remote)<br>
 20:57:00  vdr: [18336] CAM 1: no module present<br>
 20:57:00  kernel: mantis_hif_write_wait (0): Adater(0) Slot(0): Write
operation timed out!<br>
 20:57:00  kernel: mantis_hif_write_iom (0): Adapter(0) Slot(0): HIF
Smart Buffer operation failed<br>
 20:57:04  kernel: mantis_ack_wait (0): Slave RACK Fail !<br>
 20:57:04  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x06, val == 0x77, ret == -121)<br>
 20:57:08  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
07 &lt;3&gt;mantis_ack_wait (0): Slave RACK Fail !<br>
 20:57:08  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x07, val == 0x1a, ret == -121)<br>
 20:57:12  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
08 &lt;3&gt;mantis_ack_wait (0): Slave RACK Fail !<br>
 20:57:12  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x08, val == 0x37, ret == -121)<br>
 20:57:16  kernel:         mantis_i2c_write: Address=[0x0c] &lt;W&gt;[
09 &lt;3&gt;mantis_ack_wait (0): Slave RACK Fail !<br>
 20:57:16  kernel: DVB: TDA10021(0): _tda10021_writereg, writereg error
(reg == 0x09, val == 0x6a, ret == -121)</small><br>
<br>
Please be so kind a and look into this.<br>
<br>
Ciao Ruediger <br>
<br>
<br>
<br>
</div>
</body>
</html>


--===============0248208159==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0248208159==--
