Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gczerw@comcast.net>) id 1MLgiC-0006PB-I7
	for linux-dvb@linuxtv.org; Tue, 30 Jun 2009 19:01:42 +0200
From: George Czerw <gczerw@comcast.net>
To: linux-dvb@linuxtv.org
Date: Tue, 30 Jun 2009 13:01:04 -0400
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906301301.04604.gczerw@comcast.net>
Subject: [linux-dvb] Hauppauge HVR-1800 not working at all
Reply-To: linux-media@vger.kernel.org, gczerw@comcast.net
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Using Mandriva 2009.1 with HVR connected directly to analog cable.  
Using 32-bit kernel 2.6.29.3-desktop-1.mnb.

TVtime and xawTV both open but display only snow.  Channel scanning yields 
nothing.

If I boot into Vista and load MediaCenter, open liveTV and watch a channel. 
Then close MediaCenter, exit Vista and boot into linux, TVtime and xawTV (if I 
am lucky) might open-up and perfectly display the TV channel that I was last 
viewing in Vista, but will not change channels to another station no matter 
what I do.

Please see the following outputs below. I would appreciate any
suggestions to resolve this. Not having hardware problems since WinVista's
media center works perfectly with this hardware.

Thanks
George

*************************

tvtime -v
Running tvtime 1.0.2.

Reading configuration from /etc/tvtime/tvtime.xml

Reading configuration from /home/george/.tvtime/tvtime.xml

cpuinfo: CPU Intel(R) Core(TM)2 Quad CPU Q8200 @ 2.33GHz, family 6,
model 7, stepping 7.

cpuinfo: CPU measured at 2333.352MHz.

xcommon: Display :0.0, vendor The X.Org Foundation, vendor release 10601000

xfullscreen: Using XINERAMA for dual-head information.
xfullscreen: Pixels are square.
xfullscreen: Number of displays is 1.
xfullscreen: Head 0 at 0,0 with size 1440x900.
xcommon: Have XTest, will use it to ping the screensaver.
xcommon: Pixel aspect ratio 1:1.
xcommon: Pixel aspect ratio 1:1.
xcommon: Window manager is KWin and is EWMH compliant.
xcommon: Using EWMH state fullscreen property.
xcommon: Using EWMH state above property.
xcommon: Using EWMH state below property.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xvoutput: Using XVIDEO adaptor 280: NV17 Video Texture.
speedycode: Using MMXEXT optimized functions.
station: Reading stationlist from /home/george/.tvtime/stationlist.xml
videoinput: Using video4linux2 driver 'cx23885', card 'Hauppauge
WinTV-HVR1800' (bus PCIe:0000:03:00.0).
videoinput: Version is 1, capabilities 5010011.
videoinput: Maximum input width: 720 pixels.
tvtime: Sampling input at 720 pixels per scanline.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xcommon: Received a map, marking window as visible (62).
xcommon: Window fully obscured, marking window as hidden (62).
xcommon: Window made visible, marking window as visible (62).
tvtime: Cleaning up.
Thank you for using tvtime.

********************


# lspci
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
Controller (rev
02)
00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI
Express Root Port (rev
02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev
02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev
02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev
02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev
02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 3 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #6 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) 00:1f.0
ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface Controller
(rev 02)
00:1f.2 RAID bus controller: Intel Corporation 82801 SATA RAID Controller
(rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller
(rev 02)
01:05.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70) 02:00.0
Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller (rev 02) 03:00.0 Multimedia video
controller: Conexant Systems, Inc. Device 8880 (rev 0f)
04:00.0 Network controller: Atheros Communications Inc. AR928X Wireless
Network Adapter (PCI-Express) (rev 01) 05:00.0 VGA compatible controller:
nVidia Corporation Device 0644 (rev a1)

*******************

# v4l-conf
v4l-conf: using X11 display :0.0
dga: version 2.0
WARNING: No DGA direct video mode for this display. mode: 1440x900,
depth=24, bpp=32, bpl=5760, base=unknown /dev/video0 [v4l2]: no overlay
support

*******************
selected DMESG output:

nvidia: module license 'NVIDIA' taints kernel.

nvidia 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16

nvidia 0000:05:00.0: setting latency timer to 64


Linux video capture interface: v2.00

cx23885 driver version 0.0.1 loaded

cx23885 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17

CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800
[card=2,autodetected]

tveeprom 0-0050: Hauppauge model 78521, rev C1E9, serial# 5342357

tveeprom 0-0050: MAC address is 00-0D-FE-51-84-95

tveeprom 0-0050: tuner model is Philips 18271_8295 (idx 149, type 54)

tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)

tveeprom 0-0050: audio processor is CX23887 (idx 42)

tveeprom 0-0050: decoder processor is CX23887 (idx 37)

tveeprom 0-0050: has radio

cx23885[0]: hauppauge eeprom: model=78521

cx25840' 2-0044: cx25 0-21 found @ 0x88 (cx23885[0])

cx23885[0]/0: registered device video0 [v4l2]

cx25840' 2-0044: firmware: requesting v4l-cx23885-avcore-01.fw

cx25840' 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)

cx23885[0]: registered device video1 [mpeg]

cx23885_dvb_register() allocating 1 frontend(s)

cx23885[0]: cx23885 based dvb card

MT2131: successfully identified at address 0x61

DVB: registering new adapter (cx23885[0])

DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...

cx23885_dev_checkrevision() Hardware revision = 0xb1

cx23885[0]/0: found at 0000:03:00.0, rev: 15, irq: 17, latency: 0, mmio:
0xf9c00000

cx23885 0000:03:00.0: setting latency timer to 64

IRQ 17/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
NVRM: loading NVIDIA UNIX x86 Kernel Module 180.51 Thu Apr 16 19:02:15
PDT 2009

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
