Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw10.wm.net ([85.119.129.3]:42324 "EHLO mailgw11.wm.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751079AbZFEQGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 12:06:44 -0400
Received: from WMSI001556.corp.wmdata.net (wmbridgehead.wmdata.se [164.9.238.12])
	by mailgw11.wm.net  with ESMTP id n55G6jxN015320
	for <linux-media@vger.kernel.org>; Fri, 5 Jun 2009 18:06:45 +0200
From: "Sandell, Anders" <anders.sandell@logica.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 5 Jun 2009 18:06:42 +0200
Subject: /dev/dvb/adapter0/dvr0 gives no output
Message-ID: <22162B491802D04F87B02036F8E317992B6A9F19BE@SE-EX008.groupinfra.com>
Content-Language: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have recently got a Tevii s650 DVB-S2 receiver that I am trying to get to work on my Ubuntu 9.04 system.

I have installed mythbuntu and the latest v4l drivers and I am using firmware from Tevii.com. dvb-usb-s650.fw is renamed to dvb-usb-dw2104.fw and copied into /lib/firmware together with dvb-fe-cx24116.fw.

Everything looks just fine but when trying "cat /dev/dvb/adapter0/dvr0 > file.mpg" nothing happens, the file never get any contents.

The receiver seems to be recognized just fine by the system:
[ 8.677642] dvb-usb: found a 'TeVii S650 USB2.0' in cold state, will try to load a firmware
[ 8.677647] usb 1-4: firmware: requesting dvb-usb-dw2104.fw
[ 8.685991] cfg80211: Calling CRDA to update world regulatory domain
[ 8.723171] dvb-usb: downloading firmware from file 'dvb-usb-dw2104.fw'
[ 8.723175] dw2102: start downloading DW210X firmware
[ 8.776337] cfg80211: World regulatory domain updated:
[ 8.776341] (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 8.776343] (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 8.776346] (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 8.776348] (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 8.776350] (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 8.776352] (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 8.844033] dvb-usb: found a 'TeVii S650 USB2.0' in warm state.
[ 8.844115] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 8.844354] DVB: registering new adapter (TeVii S650 USB2.0)
...............
[ 9.051466] dvb-usb: MAC address: f67c2918
[ 9.096090] dw2102: Attached cx24116!
[ 9.096091] 
[ 9.096095] DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
[ 9.096535] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:13.2/usb1/1-4/input/input6
[ 9.105088] dvb-usb: schedule remote query interval to 150 msecs.
[ 9.105092] dvb-usb: TeVii S650 USB2.0 successfully initialized and connected.
[ 9.105120] usbcore: registered new interface driver dw2102

I can use scan-s2 against Thor at S0.8 to get a channels.conf

Szap-s2 also seems to be working locking on to BBC World:
anders@srv01:~$ ./szap-s2/szap-s2 -a 0 -c channels.conf -n 8
reading channels from file 'channels.conf'
zapping to 8 'Telenor - BBC World News;Telenor':
delivery DVB-S, modulation QPSK
sat 0, frequency 11325 MHz H, symbolrate 24500000, coderate 7/8, rolloff 0.35
vpid 0x0201, apid 0x0284, sid 0x0241
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal ee40 | snr 0000 | ber 00000000 | unc 00000000 | 
status 1f | signal ef40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ef40 | snr f4cd | ber 00000000 | unc 00000000 | FE_HAS_LOCK

If I try dvbtraffic I get the following output that seems to indicate that something is coming down from the satellite:
0200 2594 p/s 476 kb/s 3901 kbit
0201 2757 p/s 506 kb/s 4147 kbit
0202 1176 p/s 215 kb/s 1769 kbit
0203 2661 p/s 488 kb/s 4002 kbit
0204 3273 p/s 600 kb/s 4922 kbit
0207 1862 p/s 341 kb/s 2801 kbit
0208 2756 p/s 505 kb/s 4145 kbit
0209 2689 p/s 493 kb/s 4045 kbit
020a 2317 p/s 425 kb/s 3484 kbit
0240 50 p/s 9 kb/s 76 kbit
0241 49 p/s 8 kb/s 74 kbit
0242 49 p/s 8 kb/s 74 kbit
0243 149 p/s 27 kb/s 224 kbit
0245 49 p/s 8 kb/s 74 kbit
0246 147 p/s 26 kb/s 221 kbit
0280 174 p/s 31 kb/s 262 kbit
0284 175 p/s 32 kb/s 263 kbit
0288 131 p/s 24 kb/s 197 kbit
028c 175 p/s 32 kb/s 263 kbit
0290 180 p/s 33 kb/s 271 kbit
0298 69 p/s 12 kb/s 104 kbit
02a0 130 p/s 23 kb/s 196 kbit
02a4 175 p/s 32 kb/s 263 kbit
02a8 87 p/s 15 kb/s 131 kbit
0350 51 p/s 9 kb/s 77 kbit
08fb 14 p/s 2 kb/s 22 kbit
0968 66 p/s 12 kb/s 100 kbit
1fff 1517 p/s 278 kb/s 2282 kbit
2000 26289 p/s 4826 kb/s 39538 kbit
-PID--FREQ-----BANDWIDTH-BANDWIDTH-

The card seems to be working since I have been able to get picture from BBC World on a Vista machine.

Any suggestions or hints are most welcome!!

//Anders
