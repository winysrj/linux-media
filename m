Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <linuxtv@nzbaxters.com>) id 1OfIDh-0003T5-6L
	for linux-dvb@linuxtv.org; Sat, 31 Jul 2010 21:59:45 +0200
Received: from auth-1.ukservers.net ([217.10.138.154])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OfIDg-0000n5-8L; Sat, 31 Jul 2010 21:59:44 +0200
Received: from wlgl04017 (203-97-171-185.cable.telstraclear.net
	[203.97.171.185])
	by auth-1.ukservers.net (Postfix smtp) with SMTP id 09E513586FF
	for <linux-dvb@linuxtv.org>; Sat, 31 Jul 2010 20:59:42 +0100 (BST)
Message-ID: <B17A774B76B64B25A20875E6A0F875A0@telstraclear.tclad>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-dvb@linuxtv.org>
Date: Sun, 1 Aug 2010 07:59:42 +1200
MIME-Version: 1.0
Subject: [linux-dvb] dvb-apps testing conditional interface
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

Hi

I'm having a problem with the s2-liplianin drivers (and vdr-1.7.15) and my 
TT-1500/TT-2300 cards.   I've also tried the bundled dvb drivers in Fedora 
13 2.6.32 kernel with the same results.

Problem is, when I tune to any channel in VDR I get 2-3 seconds of live TV 
and then vdr reports the TS thread ended and "SetPlayMode: 0".

When I run vdr-1.6.0 and v4l-dvb drivers, I have no problems.

Can someone please tell me how to test this outside of VDR?  How do I zap 
and receive a channel, which has to go through the CAM?


My CI logs look like this:

SetPlayMode: 1
Slot 2: ==> Date Time (4)
     2: --> 01 01 A0 10 01 90 02 00 04 9F 84 41 07 D8 70 07 24 57 00 02
Slot 2: receive data 1/1
     2: --> 01 01 81 01 01
     2: <-- 01 01 A0 07 01 91 04 00 40 00 41 80 02 01 00
            .  .  .  .  .  .  .  .  @  .  A  .  .  .  .
Slot 2: open session 00400041
Slot 2: new MMI (session id 5)
     2: --> 01 01 A0 0A 01 92 07 00 00 40 00 41 00 05
Slot 2: receive data 1/1
     2: --> 01 01 81 01 01
     2: <-- 01 01 A0 82 00 0B 01 90 02 00 05 9F 88 01 02 01 01 80 02 01 00
            .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
Slot 2: <== Display Control (5)
Slot 2: ==> Display Reply (5)
     2: --> 01 01 A0 0B 01 90 02 00 05 9F 88 02 02 01 01
Slot 2: receive data 1/1
     2: --> 01 01 81 01 01
     2: <-- 01 01 A0 82 00 61 01 90 02 00 05 9F 88 0C 58 02 9F 88 03 0B 97
41 6C 70 68 61 43 72 79 70 74 9F 88 03 01 20 9F 88 03 08 50 72 65 73 73 20
4F 4B 9F 88 03 14 59 6F 75 20 61 72 65 20 6E 6F 74 20 65 6E 74 69 74 6C 65
64 9F 88 03 1B 74 6F 20 72 65 63 65 69 76 65 20 74 68 69 73 20 70 72 6F 67
72 61 6D 6D 65 20 21 80 02 01 00
            .  .  .  .  .  a  .  .  .  .  .  .  .  .  X  .  .  .  .  .  .  A
l  p  h  a  C  r  y  p  t  .  .  .  .     .  .  .  .  P  r  e  s  s     O  K
.  .  .  .  Y  o  u     a  r  e     n  o  t     e  n  t  i  t  l  e  d  .  .
.  .  t  o     r  e  c  e  i  v  e     t  h  i  s     p  r  o  g  r  a  m  m
e     !  .  .  .  .
Slot 2: <== Menu Last (5)
Slot 2: <== Text Last (5) 'AlphaCrypt'
Slot 2: <== Text Last (5) ''
Slot 2: <== Text Last (5) 'Press OK'
Slot 2: <== Text Last (5) 'You are not entitled'
Slot 2: <== Text Last (5) 'to receive this programme !'
SetPlayMode: 0


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
