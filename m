Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.22]:46280 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0AKVlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 16:41:36 -0500
Received: from smtp23.services.sfr.fr (msfrf2308 [10.18.27.22])
	by msfrf2315.sfr.fr (SMTP Server) with ESMTP id 41CC0700F605
	for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 22:41:35 +0100 (CET)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2308.sfr.fr (SMTP Server) with ESMTP id E65FE70000A0
	for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 22:38:33 +0100 (CET)
Received: from linux-542s.localnet (unknown [87.100.60.13])
	by msfrf2308.sfr.fr (SMTP Server) with ESMTP id C7A5D7000087
	for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 22:38:33 +0100 (CET)
From: "ftape-jlc" <ftape-jlc@club-internet.fr>
Reply-To: ftape-jlc@club-internet.fr
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: FM radio problem with HVR1120
Date: Mon, 11 Jan 2010 22:39:07 +0100
MIME-Version: 1.0
Message-Id: <201001112239.07084.ftape-jlc@club-internet.fr>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am user of Huappuage HVR1120, and I have problem with radio FM use in linux 
mode.

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
/usr/bin/radio -c /dev/radio0
in association with
sox -t ossdsp -r 32000 -c 2 /dev/dsp1 -t ossdsp /dev/dsp
to listen the sound.

The result is an unstable frecuency. The station is not tuned. Stereo is 
permanently switching to mono.
The 91.5MHz station is mixed permanently with other stations.

How can I check v4l2 ?
Do you need dmesg output ?
Is this mailing list the right place to solve this problem ?

Thank you for your help.

Regards,

ftape-jlc


