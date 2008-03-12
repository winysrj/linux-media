Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <bernhard.albers@gmx.org>) id 1JZOph-0006TR-Fh
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 12:09:19 +0100
Message-ID: <47D7B9BC.3070304@gmx.org>
Date: Wed, 12 Mar 2008 12:08:44 +0100
From: Bernhard Albers <bernhard.albers@gmx.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] MT2266 I2C write failed, usb disconnet,
	WinTV Nova-TD stick, remote
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

Hello everyone!

I recently installed mythbunut 7.10 and tried to get the WinTV Nova-TD
stick working with the latest v4l-sources (mercurial)

Output of lsusb:  ID 2040:9580 Hauppauge
Hauppauge Remote: A415-HPG-WE-A

When I start mythbuntu, I get the following error, after switching the
channels using the mythbuntu frontend (dmesg):

##########
[   11.460000] dib0700: loaded with support for 6 different device-types
[   11.460000] dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV
Diversity' in warm state.
[   11.460000] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   11.464000] DVB: registering new adapter (Hauppauge Nova-TD
Stick/Elgato Eye-TV Diversity)
[   11.708000] DVB: registering frontend 0 (DiBcom 7000PC)...
[   11.764000] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level,
low) -> IRQ 16
[   11.776000] MT2266: successfully identified
[   11.900000] input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
[   11.904000] input: PC Speaker as /class/input/input3
[   11.904000] parport_pc 00:0a: reported by Plug and Play ACPI
[   11.904000] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   11.932000] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   11.932000] DVB: registering new adapter (Hauppauge Nova-TD
Stick/Elgato Eye-TV Diversity)
[   11.984000] hda_codec: Unknown model for ALC883, trying auto-probe
from BIOS...
[   12.084000] DVB: registering frontend 1 (DiBcom 7000PC)...
[   12.088000] MT2266: successfully identified
[   12.244000] input: IR-receiver inside an USB DVB receiver as
/class/input/input4
[   12.244000] dvb-usb: schedule remote query interval to 150 msecs.
[   12.244000] dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity
successfully initialized and connected.
[   12.244000] usbcore: registered new interface driver dvb_usb_dib0700
[   12.644000] lp0: using parport0 (interrupt-driven).
[   12.864000] Adding 2642652k swap on /dev/sda5.  Priority:-1 extents:1
across:2642652k
[  172.720000] EXT3 FS on sda1, internal journal
[  174.548000] input: Power Button (FF) as /class/input/input5
[  174.548000] ACPI: Power Button (FF) [PWRF]
[  174.548000] input: Power Button (CM) as /class/input/input6
[  174.548000] ACPI: Power Button (CM) [PWRB]
[  174.596000] No dock devices found.
[  177.108000] r8169: eth0: link up
[  177.108000] r8169: eth0: link up
[  177.744000] NET: Registered protocol family 10
[  177.748000] lo: Disabled Privacy Extensions
[  189.300000] NET: Registered protocol family 17
[  203.584000] eth0: no IPv6 routers present
[  232.720000] hda-intel: Invalid position buffer, using LPIB read
method instead.
[  428.888000] UDF-fs: Partition marked readonly; forcing readonly mount
[  428.936000] UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume
'Belleville', timestamp 2036/02/07 02:58 (103c)
[  459.596000] dib0700: Unknown remote controller key: 12 2A  1  0
[  459.748000] dib0700: Unknown remote controller key:  F  A  1  0
[  628.492000] hub 4-0:1.0: port 9 disabled by hub (EMI?), re-enabling...
[  628.492000] usb 4-9: USB disconnect, address 2
[  628.500000] MT2266 I2C write failed
[  628.500000] MT2266 I2C write failed
[  650.208000] dvb-usb: error while stopping stream.
[  650.208000] MT2266 I2C write failed (len=9)
[  650.224000] MT2266 I2C write failed (len=4)
[  650.224000] MT2266 I2C write failed (len=3)
[  650.224000] MT2266 I2C read failed
[  650.240000] MT2266 I2C read failed
[  650.256000] MT2266 I2C read failed
[  650.272000] MT2266 I2C read failed
[  650.288000] MT2266 I2C read failed
[  650.304000] MT2266 I2C read failed
[  650.320000] MT2266 I2C read failed
[  650.336000] MT2266 I2C read failed
[  650.352000] MT2266 I2C read failed
[  650.368000] MT2266 I2C read failed
###########

If I disable the remote sensor  in "/etc/modprobe.d/options" via
"options dvb_usb disable_rc_polling=1" this i2c failures do not seem to
occur.

Maybe it is a problem of the mainboard. It is an Asus m2a-vm hdmi
(amd690g chipset and ati x1250 onboard graphics) with the latest Bios
(1604).

Best regards
	Bernhard

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
