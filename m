Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq1.gn.mail.iss.as9143.net ([212.54.34.164]:49646 "EHLO
	smtpq1.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435Ab0CURP1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 13:15:27 -0400
Received: from [212.54.34.134] (helo=smtp3.gn.mail.iss.as9143.net)
	by smtpq1.gn.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <joep@groovytunes.nl>)
	id 1NtOQz-0002CC-6z
	for linux-media@vger.kernel.org; Sun, 21 Mar 2010 17:55:29 +0100
Received: from 84-105-5-223.cable.quicknet.nl ([84.105.5.223] helo=werkstation.localnet)
	by smtp3.gn.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <joep@groovytunes.nl>)
	id 1NtOQo-0003ed-G0
	for linux-media@vger.kernel.org; Sun, 21 Mar 2010 17:55:18 +0100
From: joep admiraal <joep@groovytunes.nl>
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: prof 7300
Date: Sun, 21 Mar 2010 17:55:18 +0100
References: <201001171542.27314.joep@groovytunes.nl> <201001171742.54145.liplianin@me.by>
In-Reply-To: <201001171742.54145.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003211755.18165.joep@groovytunes.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op zondag 17 januari 2010 16:42:53 schreef Igor M. Liplianin:
> On 17 января 2010 16:42:27 joep admiraal wrote:
> > I had some troubles with a prof 7300 dvb s-2 card.
> > I am running OpenSuse 11.2 with a recent hg copy of the v4l-dvb
> > repository. It was detected as a Hauppauge WinTV instead of a prof 7300.
> > After some runs with info_printk statements I found a problem in
> > linux/drivers/media/video/cx88.c
> > As far as I can understand the code I would say card[core->nr] will
> > always be smaller than ARRAY_SIZE(cx88_boards).
> > Therefore core->boardnr is never looked up from the cx88_subids array.
> > After I removed the check with ARRAY_SIZE the correct card is detected
> > and I can watch tv with both my prof 7300 cards.
> > Can someone confirm if the patch I made is correct or explain what the
> > purpose is of the ARRAY_SIZE check?
> >
> >
> > For search references:
> > I was getting this error in dmesg:
> > cx88[1]/2: dvb_register failed (err = -22)
> > cx88[1]/2: cx8802 probe failed, err = -22
> >
> > Regards,
> > Joep Admiraal
> 
> Do/did you have another TV tuner?
> Please check file /etc/modprobe.conf or files in /etc/modprobe.d/ for line
>  like this options cx88xx card=n
> Then remove the line
> 
> You can try to check your card
> 	modprobe cx88xx card=75
> 

Hi Igor,

Today I finally checked the modprobe file.
Since this machine is running OpenSuse 11.2, I checked /etc/modprobe.d/50-
tv.conf.
I can confirm the line was present.
After removing it and rebooting the machine, the card was detected correctly.
This was off course tested without my hacked v4l.

Thanks for your help.
