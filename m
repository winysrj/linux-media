Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.1]:10658 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0AYT3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 14:29:00 -0500
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2104.sfr.fr (SMTP Server) with ESMTP id CE9F2700008B
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 20:28:55 +0100 (CET)
Received: from linux-542s.localnet (unknown [77.84.220.206])
	by msfrf2104.sfr.fr (SMTP Server) with ESMTP id AA8827000094
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 20:28:55 +0100 (CET)
From: "ftape-jlc" <ftape-jlc@club-internet.fr>
Reply-To: ftape-jlc@club-internet.fr
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Fwd: Re: FM radio problem with HVR1120
Date: Mon, 25 Jan 2010 20:29:11 +0100
MIME-Version: 1.0
Message-Id: <201001252029.12009.ftape-jlc@club-internet.fr>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I didn't received any message about radio on HVR1120.
I just want to know if the use /dev/radio0 is deprecated in v4l2 today.
In the mails, I only read messages about video or TV.

Did one user of the mailing list have tested actual v4l2 on /dev/radio0 ?

Thank you for your help,

Regards,

ftape-jlc

Le lundi 11 janvier 2010, ftape-jlc a écrit :
> Hello,
> 
> I am user of Huappuage HVR1120, and I have problem with radio FM use in
>  linux mode.
> 
> Distribution OpenSuse11.2
> Kernel 2.6.31.8-0.1-desktop
> Firmware dvb-fe-tda10048-1.0.fw loaded
> 
> Analog and Digital Television are OK in both Windows and Linux.
> Windows is using Hauppauge WinTV7 v7.027313
> 
> Linux is using Kaffeine v1.0-pre2 for Digital Television
> Linux is using mplayer for analog TV like:
> mplayer tv:// -tv driver=v4l2:freq=495.750:norm=SECAM-
> L:input=0:audiorate=32000:immediatemode=0:alsa:forceaudio:adevice=hw.1,0:wi
> dth=720:height=576:amode=1
> 
> The problem is to listen radio.
> One radio station is OK at 91.5MHz stereo using WintTV7 in Windows.
> With Linux, the command used is
> /usr/bin/radio -c /dev/radio0
> in association with
> sox -t ossdsp -r 32000 -c 2 /dev/dsp1 -t ossdsp /dev/dsp
> to listen the sound.
> 
> The result is an unstable frecuency. The station is not tuned. Stereo is
> permanently switching to mono.
> The 91.5MHz station is mixed permanently with other stations.
> 
> How can I check v4l2 ?
> Do you need dmesg output ?
> Is this mailing list the right place to solve this problem ?
> 
> Thank you for your help.
> 
> Regards,
> 
> ftape-jlc
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-------------------------------------------------------

