Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imo-m27.mx.aol.com ([64.12.137.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dbox2alpha@netscape.net>) id 1L6Mpd-0005kj-O1
	for linux-dvb@linuxtv.org; Sat, 29 Nov 2008 11:13:46 +0100
Received: from dbox2alpha@netscape.net
	by imo-m27.mx.aol.com  (mail_out_v39.1.) id m.be0.4a43a045 (37118)
	for <linux-dvb@linuxtv.org>; Sat, 29 Nov 2008 05:13:05 -0500 (EST)
To: linux-dvb@linuxtv.org
Date: Sat, 29 Nov 2008 05:13:00 -0500
MIME-Version: 1.0
From: dbox2alpha@netscape.net
Message-Id: <8CB2022318A0220-1E84-15EE@WEBMAIL-MZ13.sysops.aol.com>
Subject: [linux-dvb] technotrend s2-3600: i2c error w/ kernel 2.6.28-rc6 on
 big endian system (ps3)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2018545565=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============2018545565==
Content-Type: multipart/alternative;
 boundary="--------MB_8CB2022318C6476_1E84_2D36_WEBMAIL-MZ13.sysops.aol.com"


----------MB_8CB2022318C6476_1E84_2D36_WEBMAIL-MZ13.sysops.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"

what's wrong? thanks.

usb 1-2.4: new high speed USB device using ps3-ehci-driver and address 8
usb 1-2.4: configuration #1 chosen from 1 choice
dvb-usb: found a 'Technotrend TT Connect S2-3600' in warm state.
pctv452e_power_ctrl: 1
i2c-adapter i2c-0: adapter [Technotrend TT Connect S2-3600] registered
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Technotrend TT Connect S2-3600)
pctv452e: I2C error -121; AA 02? A0 01 14 -> 55 02? A0 00 00.
dvb-usb: MAC address: 00:d0:5c:64:75:3c
pctv452e_frontend_attach Enter
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[1] R, addr=0x68, len=1
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4
stb0899_attach: Attaching STB0899
i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=4
pctv452e_frontend_attach Leave Ok
DVB: registering adapter 0 frontend 0 (STB0899 Multistandard)...
pctv452e_tuner_attach Enter
stb6100_attach: Attaching STB6100
pctv452e_tuner_attach Leave
input: IR-receiver inside an USB DVB receiver as /class/input/input1
dvb-usb: schedule remote query interval to 500 msecs.
pctv452e_power_ctrl: 0
dvb-usb: Technotrend TT Connect S2-3600 successfully initialized and connected.

----------MB_8CB2022318C6476_1E84_2D36_WEBMAIL-MZ13.sysops.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/html; charset="us-ascii"

<font face="Arial, Helvetica, sans-serif">what's wrong? thanks.<br>
<br>
usb 1-2.4: new high speed USB device using ps3-ehci-driver and address 8<br>
usb 1-2.4: configuration #1 chosen from 1 choice<br>
dvb-usb: found a 'Technotrend TT Connect S2-3600' in warm state.<br>
pctv452e_power_ctrl: 1<br>
i2c-adapter i2c-0: adapter [Technotrend TT Connect S2-3600] registered<br>
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
DVB: registering new adapter (Technotrend TT Connect S2-3600)<br>
pctv452e: I2C error -121; AA 02&nbsp; A0 01 14 -&gt; 55 02&nbsp; A0 00 00.<br>
dvb-usb: MAC address: 00:d0:5c:64:75:3c<br>
pctv452e_frontend_attach Enter<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=3<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[1] R, addr=0x68, len=1<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=6<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x68, len=2<br>
i2c-adapter i2c-0: master_xfer[0] R, addr=0x68, len=4<br>
stb0899_attach: Attaching STB0899<br>
i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=4<br>
pctv452e_frontend_attach Leave Ok<br>
DVB: registering adapter 0 frontend 0 (STB0899 Multistandard)...<br>
pctv452e_tuner_attach Enter<br>
stb6100_attach: Attaching STB6100<br>
pctv452e_tuner_attach Leave<br>
input: IR-receiver inside an USB DVB receiver as /class/input/input1<br>
dvb-usb: schedule remote query interval to 500 msecs.<br>
pctv452e_power_ctrl: 0<br>
dvb-usb: Technotrend TT Connect S2-3600 successfully initialized and connected.<br>
</font><div id='MAILCIAMA014-5c61493115ad388' class='aol_ad_footer'><BR/><FONT style="color: black; font: normal 10pt ARIAL, SAN-SERIF;"><HR style="MARGIN-TOP: 10px"></HR> Tis the season to save your money!  <a href="http://toolbar.aol.com/holiday/download.html?ncid=emlweusdown00000008">Get the new AOL Holiday Toolbar</a> for money saving offers and gift ideas. </div>

----------MB_8CB2022318C6476_1E84_2D36_WEBMAIL-MZ13.sysops.aol.com--


--===============2018545565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2018545565==--
