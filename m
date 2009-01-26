Return-path: <linux-media-owner@vger.kernel.org>
Received: from web23205.mail.ird.yahoo.com ([217.146.189.60]:44142 "HELO
	web23205.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752680AbZAZMPs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 07:15:48 -0500
Date: Mon, 26 Jan 2009 12:09:05 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Reply-To: newspaperman_germany@yahoo.com
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on HDchannels
To: linux-media@vger.kernel.org
In-Reply-To: <000f01c97f85$c013f0c0$f4c6a5c1@tommy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <283238.10141.qm@web23205.mail.ird.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the transponders you don't get lock are problem transponders of s2-3200.
The driver is still not able to lock on dvb-s2 30000 3/4 transponders :(

Which software do you use to play HD content?
you need either xine-lib 1.2 with external ffmpeg (recent developer's version).
or xine-vdpau (if you have a NVIDIA graka that supports h264 hw acceleration).

regards 

Newsy


--- Tomas Drajsajtl <linux-dvb@drajsajtl.cz> schrieb am Mo, 26.1.2009:

> Von: Tomas Drajsajtl <linux-dvb@drajsajtl.cz>
> Betreff: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on HDchannels
> An: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
> Datum: Montag, 26. Januar 2009, 8:14
> > Nat Geo HD and Histoy Channel HD are the only two HD
> channels I can
> > lock, and I have problems with digital artefacts,
> lines across the
> > screen missing data and tons of errors from the
> frontend. See below for
> > error log.
> 
> Hi Jonas,
> just guessing - try another card slot. If there are more
> devices on one IRQ
> the transfer speed from the card can be lower and causing
> problems at
> channels with higher bitrate. I had similar colision
> between PCI network and
> sound cards. When I moved one card to another slot, the
> problem was solved.
> 
> Regards,
> Tomas
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead
> linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      
