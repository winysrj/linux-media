Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.2]:34356 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0BDWMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 17:12:19 -0500
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2124.sfr.fr (SMTP Server) with ESMTP id 832157000092
	for <linux-media@vger.kernel.org>; Thu,  4 Feb 2010 23:12:17 +0100 (CET)
Received: from linux-542s.localnet (unknown [77.84.220.147])
	by msfrf2124.sfr.fr (SMTP Server) with ESMTP id 5FFB07000088
	for <linux-media@vger.kernel.org>; Thu,  4 Feb 2010 23:12:17 +0100 (CET)
From: "ftape-jlc" <ftape-jlc@club-internet.fr>
Reply-To: ftape-jlc@club-internet.fr
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: HVR1120 with saa7134 module
Date: Thu, 4 Feb 2010 23:13:03 +0100
MIME-Version: 1.0
Message-Id: <201002042313.03188.ftape-jlc@club-internet.fr>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am user of Hauppauge HVR1120, using saa7134 module, and I have problem with 
radio FM use in linux mode.

Distribution OpenSuse11.2
Kernel 2.6.31.8-0.1-desktop
Firmware dvb-fe-tda10048-1.0.fw loaded

Analog and Digital Television are OK in both Windows and Linux.
Windows is using Hauppauge WinTV7 v7.027313

Linux is using Kaffeine v1.0-pre2 for Digital Television
Linux is using mplayer for analog TV like:
mplayer tv:// -tv driver=v4l2:freq=495.750:norm=SECAM-
L:input=0:audiorate=32000:immediatemode=0:alsa:forceaudio:adevice=hw.1,0:width=720:height=576:amode=1

The problem is to listen radio.
One radio station is OK at 91.5MHz stereo using WintTV7 in Windows.
With Linux, the command used is 
mplayer radio://91.5/capture/ -radio adevice=hw=1,0:arate=44100:achannels=2

The result is a non stable frecuency. The station is not tuned correctly.
The 91.5MHz station is mixed permanently with other stations.

How can I check saa7134 ?
Do you need saa7134 dmesg output ?

Regards,

ftape-jlc

