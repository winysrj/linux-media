Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <altair79@gmail.com>) id 1JZk1x-0003iX-3v
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 10:47:23 +0100
Received: by wf-out-1314.google.com with SMTP id 28so3370274wfa.17
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 02:47:15 -0700 (PDT)
Message-ID: <26c9bbd40803130247n300b435ck6b1156b8edb24b5c@mail.gmail.com>
Date: Thu, 13 Mar 2008 11:47:14 +0200
From: Altair <altair79@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Problem with new Terratec Cinergy C
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2040380499=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2040380499==
Content-Type: multipart/alternative;
	boundary="----=_Part_10552_19029062.1205401635462"

------=_Part_10552_19029062.1205401635462
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello.

I've been running a MythTV-box on top of Ubuntun Feisty for a year now
without a hitch, using Technotrend C-1500 Budget card. Now I bought the new
Terratec Cinergy C and installed the Mantis drivers I got from
http://jusst.de/hg/mantis/summary. After this I got everything working fine
in my Myth, but after a few days I there appeared to be a pattern where the
whole machine just stops responding. This occurs every 12-24 hours and the
source of it is quite hard to make out because obviously theres nothing in
the logs.

I have tried with another Cinergy-card but the result is the same, it can't
be a hardware problem. I dunno if the problem is the driver of the cinergy
or perhaps the installation of mantis somehow broke the TT-card..

Help would be much appreaciated.

Here's dmeg from the box.

[   30.139218] i2c_adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[   30.139267] i2c_adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[   30.200008] saa7146: register extension 'budget_ci dvb'.
[   30.200624] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   30.200636] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI 17
(lev
el, low) -> IRQ 17
[   30.200665] saa7146: found saa7146 @ mem ffffc2000007a000 (revision 1,
irq 17
) (0x13c2,0x1010).
[   30.200673] saa7146 (0): dma buffer size 192512
[   30.200676] DVB: registering new adapter (TT-Budget-C-CI PCI)
[   30.207133] lirc_dev: IR Remote Control driver registered, at major 61
[   30.220252] lirc_mceusb2: no version for "lirc_get_pdata" found: kernel
taint
ed.
[   30.220817]
[   30.220818] lirc_mceusb2: Philips eHome USB IR Transciever and Microsoft
MCE
2005 Remote Control driver for LIRC $Revision: 1.25 $
[   30.220822] lirc_mceusb2: Daniel Melander <lirc@rajidae.se>, Martin
Blatter <
martin_a_blatter@yahoo.com>
[   30.246198] adapter has MAC addr = 00:d0:5c:67:c3:51
[   30.246541] input: Budget-CI dvb ir receiver saa7146 (0) as
/class/input/inpu
t2
[   30.395167] input: PC Speaker as /class/input/input3
[   30.397327] DVB: registering frontend 0 (ST STV0297 DVB-C)...
[   30.398064] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[   30.398075] ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC1] -> GSI 16
(lev
el, low) -> IRQ 16
[   30.398102] irq: 16, latency: 32
[   30.398103]  memory: 0xfdaff000, mmio: 0xffffc2000007c000
[   30.398106] found a VP-2040 PCI DVB-C device on (04:08.0),
[   30.398108]     Mantis Rev 1 [153b:1178], irq: 16, latency: 32
[   30.398112]     memory: 0xfdaff000, mmio: 0xffffc2000007c000
[   30.401025]     MAC Address=[00:08:ca:1c:76:40]
[   30.401103] mantis_alloc_buffers (0): DMA=0x35200000
cpu=0xffff810035200000 s
ize=65536
[   30.401111] mantis_alloc_buffers (0): RISC=0x37514000
cpu=0xffff810037514000
size=1000
[   30.401115] DVB: registering new adapter (Mantis dvb adapter)
[   30.402068] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[   30.402072] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APC7] -> GSI 16
(lev
el, low) -> IRQ 16
[   30.402081] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   30.414831] hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache,
UDMA(66
)
[   30.414839] Uniform CD-ROM driver Revision: 3.20
[   30.461051] usb 2-4: reset full speed USB device using ohci_hcd and
address 2
[   30.487089] parport: PnPBIOS parport detected.
[   30.487121] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   30.692119] lirc_dev: lirc_register_plugin: sample_rate: 0
[   30.696827] lirc_mceusb2[2]: Philips eHome Infrared Transceiver on usb2:2
[   30.696863] usbcore: registered new interface driver lirc_mceusb2
[   30.952465] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[   30.954581] mantis_frontend_init (0): found Philips CU1216 DVB-C frontend
(TD
A10023) @ 0x0c
[   30.954584] mantis_frontend_init (0): Mantis DVB-C Philips CU1216
frontend at
tach success
[   30.954590] DVB: registering frontend 1 (Philips TDA10023 DVB-C)...
[   30.954776] NVRM: loading NVIDIA Linux x86_64 Kernel Module  1.0-9631
Thu No
v  9 17:35:27 PST 2006
[   30.956655] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   30.956661] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22
(lev
el, low) -> IRQ 22
[   30.956683] PCI: Setting latency timer of device 0000:00:10.1 to 64
[   31.512368] lp0: using parport0 (interrupt-driven).
[   31.579263] /home/user/imon/imon_vfd.c: Driver for Soundgraph iMON VFD,
v0.
1a1
[   31.579267] /home/user/imon/imon_vfd.c: Venky Raju <dev@venky.ws>
[   31.632597] /home/user/imon/imon_vfd.c: imon_probe: found IMON device
[   31.634115] /home/user/imon/imon_vfd.c: imon_probe: iMON device on
usb<2:3>
 initialized
[   31.634135] usbcore: registered new interface driver imon
[   38.091485] mantis_ack_wait (0): Slave RACK Fail !
[   38.161365] it87: Found IT8716F chip at 0x290, revision 1
[   38.161376] it87: in3 is VCC (+5V)
[   38.161377] it87: in7 is VCCH (+5V Stand-By)
[   38.313108] Adding 1951888k swap on
/dev/disk/by-uuid/3aa3c26c-72d8-48e1-9811
-0381f0a69f84.  Priority:-1 extents:1 across:1951888k
[   38.464543] EXT3 FS on sda1, internal journal
[   38.788755] NET: Registered protocol family 10
[   38.788858] lo: Disabled Privacy Extensions
[   39.074026] kjournald starting.  Commit interval 5 seconds
[   39.074325] EXT3 FS on sda3, internal journal
[   39.074329] EXT3-fs: mounted filesystem with ordered data mode.
[  166.753898] mantis start feed & dma
[  166.754125] mantis stop feed and dma
[  166.759769] mantis start feed & dma
[  471.590289] mantis stop feed and dma
[  471.731867] mantis start feed & dma
[  776.752261] mantis stop feed and dma
[  776.828644] mantis start feed & dma
[ 1081.866319] mantis stop feed and dma
[ 1081.944235] mantis start feed & dma
[ 1386.916520] mantis stop feed and dma
[ 1386.989831] mantis start feed & dma


I'm using the EIT-info, so MythTV is doing this EITScanner quite often to
check for new channel-info, so that may be the root of the problem.

Here's a log from mythbackend.log just before the machine once again stopped
responding:

2008-03-13 07:22:17.810 Reschedule requested for id -1.
2008-03-13 07:22:17.844 Scheduled 12 items in 0.0 = 0.01 match + 0.02 place
2008-03-13 07:22:17.848 scheduler: Last message repeated 3 times: Scheduled
item
s: Scheduled 12 items in 0.0 = 0.02 match + 0.02 place
2008-03-13 07:22:17.852 scheduler: Scheduled items: Scheduled 12 items in
0.0 =
0.01 match + 0.02 place
2008-03-13 07:22:47.305 EITScanner: Added 303 EIT Events
2008-03-13 07:23:16.931 DVBTuning Warning: Invalid inversion, aborting,
falling
back to 'auto'
2008-03-13 07:23:17.584 EITScanner: Now looking for EIT data on multiplex of
cha
nnel 3
2008-03-13 07:25:53.206 EITScanner: Added 1 EIT Events
2008-03-13 07:25:53.213 Reschedule requested for id -1.
2008-03-13 07:25:53.249 Scheduled 12 items in 0.0 = 0.02 match + 0.02 place
2008-03-13 07:25:53.253 scheduler: Scheduled items: Scheduled 12 items in
0.0 =
0.02 match + 0.02 place


Br, Jarno

------=_Part_10552_19029062.1205401635462
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello.<br><br>I&#39;ve been running a MythTV-box on top of Ubuntun Feisty for a year now without a hitch, using Technotrend C-1500 Budget card. Now I bought the new Terratec Cinergy C and installed the Mantis drivers I got from <a href="http://jusst.de/hg/mantis/summary">http://jusst.de/hg/mantis/summary</a>. After this I got everything working fine in my Myth, but after a few days I there appeared to be a pattern where the whole machine just stops responding. This occurs every 12-24 hours and the source of it is quite hard to make out because obviously theres nothing in the logs. <br>
<br>I have tried with another Cinergy-card but the result is the same, it can&#39;t be a hardware problem. I dunno if the problem is the driver of the cinergy or perhaps the installation of mantis somehow broke the TT-card.. <br>
<br>Help would be much appreaciated. <br><br>Here&#39;s dmeg from the box.<br><br>[&nbsp;&nbsp; 30.139218] i2c_adapter i2c-0: nForce2 SMBus adapter at 0x4c00<br>[&nbsp;&nbsp; 30.139267] i2c_adapter i2c-1: nForce2 SMBus adapter at 0x4c40<br>[&nbsp;&nbsp; 30.200008] saa7146: register extension &#39;budget_ci dvb&#39;.<br>
[&nbsp;&nbsp; 30.200624] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17<br>[&nbsp;&nbsp; 30.200636] ACPI: PCI Interrupt 0000:04:09.0[A] -&gt; Link [APC2] -&gt; GSI 17 (lev<br>el, low) -&gt; IRQ 17<br>[&nbsp;&nbsp; 30.200665] saa7146: found saa7146 @ mem ffffc2000007a000 (revision 1, irq 17<br>
) (0x13c2,0x1010).<br>[&nbsp;&nbsp; 30.200673] saa7146 (0): dma buffer size 192512<br>[&nbsp;&nbsp; 30.200676] DVB: registering new adapter (TT-Budget-C-CI PCI)<br>[&nbsp;&nbsp; 30.207133] lirc_dev: IR Remote Control driver registered, at major 61<br>
[&nbsp;&nbsp; 30.220252] lirc_mceusb2: no version for &quot;lirc_get_pdata&quot; found: kernel taint<br>ed.<br>[&nbsp;&nbsp; 30.220817]<br>[&nbsp;&nbsp; 30.220818] lirc_mceusb2: Philips eHome USB IR Transciever and Microsoft MCE<br>2005 Remote Control driver for LIRC $Revision: 1.25 $<br>
[&nbsp;&nbsp; 30.220822] lirc_mceusb2: Daniel Melander &lt;<a href="mailto:lirc@rajidae.se">lirc@rajidae.se</a>&gt;, Martin Blatter &lt;<br><a href="mailto:martin_a_blatter@yahoo.com">martin_a_blatter@yahoo.com</a>&gt;<br>[&nbsp;&nbsp; 30.246198] adapter has MAC addr = 00:d0:5c:67:c3:51<br>
[&nbsp;&nbsp; 30.246541] input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/inpu<br>t2<br>[&nbsp;&nbsp; 30.395167] input: PC Speaker as /class/input/input3<br>[&nbsp;&nbsp; 30.397327] DVB: registering frontend 0 (ST STV0297 DVB-C)...<br>[&nbsp;&nbsp; 30.398064] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16<br>
[&nbsp;&nbsp; 30.398075] ACPI: PCI Interrupt 0000:04:08.0[A] -&gt; Link [APC1] -&gt; GSI 16 (lev<br>el, low) -&gt; IRQ 16<br>[&nbsp;&nbsp; 30.398102] irq: 16, latency: 32<br>[&nbsp;&nbsp; 30.398103]&nbsp; memory: 0xfdaff000, mmio: 0xffffc2000007c000<br>[&nbsp;&nbsp; 30.398106] found a VP-2040 PCI DVB-C device on (04:08.0),<br>
[&nbsp;&nbsp; 30.398108]&nbsp;&nbsp;&nbsp;&nbsp; Mantis Rev 1 [153b:1178], irq: 16, latency: 32<br>[&nbsp;&nbsp; 30.398112]&nbsp;&nbsp;&nbsp;&nbsp; memory: 0xfdaff000, mmio: 0xffffc2000007c000<br>[&nbsp;&nbsp; 30.401025]&nbsp;&nbsp;&nbsp;&nbsp; MAC Address=[00:08:ca:1c:76:40]<br>[&nbsp;&nbsp; 30.401103] mantis_alloc_buffers (0): DMA=0x35200000 cpu=0xffff810035200000 s<br>
ize=65536<br>[&nbsp;&nbsp; 30.401111] mantis_alloc_buffers (0): RISC=0x37514000 cpu=0xffff810037514000<br>size=1000<br>[&nbsp;&nbsp; 30.401115] DVB: registering new adapter (Mantis dvb adapter)<br>[&nbsp;&nbsp; 30.402068] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16<br>
[&nbsp;&nbsp; 30.402072] ACPI: PCI Interrupt 0000:00:05.0[A] -&gt; Link [APC7] -&gt; GSI 16 (lev<br>el, low) -&gt; IRQ 16<br>[&nbsp;&nbsp; 30.402081] PCI: Setting latency timer of device 0000:00:05.0 to 64<br>[&nbsp;&nbsp; 30.414831] hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66<br>
)<br>[&nbsp;&nbsp; 30.414839] Uniform CD-ROM driver Revision: 3.20<br>[&nbsp;&nbsp; 30.461051] usb 2-4: reset full speed USB device using ohci_hcd and address 2<br>[&nbsp;&nbsp; 30.487089] parport: PnPBIOS parport detected.<br>[&nbsp;&nbsp; 30.487121] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]<br>
[&nbsp;&nbsp; 30.692119] lirc_dev: lirc_register_plugin: sample_rate: 0<br>[&nbsp;&nbsp; 30.696827] lirc_mceusb2[2]: Philips eHome Infrared Transceiver on usb2:2<br>[&nbsp;&nbsp; 30.696863] usbcore: registered new interface driver lirc_mceusb2<br>[&nbsp;&nbsp; 30.952465] mantis_frontend_init (0): Probing for CU1216 (DVB-C)<br>
[&nbsp;&nbsp; 30.954581] mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TD<br>A10023) @ 0x0c<br>[&nbsp;&nbsp; 30.954584] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend at<br>tach success<br>[&nbsp;&nbsp; 30.954590] DVB: registering frontend 1 (Philips TDA10023 DVB-C)...<br>
[&nbsp;&nbsp; 30.954776] NVRM: loading NVIDIA Linux x86_64 Kernel Module&nbsp; 1.0-9631&nbsp; Thu No<br>v&nbsp; 9 17:35:27 PST 2006<br>[&nbsp;&nbsp; 30.956655] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22<br>[&nbsp;&nbsp; 30.956661] ACPI: PCI Interrupt 0000:00:10.1[B] -&gt; Link [AAZA] -&gt; GSI 22 (lev<br>
el, low) -&gt; IRQ 22<br>[&nbsp;&nbsp; 30.956683] PCI: Setting latency timer of device 0000:00:10.1 to 64<br>[&nbsp;&nbsp; 31.512368] lp0: using parport0 (interrupt-driven).<br>[&nbsp;&nbsp; 31.579263] /home/user/imon/imon_vfd.c: Driver for Soundgraph iMON VFD, v0.<br>
1a1<br>[&nbsp;&nbsp; 31.579267] /home/user/imon/imon_vfd.c: Venky Raju &lt;<a href="mailto:dev@venky.ws">dev@venky.ws</a>&gt;<br>[&nbsp;&nbsp; 31.632597] /home/user/imon/imon_vfd.c: imon_probe: found IMON device<br>[&nbsp;&nbsp; 31.634115] /home/user/imon/imon_vfd.c: imon_probe: iMON device on usb&lt;2:3&gt;<br>
&nbsp;initialized<br>[&nbsp;&nbsp; 31.634135] usbcore: registered new interface driver imon<br>[&nbsp;&nbsp; 38.091485] mantis_ack_wait (0): Slave RACK Fail !<br>[&nbsp;&nbsp; 38.161365] it87: Found IT8716F chip at 0x290, revision 1<br>[&nbsp;&nbsp; 38.161376] it87: in3 is VCC (+5V)<br>
[&nbsp;&nbsp; 38.161377] it87: in7 is VCCH (+5V Stand-By)<br>[&nbsp;&nbsp; 38.313108] Adding 1951888k swap on /dev/disk/by-uuid/3aa3c26c-72d8-48e1-9811<br>-0381f0a69f84.&nbsp; Priority:-1 extents:1 across:1951888k<br>[&nbsp;&nbsp; 38.464543] EXT3 FS on sda1, internal journal<br>
[&nbsp;&nbsp; 38.788755] NET: Registered protocol family 10<br>[&nbsp;&nbsp; 38.788858] lo: Disabled Privacy Extensions<br>[&nbsp;&nbsp; 39.074026] kjournald starting.&nbsp; Commit interval 5 seconds<br>[&nbsp;&nbsp; 39.074325] EXT3 FS on sda3, internal journal<br>[&nbsp;&nbsp; 39.074329] EXT3-fs: mounted filesystem with ordered data mode.<br>
[&nbsp; 166.753898] mantis start feed &amp; dma<br>[&nbsp; 166.754125] mantis stop feed and dma<br>[&nbsp; 166.759769] mantis start feed &amp; dma<br>[&nbsp; 471.590289] mantis stop feed and dma<br>[&nbsp; 471.731867] mantis start feed &amp; dma<br>
[&nbsp; 776.752261] mantis stop feed and dma<br>[&nbsp; 776.828644] mantis start feed &amp; dma<br>[ 1081.866319] mantis stop feed and dma<br>[ 1081.944235] mantis start feed &amp; dma<br>[ 1386.916520] mantis stop feed and dma<br>
[ 1386.989831] mantis start feed &amp; dma<br><br><br>I&#39;m using the EIT-info, so MythTV is doing this EITScanner quite often to check for new channel-info, so that may be the root of the problem.<br><br>Here&#39;s a log from mythbackend.log just before the machine once again stopped responding:<br>
<br>2008-03-13 07:22:17.810 Reschedule requested for id -1.<br>2008-03-13 07:22:17.844 Scheduled 12 items in 0.0 = 0.01 match + 0.02 place<br>2008-03-13 07:22:17.848 scheduler: Last message repeated 3 times: Scheduled item<br>
s: Scheduled 12 items in 0.0 = 0.02 match + 0.02 place<br>2008-03-13 07:22:17.852 scheduler: Scheduled items: Scheduled 12 items in 0.0 =<br>0.01 match + 0.02 place<br>2008-03-13 07:22:47.305 EITScanner: Added 303 EIT Events<br>
2008-03-13 07:23:16.931 DVBTuning Warning: Invalid inversion, aborting, falling<br>back to &#39;auto&#39;<br>2008-03-13 07:23:17.584 EITScanner: Now looking for EIT data on multiplex of cha<br>nnel 3<br>2008-03-13 07:25:53.206 EITScanner: Added 1 EIT Events<br>
2008-03-13 07:25:53.213 Reschedule requested for id -1.<br>2008-03-13 07:25:53.249 Scheduled 12 items in 0.0 = 0.02 match + 0.02 place<br>2008-03-13 07:25:53.253 scheduler: Scheduled items: Scheduled 12 items in 0.0 =<br>
0.02 match + 0.02 place<br><br><br>Br, Jarno<br><br> 

------=_Part_10552_19029062.1205401635462--


--===============2040380499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2040380499==--
