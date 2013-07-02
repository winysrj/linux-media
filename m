Return-path: <linux-media-owner@vger.kernel.org>
Received: from back1.argonit.cz ([37.46.80.52]:54337 "EHLO back1.argonit.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3GBIqP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jul 2013 04:46:15 -0400
To: <linux-media@vger.kernel.org>
Subject: Transponder issue with cx23885
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 02 Jul 2013 10:38:25 +0200
From: =?UTF-8?Q?Lubo=C5=A1_Dole=C5=BEel?= <lubos@dolezel.info>
Message-ID: <4efe057e9066ee0e3717a30e53bd26ed@dolezel.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hi,

 I have multiple DVB cards, two of them are based on cx23885 (Tevii 
 S471).
 Ever since the transponder 12207V on 23.5E increased its FEC to 5/6 
 (8PSK. SR 27500), with the bitrate exceeding 60 Mbps, I cannot properly 
 receive any channels on it with the cx23885-based cards. Other cards, 
 even ordinary set-top boxes, work fine.

 It seems that this problem is common for all other high-FEC 8PSK 
 transponders on this position.

 When using w_scan, I get this problem with 12207V:

 (time: 02:32) (time: 02:33) signal ok:
         S2 f = 12207 kHz V SR = 27500  5/6 0,35  8PSK
 Info: no data from NIT(actual)


 And this stuff with other transponders like this one:

 (time: 02:49) (time: 02:51) signal ok:
         S2 f = 12304 kHz H SR = 27500  5/6 0,35  8PSK
 WARNING: received garbage data: crc = 0x0b4533eb; expected crc = 
 0x37a28f06
 increasing filter timeout.
 WARNING: received garbage data: crc = 0x17593b3f; expected crc = 
 0x37a28f06
 WARNING: received garbage data: crc = 0xc41b44f4; expected crc = 
 0x37a28f06

 scan-s2 is able to find channels on 12207V, but without channel names. 
 When playing any of the channels, I get no picture and no sound, with 
 the BER being reported at around ~9000 (which is also nonsense, as 
 confirmed by other HW).

 It also seems that this problem is encountered in other devices too: 
 http://www.linuxtv.org/pipermail/vdr/2012-November/026868.html

 Any ideas, thoughts?

 Thanks!
-- 
 Luboš Doležel

