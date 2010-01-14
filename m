Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.1]:13042 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab0AOAA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 19:00:57 -0500
Received: from smtp21.services.sfr.fr (msfrf2108 [10.18.25.22])
	by msfrf2105.sfr.fr (SMTP Server) with ESMTP id 9E2267003A3E
	for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 00:53:28 +0100 (CET)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2108.sfr.fr (SMTP Server) with ESMTP id 73AF0700008C
	for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 00:50:26 +0100 (CET)
Received: from linux-542s.localnet (unknown [87.100.60.13])
	by msfrf2108.sfr.fr (SMTP Server) with ESMTP id 534A17000087
	for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 00:50:26 +0100 (CET)
From: "ftape-jlc" <ftape-jlc@club-internet.fr>
Reply-To: ftape-jlc@club-internet.fr
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: FM radio problem with HVR1120
Date: Fri, 15 Jan 2010 00:50:04 +0100
References: <201001112239.07084.ftape-jlc@club-internet.fr>
In-Reply-To: <201001112239.07084.ftape-jlc@club-internet.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001150050.04652.ftape-jlc@club-internet.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I didn't received any answer.
Did anyone used Hauppauge card with v4l2 in recent kernel to listen FM radio ?

I am not current user of the mailing list. Please confirm if it is right place 
for this problem.

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


