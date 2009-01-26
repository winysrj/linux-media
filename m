Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web23204.mail.ird.yahoo.com ([217.146.189.59])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1LRSdj-00054A-Jy
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 15:40:40 +0100
Date: Mon, 26 Jan 2009 14:40:05 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <640929.18092.qm@web23204.mail.ird.yahoo.com>
Subject: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on
	HDchannels
Reply-To: linux-media@vger.kernel.org, newspaperman_germany@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

the transponders you don't get lock are problem transponders of s2-3200.
The driver is still not able to lock on dvb-s2 30000 3/4 transponders :(

Which software do you use to play HD content?
you need either xine-lib 1.2 with external ffmpeg (recent developer's version).
or xine-vdpau (if you have a NVIDIA graka that supports h264 hw acceleration).

regards

Newsy


--- Newsy Paper <newspaperman_germany@yahoo.com> schrieb am Mo, 26.1.2009:

> Von: Newsy Paper <newspaperman_germany@yahoo.com>
> Betreff: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on HDchannels
> An: linux-media@vger.kernel.org
> Datum: Montag, 26. Januar 2009, 13:09
> the transponders you don't get lock are problem
> transponders of s2-3200.
> The driver is still not able to lock on dvb-s2 30000 3/4
> transponders :(
> 
> Which software do you use to play HD content?
> you need either xine-lib 1.2 with external ffmpeg (recent
> developer's version).
> or xine-vdpau (if you have a NVIDIA graka that supports
> h264 hw acceleration).
> 
> regards 
> 
> Newsy
> 
> 
> --- Tomas Drajsajtl <linux-dvb@drajsajtl.cz> schrieb
> am Mo, 26.1.2009:
> 
> > Von: Tomas Drajsajtl <linux-dvb@drajsajtl.cz>
> > Betreff: Re: [linux-dvb] Technotrend Budget S2-3200
> Digital artefacts on HDchannels
> > An: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
> > Datum: Montag, 26. Januar 2009, 8:14
> > > Nat Geo HD and Histoy Channel HD are the only two
> HD
> > channels I can
> > > lock, and I have problems with digital artefacts,
> > lines across the
> > > screen missing data and tons of errors from the
> > frontend. See below for
> > > error log.
> > 
> > Hi Jonas,
> > just guessing - try another card slot. If there are
> more
> > devices on one IRQ
> > the transfer speed from the card can be lower and
> causing
> > problems at
> > channels with higher bitrate. I had similar colision
> > between PCI network and
> > sound cards. When I moved one card to another slot,
> the
> > problem was solved.
> > 
> > Regards,
> > Tomas
> > 
> > 
> > _______________________________________________
> > linux-dvb users mailing list
> > For V4L/DVB development, please use instead
> > linux-media@vger.kernel.org
> > linux-dvb@linuxtv.org
> >
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
