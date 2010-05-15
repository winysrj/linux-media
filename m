Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:18639
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab0EOJq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 05:46:29 -0400
Message-ID: <4BEE6B30.30303@ii.net>
Date: Sat, 15 May 2010 17:36:48 +0800
From: Cliffe <cliffe@ii.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: No video0, /dev/dvb/adapter0 present
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello I would really appreciate some help.

I am trying to setup my TV HD tuner card and have encountered some problems.

In a nutshell:
I have /dev/dvb/adapter0
containing:
demux0  dvr0  frontend0  net0

but no /dev/video0

Some details:

Card: Leadtek DTV2000 DS Dual Tuner

Was not detected by OpenSuse 11.2
I tried building from the repo
(as described here: 
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers)
but there were errors, so I grabbed from
http://linuxtv.org/hg/~anttip/af9015/
which was reported to work with the card

dmesg reported firmware missing, so I got dvb-usb-af9015.fw from
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/

Now it loads
(from dmesg):
[    8.436254] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in warm state.
[    8.436301] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[    8.436653] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
[    8.644457] af9013: firmware version:4.95.0
[    8.647825] DVB: registering adapter 0 frontend 0 (Afatech AF9013 
DVB-T)...
[    8.667594] tda18271 0-00c0: creating new instance
[    8.670774] TDA18271HD/C2 detected @ 0-00c0
[    8.852151] ath: EEPROM regdomain: 0x809c
[    8.852153] ath: EEPROM indicates we should expect a country code
[    8.852155] ath: doing EEPROM country->regdmn map search
[    8.852156] ath: country maps to regdmn code: 0x52
[    8.852158] ath: Country alpha2 being used: CN
[    8.852159] ath: Regpair used: 0x52
[    8.873794] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[    8.874160] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
[    8.928654] phy0: Selected rate control algorithm 'minstrel'
[    8.929117] cfg80211: Calling CRDA for country: CN
[    8.929293] ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
[    9.079590] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
[    9.082319] af9013: firmware version:4.95.0
[    9.094043] DVB: registering adapter 1 frontend 0 (Afatech AF9013 
DVB-T)...
[    9.094211] tda18271 1-00c0: creating new instance
[    9.096393] af9015: command failed:2
[    9.098032] tda18271_read_regs: [1-00c0|M] ERROR: i2c_transfer 
returned: -1
[    9.098046] Unknown device detected @ 1-00c0, device not supported.
[    9.100368] af9015: command failed:2
[    9.101977] tda18271_read_regs: [1-00c0|M] ERROR: i2c_transfer 
returned: -1
[    9.101990] Unknown device detected @ 1-00c0, device not supported.
[    9.101995] tda18271_attach: [1-00c0|M] error -22 on line 1272
[    9.102005] tda18271 1-00c0: destroying instance
[    9.102165] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1e.0/0000:07:01.2/usb3/3-1/input/input5
[    9.102193] dvb-usb: schedule remote query interval to 150 msecs.
[    9.102196] dvb-usb: Leadtek WinFast DTV2000DS successfully 
initialized and connected.
[    9.245040] usbcore: registered new interface driver dvb_usb_af9015

But /dev/video0 does not exist which means none of the TV software works.

I don't know what to try next. Any help would be awesome.

Thanks,

Cliffe.


