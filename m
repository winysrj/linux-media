Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37188 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0AFKGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 05:06:38 -0500
Received: by ewy19 with SMTP id 19so9401719ewy.21
        for <linux-media@vger.kernel.org>; Wed, 06 Jan 2010 02:06:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381001040936w3bc9b4e0w22eecded4687d9d3@mail.gmail.com>
References: <829197381001040936w3bc9b4e0w22eecded4687d9d3@mail.gmail.com>
Date: Wed, 6 Jan 2010 11:06:36 +0100
Message-ID: <63a62e0a1001060206w45d20db8oe88c6467aa2caa65@mail.gmail.com>
Subject: Re: Call for Testers - dib0700 IR improvements
From: Harald Gustafsson <hgu1972@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for working on improving the Nova T 500 performance, it is much
appreciated, and let me know if you need further help with debugging
it.

I tried your dib0700-ir tree. My problems with the Nova T 500 and the
1.20 firmware have been warm reboots. Before your patch a warm reboot
would give I2C errors in dmesg log with the 1.20 FW, hence I have only
used my machine with cold boots since my upgrade this xmas. With the
1.10 FW and Ubuntu 7.04 + v4l tip sometime in 2008 the system have run
without much problems including frequent warm reboots for 2 years.
Sorry to say this patch does not solve the problem to have a working
IR after a warm reboot see dmesg logs below. I have not seen any
problems with high load before, so can't give any info on that matter
more than it is certainly low now. The I2C errors I saw before your
patch come shortly after a warm reboot (see last dmesg log included),
but have not had any problems after cold boots for the past week the
system have been recording.

I run on:
Linux hgu 2.6.31-16-generic #53-Ubuntu SMP Tue Dec 8 04:01:29 UTC 2009
i686 GNU/Linux
Motherboard: ABIT IL-90MV 945GT Mobile S478 HDMI mATX
CPU: Intel Core 2 Duo Mobile T5600 1.83GHz 2M
DVB-T cards: Hauppauge WinTV Nova-T 500 DVB-T & Twinhan VisionPlus DVB-T
In a bad reception area (the Twinhan can't acceptably receive all the
channels the Hauppauge can)

/Harald

dmesg logs:
Warm reboot (after ubuntu 9.10 2.6.31-16 standard modules) got
non-working remote but working video
[    8.282314] dib0700: loaded with support for 14 different device-types
[    8.282568] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
[    8.282615] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[    8.282798] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[    8.311479] DVB: registering new adapter (bttv0)
[    8.396083] DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
[    8.509562] usbcore: registered new interface driver snd-usb-audio
[    8.578470] MT2060: successfully identified (IF1 = 1228)
[    9.107028] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[    9.107285] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[    9.113153] DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
[    9.119744] MT2060: successfully identified (IF1 = 1235)
[    9.490288] dst(0) dst_get_device_id: Recognise [DTTDIG]
[    9.490294] DST type flags : 0x10 firmware version = 2
[    9.531093] dst(0) dst_get_mac: MAC Address=[00:08:ca:30:10:39]
[    9.531103] DVB: registering adapter 1 frontend 0 (DST DVB-T)...
[    9.684982] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1e.0/0000:03:06.2/usb2/2-1/input/input6
[    9.685059] dvb-usb: schedule remote query interval to 50 msecs.
[    9.685066] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
[    9.685327] dib0700: rc submit urb failed

Cold boot (directly after the previous) got working remote and video
[   19.445048] dib0700: loaded with support for 14 different device-types
[   19.445747] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
cold state, will try to load a firmware
[   19.445754] usb 2-1: firmware: requesting dvb-usb-dib0700-1.20.fw
[   19.498041] usbcore: registered new interface driver snd-usb-audio
[   19.508086] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   19.508115] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   19.547850] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[   19.586410] hda_codec: Unknown model for ALC882, trying auto-probe
from BIOS...
[   19.586598] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input5
[   19.699301] dst(0) dst_get_device_id: Recognise [DTTDIG]
[   19.699310] DST type flags : 0x10 firmware version = 2
[   19.741032] dst(0) dst_get_mac: MAC Address=[00:08:ca:30:10:39]
[   19.741042] DVB: registering adapter 0 frontend 0 (DST DVB-T)...
[   19.848324] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   19.904203] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   19.904842] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.917288] dib0700: firmware started successfully.
[   19.945541] kjournald starting.  Commit interval 5 seconds
[   19.946387] EXT3 FS on sda1, internal journal
[   19.946397] EXT3-fs: mounted filesystem with writeback data mode.
[   20.019719] __ratelimit: 9 callbacks suppressed
[   20.019723] type=1505 audit(1262768018.239:14):
operation="profile_replace" pid=1011
name=/usr/share/gdm/guest-session/Xsession
[   20.021747] type=1505 audit(1262768018.243:15):
operation="profile_replace" pid=1013 name=/sbin/dhclient3
[   20.022550] type=1505 audit(1262768018.243:16):
operation="profile_replace" pid=1013
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[   20.022984] type=1505 audit(1262768018.243:17):
operation="profile_replace" pid=1013
name=/usr/lib/connman/scripts/dhclient-script
[   20.027665] type=1505 audit(1262768018.247:18):
operation="profile_replace" pid=1014 name=/usr/bin/evince
[   20.041149] type=1505 audit(1262768018.263:19):
operation="profile_replace" pid=1014 name=/usr/bin/evince-previewer
[   20.048838] type=1505 audit(1262768018.267:20):
operation="profile_replace" pid=1014 name=/usr/bin/evince-thumbnailer
[   20.059755] type=1505 audit(1262768018.279:21):
operation="profile_replace" pid=1016
name=/usr/lib/cups/backend/cups-pdf
[   20.060688] type=1505 audit(1262768018.279:22):
operation="profile_replace" pid=1016 name=/usr/sbin/cupsd
[   20.063410] type=1505 audit(1262768018.283:23):
operation="profile_replace" pid=1017 name=/usr/sbin/mysqld
[   20.440617] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
[   20.440683] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   20.452096] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[   20.602207] DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...

Warm reboot directly after that, got non-working remote and working video
[   19.394923] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
[   19.394984] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   19.395236] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[   19.422433] usbcore: registered new interface driver snd-usb-audio
[   19.464044] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   19.464071] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   19.556561] DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
[   19.567024] hda_codec: Unknown model for ALC882, trying auto-probe
from BIOS...
[   19.567227] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input5
[   19.586441] MT2060: successfully identified (IF1 = 1228)
[   19.656326] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   19.679165] dst(0) dst_get_device_id: Recognise [DTTDIG]
[   19.679174] DST type flags : 0x10 firmware version = 2
[   19.713222] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   19.713865] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.717511] dst(0) dst_get_mac: MAC Address=[00:08:ca:30:10:39]
[   19.717520] DVB: registering adapter 0 frontend 0 (DST DVB-T)...
[   19.760820] __ratelimit: 9 callbacks suppressed
[   19.760824] type=1505 audit(1262768411.986:14):
operation="profile_replace" pid=958
name=/usr/share/gdm/guest-session/Xsession
[   19.762718] type=1505 audit(1262768411.986:15):
operation="profile_replace" pid=959 name=/sbin/dhclient3
[   19.763518] type=1505 audit(1262768411.986:16):
operation="profile_replace" pid=959
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[   19.763951] type=1505 audit(1262768411.986:17):
operation="profile_replace" pid=959
name=/usr/lib/connman/scripts/dhclient-script
[   19.768153] type=1505 audit(1262768411.994:18):
operation="profile_replace" pid=960 name=/usr/bin/evince
[   19.781632] type=1505 audit(1262768412.006:19):
operation="profile_replace" pid=960 name=/usr/bin/evince-previewer
[   19.789269] type=1505 audit(1262768412.014:20):
operation="profile_replace" pid=960 name=/usr/bin/evince-thumbnailer
[   19.799644] type=1505 audit(1262768412.022:21):
operation="profile_replace" pid=962
name=/usr/lib/cups/backend/cups-pdf
[   19.800576] type=1505 audit(1262768412.026:22):
operation="profile_replace" pid=962 name=/usr/sbin/cupsd
[   19.803911] type=1505 audit(1262768412.026:23):
operation="profile_replace" pid=963 name=/usr/sbin/mysqld
[   19.806818] kjournald starting.  Commit interval 5 seconds
[   19.892403] EXT3 FS on sda1, internal journal
[   19.892411] EXT3-fs: mounted filesystem with writeback data mode.
[   20.161701] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   20.161952] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[   20.170025] DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
[   20.181216] MT2060: successfully identified (IF1 = 1235)

warm reboot again, non-working remote and working video
[   19.502575] dib0700: loaded with support for 14 different device-types
[   19.517756] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
[   19.517812] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   19.518129] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[   19.540713] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   19.540742] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   19.543961] usbcore: registered new interface driver snd-usb-audio
[   19.616968] hda_codec: Unknown model for ALC882, trying auto-probe
from BIOS...
[   19.617152] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input5
[   19.654026] DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
[   19.666149] MT2060: successfully identified (IF1 = 1228)
[   19.752337] dst(0) dst_get_device_id: Recognise [DTTDIG]
[   19.752346] DST type flags : 0x10 firmware version = 2
[   19.789529] dst(0) dst_get_mac: MAC Address=[00:08:ca:30:10:39]
[   19.789537] DVB: registering adapter 0 frontend 0 (DST DVB-T)...
[   19.954831] kjournald starting.  Commit interval 5 seconds
[   20.002500] __ratelimit: 9 callbacks suppressed
[   20.002504] type=1505 audit(1262768918.222:14):
operation="profile_replace" pid=982
name=/usr/share/gdm/guest-session/Xsession
[   20.004491] type=1505 audit(1262768918.226:15):
operation="profile_replace" pid=983 name=/sbin/dhclient3
[   20.005305] type=1505 audit(1262768918.226:16):
operation="profile_replace" pid=983
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[   20.005737] type=1505 audit(1262768918.226:17):
operation="profile_replace" pid=983
name=/usr/lib/connman/scripts/dhclient-script
[   20.011263] type=1505 audit(1262768918.230:18):
operation="profile_replace" pid=984 name=/usr/bin/evince
[   20.024517] type=1505 audit(1262768918.246:19):
operation="profile_replace" pid=984 name=/usr/bin/evince-previewer
[   20.032170] type=1505 audit(1262768918.254:20):
operation="profile_replace" pid=984 name=/usr/bin/evince-thumbnailer
[   20.042387] EXT3 FS on sda1, internal journal
[   20.042395] EXT3-fs: mounted filesystem with writeback data mode.
[   20.043270] type=1505 audit(1262768918.262:21):
operation="profile_replace" pid=986
name=/usr/lib/cups/backend/cups-pdf
[   20.044203] type=1505 audit(1262768918.266:22):
operation="profile_replace" pid=986 name=/usr/sbin/cupsd
[   20.079244] type=1505 audit(1262768918.298:23):
operation="profile_replace" pid=991 name=/usr/sbin/mysqld
[   20.096557] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   20.152244] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   20.152908] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.305277] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   20.305516] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[   20.313085] DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
[   20.325334] MT2060: successfully identified (IF1 = 1235)

Cold boot (with a hung cold boot inbetween, don't know why)
[   19.462415] dib0700: loaded with support for 14 different device-types
[   19.468290] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
cold state, will try to load a firmware
[   19.468298] usb 2-1: firmware: requesting dvb-usb-dib0700-1.20.fw
[   19.515126] EXT4-fs (sda4): internal journal on sda4:8
[   19.540349] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   19.540375] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   19.612616] hda_codec: Unknown model for ALC882, trying auto-probe
from BIOS...
[   19.612797] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input5
[   19.618532] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[   19.750192] dst(0) dst_get_device_id: Recognise [DTTDIG]
[   19.750202] DST type flags : 0x10 firmware version = 2
[   19.793633] dst(0) dst_get_mac: MAC Address=[00:08:ca:30:10:39]
[   19.793644] DVB: registering adapter 0 frontend 0 (DST DVB-T)...
[   19.837101] kjournald starting.  Commit interval 5 seconds
[   19.838306] EXT3 FS on sda1, internal journal
[   19.838313] EXT3-fs: mounted filesystem with writeback data mode.
[   19.958594] dib0700: firmware started successfully.
[   20.016232] __ratelimit: 9 callbacks suppressed
[   20.016236] type=1505 audit(1262769337.239:14):
operation="profile_replace" pid=944
name=/usr/share/gdm/guest-session/Xsession
[   20.019156] type=1505 audit(1262769337.243:15):
operation="profile_replace" pid=945 name=/sbin/dhclient3
[   20.019959] type=1505 audit(1262769337.243:16):
operation="profile_replace" pid=945
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[   20.020424] type=1505 audit(1262769337.243:17):
operation="profile_replace" pid=945
name=/usr/lib/connman/scripts/dhclient-script
[   20.026265] type=1505 audit(1262769337.251:18):
operation="profile_replace" pid=946 name=/usr/bin/evince
[   20.040464] type=1505 audit(1262769337.263:19):
operation="profile_replace" pid=946 name=/usr/bin/evince-previewer
[   20.050251] type=1505 audit(1262769337.275:20):
operation="profile_replace" pid=946 name=/usr/bin/evince-thumbnailer
[   20.060962] type=1505 audit(1262769337.283:21):
operation="profile_replace" pid=948
name=/usr/lib/cups/backend/cups-pdf
[   20.061314] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   20.061905] type=1505 audit(1262769337.287:22):
operation="profile_replace" pid=948 name=/usr/sbin/cupsd
[   20.064984] type=1505 audit(1262769337.287:23):
operation="profile_replace" pid=949 name=/usr/sbin/mysqld
[   20.117133] e1000e 0000:02:00.0: irq 26 for MSI/MSI-X
[   20.117770] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.465812] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
[   20.465876] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   20.465962] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[   20.588205] DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
[   20.601581] MT2060: successfully identified (IF1 = 1228)

Old dmesg without your patch and a warm reboot:
Jan  4 08:31:41 hgu kernel: [    8.102915] dib0700: loaded with
support for 9 different device-types
Jan  4 08:31:41 hgu kernel: [    8.105999] dvb-usb: found a 'Hauppauge
Nova-T 500 Dual DVB-T' in warm state.
Jan  4 08:31:41 hgu kernel: [    8.106041] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Jan  4 08:31:41 hgu kernel: [    8.106283] DVB: registering new
adapter (Hauppauge Nova-T 500 Dual DVB-T)
Jan  4 08:31:41 hgu kernel: [    8.217085] DVB: registering adapter 1
frontend 0 (DiBcom 3000MC/P)...
Jan  4 08:31:41 hgu kernel: [    8.321048] ip_tables: (C) 2000-2006
Netfilter Core Team
Jan  4 08:31:41 hgu kernel: [    8.453271] MT2060: successfully
identified (IF1 = 1228)
Jan  4 08:31:41 hgu kernel: [    8.553167] HDA Intel 0000:00:1b.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Jan  4 08:31:41 hgu kernel: [    8.553197] HDA Intel 0000:00:1b.0:
setting latency timer to 64
Jan  4 08:31:42 hgu kernel: [    8.807282] dst(0) dst_get_device_id:
Recognise [DTTDIG]
Jan  4 08:31:42 hgu kernel: [    8.807287] DST type flags : 0x10
firmware version = 2
Jan  4 08:31:42 hgu kernel: [    8.809934] usbcore: registered new
interface driver snd-usb-audio
Jan  4 08:31:42 hgu kernel: [    8.849652] dst(0) dst_get_mac: MAC
Address=[00:08:ca:30:10:39]
Jan  4 08:31:42 hgu kernel: [    8.849664] DVB: registering adapter 0
frontend 2019307570 (DST DVB-T)...
Jan  4 08:31:42 hgu kernel: [    8.865488] hda_codec: Unknown model
for ALC882, trying auto-probe from BIOS...
Jan  4 08:31:42 hgu kernel: [    8.865759] input: HDA Digital PCBeep
as /devices/pci0000:00/0000:00:1b.0/input/input5
Jan  4 08:31:42 hgu kernel: [    8.967457] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Jan  4 08:31:42 hgu kernel: [    8.967969] DVB: registering new
adapter (Hauppauge Nova-T 500 Dual DVB-T)
Jan  4 08:31:42 hgu kernel: [    8.976285] DVB: registering adapter 2
frontend 0 (DiBcom 3000MC/P)...
Jan  4 08:31:42 hgu kernel: [    8.981037] MT2060: successfully
identified (IF1 = 1235)
Jan  4 08:31:42 hgu kernel: [    9.528968] input: IR-receiver inside
an USB DVB receiver as
/devices/pci0000:00/0000:00:1e.0/0000:03:06.2/usb2/2-1/input/input6
Jan  4 08:31:42 hgu kernel: [    9.529054] dvb-usb: schedule remote
query interval to 50 msecs.
Jan  4 08:31:42 hgu kernel: [    9.529060] dvb-usb: Hauppauge Nova-T
500 Dual DVB-T successfully initialized and connected.
Jan  4 08:31:42 hgu kernel: [    9.529334] usbcore: registered new
interface driver dvb_usb_dib0700
Jan  4 08:31:44 hgu kernel: [   11.057874] __ratelimit: 9 callbacks suppressed
...
Jan  4 08:42:49 hgu kernel: [  659.660025] mt2060 I2C write failed
Jan  4 08:42:50 hgu kernel: [  660.368029] mt2060 I2C write failed
Jan  4 08:49:54 hgu kernel: [ 1084.482548] mt2060 I2C write failed
Jan  4 08:49:54 hgu kernel: [ 1084.489152] mt2060 I2C write failed (len=2)
Jan  4 08:49:54 hgu kernel: [ 1084.489161] mt2060 I2C write failed (len=6)
Jan  4 08:49:54 hgu kernel: [ 1084.489168] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.497021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.505019] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.513021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.521020] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.529023] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.537021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.545021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.553023] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.561020] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.719318] mt2060 I2C write failed (len=2)
Jan  4 08:49:54 hgu kernel: [ 1084.719327] mt2060 I2C write failed (len=6)
Jan  4 08:49:54 hgu kernel: [ 1084.719334] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.725020] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.733022] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.741020] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.748667] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.756021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.764021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.773018] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.781021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.789021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.957611] mt2060 I2C write failed
Jan  4 08:49:54 hgu kernel: [ 1084.964173] mt2060 I2C write failed (len=2)
Jan  4 08:49:54 hgu kernel: [ 1084.964182] mt2060 I2C write failed (len=6)
Jan  4 08:49:54 hgu kernel: [ 1084.964189] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.972021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.980019] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.988029] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1084.996019] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.004023] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.012018] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.020021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.028018] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.036018] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.194306] mt2060 I2C write failed (len=2)
Jan  4 08:49:54 hgu kernel: [ 1085.194316] mt2060 I2C write failed (len=6)
Jan  4 08:49:54 hgu kernel: [ 1085.194323] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.200020] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.208021] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.216019] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.224019] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.232019] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.240019] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.248054] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.256020] mt2060 I2C read failed
Jan  4 08:49:54 hgu kernel: [ 1085.264020] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.429923] mt2060 I2C write failed (len=2)
Jan  4 08:49:55 hgu kernel: [ 1085.429933] mt2060 I2C write failed (len=6)
Jan  4 08:49:55 hgu kernel: [ 1085.429940] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.436023] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.444023] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.452044] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.460023] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.468020] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.476019] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.484020] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.492019] mt2060 I2C read failed
Jan  4 08:49:55 hgu kernel: [ 1085.500020] mt2060 I2C read failed
