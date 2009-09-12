Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from h206.core.ignum.cz ([217.31.49.206])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lists.subscriber@pragl.cz>) id 1MmPeY-0007vM-OG
	for linux-dvb@linuxtv.org; Sat, 12 Sep 2009 12:16:23 +0200
Received: from palice.core.ignum.cz (palice.local.ignum.cz [192.168.1.66])
	by hroch.core.ignum.cz (Postfix) with ESMTP id 35F3B8CD78F
	for <linux-dvb@linuxtv.org>; Sat, 12 Sep 2009 12:15:19 +0200 (CEST)
Received: from mirek-nb.home.intranet (89-24-134-157.adsl.tmcz.cz
	[89.24.134.157])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by palice.core.ignum.cz (Postfix) with ESMTP id 9ED9016AD1
	for <linux-dvb@linuxtv.org>; Sat, 12 Sep 2009 12:15:25 +0200 (CEST)
Message-ID: <4AAB74BC.9050508@pragl.cz>
Date: Sat, 12 Sep 2009 12:15:24 +0200
From: Miroslav Pragl - mailing lists <lists.subscriber@pragl.cz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Pinnacle 320e (em28xx/xc2028): scan finds just first
	channel
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,
I've compiled and installed latest v4l-dvb and dvb-apps, extracted 
xceive firmware, so far so good. Distro is Fedora 11, x64 
(2.6.30.5-43.fc11.x86_64)

Unfortunately scan finds only the first channel:

$ scan  /usr/share/dvb/dvb-t/cz-Praha
scanning /usr/share/dvb/dvb-t/cz-Praha
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 634000000 0 2 9 3 1 3 0
initial transponder 674000000 0 2 9 3 1 3 0
initial transponder 730000000 0 2 9 3 1 3 0
initial transponder 778000000 0 2 9 3 1 3 0
initial transponder 818000000 0 2 9 3 1 2 0
 >>> tune to: 
634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
0x0000 0x0202: pmt_pid 0x0190 CESKE RADIOKOMUNIKACE -- NOVA CINEMA (running)
0x0000 0x0201: pmt_pid 0x0064 CESKE RADIOKOMUNIKACE --  NOVA (running)
0x0000 0x0801: pmt_pid 0x012c CESKE RADIOKOMUNIKACE -- BARRANDOV TV 
(running)
0x0000 0x0302: pmt_pid 0x01f4 CESKE RADIOKOMUNIKACE -- Prima COOL (running)
0x0000 0x0301: pmt_pid 0x00c8 CESKE RADIOKOMUNIKACE -- PRIMA (running)
Network Name 'CESKE RADIOKOMUNIKACE'
 >>> tune to: 
674000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010

if I remove 634000000 from tuning data it works fine on 674000000 but 
again not the subsequent frequencies and so on

Some applications such as vlc that can tune directly work fine (vlc 
dvb://frequency=730000000 :dvb-bandwidth=8 :program=259 etc)

Any workarounds (but merging results from scans per one frequency)?

Thanks
MP

part of dmesg:
--------------
Sep 12 12:06:41 mirek-nb kernel: em28xx #0: Board detected as Pinnacle 
Hybrid Pro
Sep 12 12:06:41 mirek-nb kernel: tvp5150 3-005c: chip found @ 0xb8 
(em28xx #0)
Sep 12 12:06:41 mirek-nb kernel: tuner 3-0061: chip found @ 0xc2 (em28xx #0)
Sep 12 12:06:41 mirek-nb kernel: xc2028 3-0061: creating new instance
Sep 12 12:06:41 mirek-nb kernel: xc2028 3-0061: type set to XCeive 
xc2028/xc3028 tuner
Sep 12 12:06:41 mirek-nb kernel: usb 2-2: firmware: requesting xc3028-v27.fw
Sep 12 12:06:41 mirek-nb kernel: xc2028 3-0061: Loading 80 firmware 
images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Sep 12 12:06:41 mirek-nb kernel: xc2028 3-0061: Loading firmware for 
type=BASE (1), id 0000000000000000.
Sep 12 12:06:42 mirek-nb kernel: xc2028 3-0061: Loading firmware for 
type=(0), id 000000000000b700.
Sep 12 12:06:42 mirek-nb kernel: SCODE (20000000), id 000000000000b700:
Sep 12 12:06:42 mirek-nb kernel: xc2028 3-0061: Loading SCODE for 
type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Sep 12 12:06:43 mirek-nb kernel: em28xx #0: Config register raw data: 0x58
Sep 12 12:06:43 mirek-nb kernel: em28xx #0: AC97 vendor ID = 0x83847652
Sep 12 12:06:43 mirek-nb kernel: em28xx #0: AC97 features = 0x6a90
Sep 12 12:06:43 mirek-nb kernel: em28xx #0: Sigmatel audio processor 
detected(stac 9752)
Sep 12 12:06:43 mirek-nb kernel: tvp5150 3-005c: tvp5150am1 detected.
Sep 12 12:06:43 mirek-nb kernel: em28xx #0: v4l2 driver version 0.1.2
Sep 12 12:06:43 mirek-nb kernel: em28xx #0: V4L2 device registered as 
/dev/video1 and /dev/vbi0
Sep 12 12:06:43 mirek-nb kernel: xc2028 3-0061: attaching existing instance
Sep 12 12:06:43 mirek-nb kernel: xc2028 3-0061: type set to XCeive 
xc2028/xc3028 tuner

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
