Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web84101.mail.mud.yahoo.com ([68.142.206.188])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <larrykathy3@verizon.net>) id 1Kwen0-000799-2F
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 16:22:54 +0100
Date: Sun, 2 Nov 2008 07:22:18 -0800 (PST)
From: Ruth Fernandez <larrykathy3@verizon.net>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <759163.14018.qm@web84101.mail.mud.yahoo.com>
Subject: [linux-dvb] Geniatech x8000 thriller
Reply-To: larrykathy3@verizon.net
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0166916438=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0166916438==
Content-Type: multipart/alternative; boundary="0-1849534484-1225639338=:14018"

--0-1849534484-1225639338=:14018
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I have a Geniatech x8000 thriller ATSC card. The only way Ubuntu will see i=
t is with the ismod option in the etc/modprobe.d/option file. The ATSC part=
 is not recognized. Plus there is no sound. Can you help. Larry -dmesg belo=
w

=A044.901324] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[=A0=A0 44.901560] cx88[0]: subsystem: 14f1:1419, board: Geniatech X8000-MT=
 DVBT [card=3D63,insmod option], frontend(s): 1
[=A0=A0 44.901565] cx88[0]: TV tuner type 71, Radio tuner type 0
[=A0=A0 44.981249] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[=A0=A0 45.164340] tuner' 1-0061: chip found @ 0xc2 (cx88[0])
[=A0=A0 45.681603] xc2028 1-0061: creating new instance
[=A0=A0 45.681609] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[=A0=A0 45.681618] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.=
fw
[=A0=A0 45.681631] cx88[0]/2: cx2388x 8802 Driver Manager
[=A0=A0 45.681658] ACPI: PCI Interrupt 0000:00:0c.2[A] -> GSI 16 (level, lo=
w) -> IRQ 19
[=A0=A0 45.681674] cx88[0]/2: found at 0000:00:0c.2, rev: 5, irq: 19, laten=
cy: 32, mmio: 0xf6000000
[=A0=A0 45.681698] cx8802_probe() allocating 1 frontend(s)
[=A0=A0 45.681904] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level, lo=
w) -> IRQ 19
[=A0=A0 45.681916] cx88[0]/0: found at 0000:00:0c.0, rev: 5, irq: 19, laten=
cy: 32, mmio: 0xf4000000
[=A0=A0 45.681985] cx88[0]/0: registered device video0 [v4l2]
[=A0=A0 45.682018] cx88[0]/0: registered device vbi0
[=A0=A0 45.682051] cx88[0]/0: registered device radio0
[=A0=A0 45.768992] cx88_dvb: Unknown parameter `card'
[=A0=A0 46.079711] NET: Registered protocol family 17
[=A0=A0 47.330152] xc2028 1-0061: Loading 80 firmware images from xc3028-v2=
7.fw, type: xc2028 firmware, ver 2.7
[=A0=A0 47.330337] cx88[0]: Calling XC2028/3028 callback
[=A0=A0 47.530494] xc2028 1-0061: Loading firmware for type=3DBASE MTS (5),=
 id 0000000000000000.
[=A0=A0 47.530502] cx88[0]: Calling XC2028/3028 callback
[=A0=A0 49.042136] xc2028 1-0061: Loading firmware for type=3DMTS (4), id 0=
00000000000b700.
[=A0=A0 49.064305] xc2028 1-0061: Loading SCODE for type=3DMTS LCD NOGD MON=
O IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[=A0=A0 49.099919] xc2028 1-0061: Incorrect readback of firmware version.
[=A0=A0 49.158010] cx88[0]: Calling XC2028/3028 callback
[=A0=A0 49.361081] xc2028 1-0061: Loading firmware for type=3DBASE MTS (5),=
 id 0000000000000000.
[=A0=A0 49.361089] cx88[0]: Calling XC2028/3028 callback
[=A0=A0 50.860783] xc2028 1-0061: Loading firmware for type=3DMTS (4), id 0=
00000000000b700.
[=A0=A0 50.882947] xc2028 1-0061: Loading SCODE for type=3DMTS LCD NOGD MON=
O IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[=A0=A0 50.966673] cx88[0]: Calling XC2028/3028 callback
[=A0=A0 51.086790] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, lo=
w) -> IRQ 20
[=A0=A0 51.086954] PCI: Setting latency timer of device 0000:00:11.5 to 64
[=A0=A0 52.489700] loop: module loaded
[=A0=A0 52.514208] lp0: using parport0 (interrupt-driven).
[=A0=A0 52.614795] Adding 6072528k swap on /dev/sdb5.=A0 Priority:-1 extent=
s:1 across:6072528k
[=A0=A0 53.177612] EXT3 FS on sdb1, internal journal
[=A0=A0 53.741721] NET: Registered protocol family 10
[=A0=A0 53.742225] lo: Disabled Privacy Extensions
[=A0=A0 54.549762] ip_tables: (C) 2000-2006 Netfilter Core Team
[=A0=A0 55.028420] No dock devices found.
[=A0=A0 56.643293] capifs: Rev 1.1.2.3
[=A0=A0 58.230204] audit(1225633869.241:2): type=3D1503 operation=3D"capabl=
e" name=3D"sys_resource" pid=3D5164 profile=3D"/usr/sbin/named" namespace=
=3D"default"
[=A0=A0 60.296371] apm: BIOS not found.
[=A0=A0 60.865343] ppdev: user-space parallel port driver
[=A0=A0 60.960941] audit(1225633871.973:3): type=3D1503 operation=3D"inode_=
permission" requested_mask=3D"a::" denied_mask=3D"a::" name=3D"/dev/tty" pi=
d=3D5421 profile=3D"/usr/sbin/cupsd" namespace=3D"default"
[=A0=A0 63.502560] cx88[0]: Calling XC2028/3028 callback
[=A0=A0 63.702671] xc2028 1-0061: Loading firmware for type=3DBASE FM (401)=
, id 0000000000000000.
[=A0=A0 63.702681] cx88[0]: Calling XC2028/3028 callback
[=A0=A0 63.767201] eth0: no IPv6 routers present
[=A0=A0 65.190478] xc2028 1-0061: Loading firmware for type=3DFM (400), id =
0000000000000000.



--0-1849534484-1225639338=:14018
Content-Type: text/html; charset=us-ascii

<table cellspacing="0" cellpadding="0" border="0" ><tr><td valign="top" style="font: inherit;">I have a Geniatech x8000 thriller ATSC card. The only way Ubuntu will see it is with the ismod option in the etc/modprobe.d/option file. The ATSC part is not recognized. Plus there is no sound. Can you help. Larry -dmesg below<br><br>&nbsp;44.901324] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded<br>[&nbsp;&nbsp; 44.901560] cx88[0]: subsystem: 14f1:1419, board: Geniatech X8000-MT DVBT [card=63,insmod option], frontend(s): 1<br>[&nbsp;&nbsp; 44.901565] cx88[0]: TV tuner type 71, Radio tuner type 0<br>[&nbsp;&nbsp; 44.981249] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded<br>[&nbsp;&nbsp; 45.164340] tuner' 1-0061: chip found @ 0xc2 (cx88[0])<br>[&nbsp;&nbsp; 45.681603] xc2028 1-0061: creating new instance<br>[&nbsp;&nbsp; 45.681609] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner<br>[&nbsp;&nbsp; 45.681618] cx88[0]: Asking xc2028/3028 to load
 firmware xc3028-v27.fw<br>[&nbsp;&nbsp; 45.681631] cx88[0]/2: cx2388x 8802 Driver Manager<br>[&nbsp;&nbsp; 45.681658] ACPI: PCI Interrupt 0000:00:0c.2[A] -&gt; GSI 16 (level, low) -&gt; IRQ 19<br>[&nbsp;&nbsp; 45.681674] cx88[0]/2: found at 0000:00:0c.2, rev: 5, irq: 19, latency: 32, mmio: 0xf6000000<br>[&nbsp;&nbsp; 45.681698] cx8802_probe() allocating 1 frontend(s)<br>[&nbsp;&nbsp; 45.681904] ACPI: PCI Interrupt 0000:00:0c.0[A] -&gt; GSI 16 (level, low) -&gt; IRQ 19<br>[&nbsp;&nbsp; 45.681916] cx88[0]/0: found at 0000:00:0c.0, rev: 5, irq: 19, latency: 32, mmio: 0xf4000000<br>[&nbsp;&nbsp; 45.681985] cx88[0]/0: registered device video0 [v4l2]<br>[&nbsp;&nbsp; 45.682018] cx88[0]/0: registered device vbi0<br>[&nbsp;&nbsp; 45.682051] cx88[0]/0: registered device radio0<br>[&nbsp;&nbsp; 45.768992] cx88_dvb: Unknown parameter `card'<br>[&nbsp;&nbsp; 46.079711] NET: Registered protocol family 17<br>[&nbsp;&nbsp; 47.330152] xc2028 1-0061: Loading 80 firmware
 images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7<br>[&nbsp;&nbsp; 47.330337] cx88[0]: Calling XC2028/3028 callback<br>[&nbsp;&nbsp; 47.530494] xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.<br>[&nbsp;&nbsp; 47.530502] cx88[0]: Calling XC2028/3028 callback<br>[&nbsp;&nbsp; 49.042136] xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.<br>[&nbsp;&nbsp; 49.064305] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.<br>[&nbsp;&nbsp; 49.099919] xc2028 1-0061: Incorrect readback of firmware version.<br>[&nbsp;&nbsp; 49.158010] cx88[0]: Calling XC2028/3028 callback<br>[&nbsp;&nbsp; 49.361081] xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.<br>[&nbsp;&nbsp; 49.361089] cx88[0]: Calling XC2028/3028 callback<br>[&nbsp;&nbsp; 50.860783] xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.<br>[&nbsp;&nbsp;
 50.882947] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.<br>[&nbsp;&nbsp; 50.966673] cx88[0]: Calling XC2028/3028 callback<br>[&nbsp;&nbsp; 51.086790] ACPI: PCI Interrupt 0000:00:11.5[C] -&gt; GSI 22 (level, low) -&gt; IRQ 20<br>[&nbsp;&nbsp; 51.086954] PCI: Setting latency timer of device 0000:00:11.5 to 64<br>[&nbsp;&nbsp; 52.489700] loop: module loaded<br>[&nbsp;&nbsp; 52.514208] lp0: using parport0 (interrupt-driven).<br>[&nbsp;&nbsp; 52.614795] Adding 6072528k swap on /dev/sdb5.&nbsp; Priority:-1 extents:1 across:6072528k<br>[&nbsp;&nbsp; 53.177612] EXT3 FS on sdb1, internal journal<br>[&nbsp;&nbsp; 53.741721] NET: Registered protocol family 10<br>[&nbsp;&nbsp; 53.742225] lo: Disabled Privacy Extensions<br>[&nbsp;&nbsp; 54.549762] ip_tables: (C) 2000-2006 Netfilter Core Team<br>[&nbsp;&nbsp; 55.028420] No dock devices found.<br>[&nbsp;&nbsp; 56.643293] capifs: Rev
 1.1.2.3<br>[&nbsp;&nbsp; 58.230204] audit(1225633869.241:2): type=1503 operation="capable" name="sys_resource" pid=5164 profile="/usr/sbin/named" namespace="default"<br>[&nbsp;&nbsp; 60.296371] apm: BIOS not found.<br>[&nbsp;&nbsp; 60.865343] ppdev: user-space parallel port driver<br>[&nbsp;&nbsp; 60.960941] audit(1225633871.973:3): type=1503 operation="inode_permission" requested_mask="a::" denied_mask="a::" name="/dev/tty" pid=5421 profile="/usr/sbin/cupsd" namespace="default"<br>[&nbsp;&nbsp; 63.502560] cx88[0]: Calling XC2028/3028 callback<br>[&nbsp;&nbsp; 63.702671] xc2028 1-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.<br>[&nbsp;&nbsp; 63.702681] cx88[0]: Calling XC2028/3028 callback<br>[&nbsp;&nbsp; 63.767201] eth0: no IPv6 routers present<br>[&nbsp;&nbsp; 65.190478] xc2028 1-0061: Loading firmware for type=FM (400), id 0000000000000000.<br><br><br></td></tr></table>
--0-1849534484-1225639338=:14018--


--===============0166916438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0166916438==--
