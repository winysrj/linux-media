Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from diyefi.co.uk ([207.192.70.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stuart@stu.org.uk>) id 1KjEA3-0006ka-IL
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 16:19:12 +0200
Received: from [192.168.0.5] (host-84-9-158-153.dslgb.com [84.9.158.153])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by diyefi.co.uk (Postfix) with ESMTPSA id 19C7514F8C
	for <linux-dvb@linuxtv.org>; Fri, 26 Sep 2008 15:18:54 +0100 (BST)
Message-ID: <48DCEF6D.6030407@stu.org.uk>
Date: Fri, 26 Sep 2008 15:19:25 +0100
From: Stuart Johnson <stuart@stu.org.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] FATAL: Error inserting cx88_dvb
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0982841596=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0982841596==
Content-Type: multipart/alternative;
 boundary="------------000603000007010508030403"

This is a multi-part message in MIME format.
--------------000603000007010508030403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have 2 x WinTV-HS-S2 DVB-S & a Nebula DVB-T PCI adaptors.
I am only getting the frontend on the DVB-T


#modprobe -i cx88-dvb
FATAL: Error inserting cx88_dvb 
(/lib/modules/2.6.26.1/kernel/drivers/media/video/cx88/cx88-dvb.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)

#dmesg
Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
PCI: Disallowing DAC for device 0000:00:0a.0
eth0: Tigon3 [partno(284685-003) rev 0105 PHY(5701)] (PCI:33MHz:32-bit) 
10/100/1000Base-T Ethernet 00:0f:20:d7:1d:2c
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff000f] dma_mask[32-bit]
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:00:09.0, irq: 3, latency: 32, mmio: 0xf9000000
bttv0: detected: Nebula Electronics DigiTV [card=104], PCI subsystem ID 
is 0071:0101
bttv0: using: Nebula Electronics DigiTV [card=104,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ff00cb [init]
bttv0: tuner absent
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bttv0: add subdevice "dvb0"
input: bttv IR (card=104) as /devices/pci0000:00/0000:00:09.0/input/input1
cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) 
DVB-S/S2 [card=69,autodetected]
cx88[0]: TV tuner type -1, Radio tuner type -1
bt878: gave up waiting for init of module bttv.
bt878: Unknown symbol bttv_read_gpio
bt878: gave up waiting for init of module bttv.
bt878: Unknown symbol bttv_write_gpio
Filesystem "md4": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md4
Ending clean XFS mount for filesystem: md4
XFS mounting filesystem hde1
Ending clean XFS mount for filesystem: hde1
XFS mounting filesystem hdg1
Ending clean XFS mount for filesystem: hdg1
Adding 240888k swap on /dev/md2.  Priority:-1 extents:1 across:240888k
hda: UDMA/100 mode selected
hdc: UDMA/100 mode selected
hde: UDMA/100 mode selected
hdg: UDMA/100 mode selected
bt878: gave up waiting for init of module bttv.
bt878: Unknown symbol bttv_gpio_enable
tveeprom 2-0050: Hauppauge model 69100, rev B2C3, serial# 3247319
tveeprom 2-0050: MAC address is 00-0D-FE-31-8C-D7
tveeprom 2-0050: tuner model is Conexant CX24118A (idx 123, type 4)
tveeprom 2-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 2-0050: audio processor is None (idx 0)
tveeprom 2-0050: decoder processor is CX882 (idx 25)
tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=69100
input: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:0b.0/input/input2
cx88[0]/0: found at 0000:00:0b.0, rev: 5, irq: 10, latency: 32, mmio: 
0xf5000000
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi1
cx88[0]/2: cx2388x 8802 Driver Manager
cx88[0]/2: found at 0000:00:0b.2, rev: 5, irq: 10, latency: 32, mmio: 
0xf3000000
udev: renamed network interface eth0 to eth1
cx88[1]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) 
DVB-S/S2 [card=69,autodetected]
cx88[1]: TV tuner type -1, Radio tuner type -1
tveeprom 3-0050: Hauppauge model 69100, rev B2C3, serial# 3247400
tveeprom 3-0050: MAC address is 00-0D-FE-31-8D-28
tveeprom 3-0050: tuner model is Conexant CX24118A (idx 123, type 4)
tveeprom 3-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 3-0050: audio processor is None (idx 0)
tveeprom 3-0050: decoder processor is CX882 (idx 25)
tveeprom 3-0050: has no radio, has IR receiver, has no IR transmitter
cx88[1]: hauppauge eeprom: model=69100
input: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:0d.0/input/input3
cx88[1]/0: found at 0000:00:0d.0, rev: 5, irq: 3, latency: 32, mmio: 
0xf0000000
cx88[1]/0: registered device video2 [v4l2]
cx88[1]/0: registered device vbi2
cx88[1]/2: cx2388x 8802 Driver Manager
cx88[1]/2: found at 0000:00:0d.2, rev: 5, irq: 3, latency: 32, mmio: 
0xee000000
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
bt878_probe: card id=[0x1010071],[ Nebula Electronics DigiTV ] has DVB 
functions.
bt878(0): Bt878 (rev 17) at 00:09.1, irq: 3, latency: 32, memory: 0xf8800000
DVB: registering new adapter (bttv0)
cx88_dvb: Unknown parameter `frontend'
DVB: registering frontend 0 (NxtWave NXT6000 DVB-T)...
cx88_dvb: Unknown parameter `frontend'



--------------000603000007010508030403
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Courier New">I have 2 x WinTV-HS-S2 DVB-S &amp; a Nebula
DVB-T PCI adaptors.<br>
I am only getting the frontend on the DVB-T<br>
<br>
<br>
#modprobe -i cx88-dvb<br>
FATAL: Error inserting cx88_dvb
(/lib/modules/2.6.26.1/kernel/drivers/media/video/cx88/cx88-dvb.ko):
Unknown symbol in module, or unknown parameter (see dmesg)<br>
<br>
#dmesg<br>
Linux video capture interface: v2.00<br>
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded<br>
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded<br>
bttv: driver version 0.9.17 loaded<br>
bttv: using 8 buffers with 2080k (520 pages) each for capture<br>
PCI: Disallowing DAC for device 0000:00:0a.0<br>
eth0: Tigon3 [partno(284685-003) rev 0105 PHY(5701)] (PCI:33MHz:32-bit)
10/100/1000Base-T Ethernet 00:0f:20:d7:1d:2c<br>
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]<br>
eth0: dma_rwctrl[76ff000f] dma_mask[32-bit]<br>
bttv: Bt8xx card found (0).<br>
bttv0: Bt878 (rev 17) at 0000:00:09.0, irq: 3, latency: 32, mmio:
0xf9000000<br>
bttv0: detected: Nebula Electronics DigiTV [card=104], PCI subsystem ID
is 0071:0101<br>
bttv0: using: Nebula Electronics DigiTV [card=104,autodetected]<br>
bttv0: gpio: en=00000000, out=00000000 in=00ff00cb [init]<br>
bttv0: tuner absent<br>
bttv0: registered device video0<br>
bttv0: registered device vbi0<br>
bttv0: PLL: 28636363 =&gt; 35468950 .. ok<br>
bttv0: add subdevice "dvb0"<br>
input: bttv IR (card=104) as
/devices/pci0000:00/0000:00:09.0/input/input1<br>
cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite)
DVB-S/S2 [card=69,autodetected]<br>
cx88[0]: TV tuner type -1, Radio tuner type -1<br>
bt878: gave up waiting for init of module bttv.<br>
bt878: Unknown symbol bttv_read_gpio<br>
bt878: gave up waiting for init of module bttv.<br>
bt878: Unknown symbol bttv_write_gpio<br>
Filesystem "md4": Disabling barriers, not supported by the underlying
device<br>
XFS mounting filesystem md4<br>
Ending clean XFS mount for filesystem: md4<br>
XFS mounting filesystem hde1<br>
Ending clean XFS mount for filesystem: hde1<br>
XFS mounting filesystem hdg1<br>
Ending clean XFS mount for filesystem: hdg1<br>
Adding 240888k swap on /dev/md2.&nbsp; Priority:-1 extents:1 across:240888k<br>
hda: UDMA/100 mode selected<br>
hdc: UDMA/100 mode selected<br>
hde: UDMA/100 mode selected<br>
hdg: UDMA/100 mode selected<br>
bt878: gave up waiting for init of module bttv.<br>
bt878: Unknown symbol bttv_gpio_enable<br>
tveeprom 2-0050: Hauppauge model 69100, rev B2C3, serial# 3247319<br>
tveeprom 2-0050: MAC address is 00-0D-FE-31-8C-D7<br>
tveeprom 2-0050: tuner model is Conexant CX24118A (idx 123, type 4)<br>
tveeprom 2-0050: TV standards ATSC/DVB Digital (eeprom 0x80)<br>
tveeprom 2-0050: audio processor is None (idx 0)<br>
tveeprom 2-0050: decoder processor is CX882 (idx 25)<br>
tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter<br>
cx88[0]: hauppauge eeprom: model=69100<br>
input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:0b.0/input/input2<br>
cx88[0]/0: found at 0000:00:0b.0, rev: 5, irq: 10, latency: 32, mmio:
0xf5000000<br>
cx88[0]/0: registered device video1 [v4l2]<br>
cx88[0]/0: registered device vbi1<br>
cx88[0]/2: cx2388x 8802 Driver Manager<br>
cx88[0]/2: found at 0000:00:0b.2, rev: 5, irq: 10, latency: 32, mmio:
0xf3000000<br>
udev: renamed network interface eth0 to eth1<br>
cx88[1]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite)
DVB-S/S2 [card=69,autodetected]<br>
cx88[1]: TV tuner type -1, Radio tuner type -1<br>
tveeprom 3-0050: Hauppauge model 69100, rev B2C3, serial# 3247400<br>
tveeprom 3-0050: MAC address is 00-0D-FE-31-8D-28<br>
tveeprom 3-0050: tuner model is Conexant CX24118A (idx 123, type 4)<br>
tveeprom 3-0050: TV standards ATSC/DVB Digital (eeprom 0x80)<br>
tveeprom 3-0050: audio processor is None (idx 0)<br>
tveeprom 3-0050: decoder processor is CX882 (idx 25)<br>
tveeprom 3-0050: has no radio, has IR receiver, has no IR transmitter<br>
cx88[1]: hauppauge eeprom: model=69100<br>
input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:0d.0/input/input3<br>
cx88[1]/0: found at 0000:00:0d.0, rev: 5, irq: 3, latency: 32, mmio:
0xf0000000<br>
cx88[1]/0: registered device video2 [v4l2]<br>
cx88[1]/0: registered device vbi2<br>
cx88[1]/2: cx2388x 8802 Driver Manager<br>
cx88[1]/2: found at 0000:00:0d.2, rev: 5, irq: 3, latency: 32, mmio:
0xee000000<br>
bt878: AUDIO driver version 0.0.0 loaded<br>
bt878: Bt878 AUDIO function found (0).<br>
bt878_probe: card id=[0x1010071],[ Nebula Electronics DigiTV ] has DVB
functions.<br>
bt878(0): Bt878 (rev 17) at 00:09.1, irq: 3, latency: 32, memory:
0xf8800000<br>
DVB: registering new adapter (bttv0)<br>
cx88_dvb: Unknown parameter `frontend'<br>
DVB: registering frontend 0 (NxtWave NXT6000 DVB-T)...<br>
cx88_dvb: Unknown parameter `frontend'<br>
<br>
<br>
</font>
</body>
</html>

--------------000603000007010508030403--


--===============0982841596==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0982841596==--
