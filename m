Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34813 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339Ab0DNBp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 21:45:26 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC466A1.3070403@pobox.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
	 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
	 <1270961760.5365.14.camel@palomino.walls.org>
	 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
	 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
	 <1271107061.3246.52.camel@palomino.walls.org> <4BC3D578.9060107@pobox.com>
	 <4BC3D73D.5030106@pobox.com>  <4BC3D81E.9060808@pobox.com>
	 <1271154932.3077.7.camel@palomino.walls.org>  <4BC466A1.3070403@pobox.com>
Content-Type: text/plain
Date: Tue, 13 Apr 2010 21:45:20 -0400
Message-Id: <1271209520.4102.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-04-13 at 08:42 -0400, Mark Lord wrote:
> On 13/04/10 06:35 AM, Andy Walls wrote:
> > On Mon, 2010-04-12 at 22:34 -0400, Mark Lord wrote:
> ..
> >> As soon as I quit from LiveTV, the next recording still needed
> >> a new fallback.  So the chip is still in some weird state where
> >> auto-audio will continue to fail until I reload the module.
> ..
> > The *only* other thing I can think of, that I have control over, is the
> > PLL charge pump current in the analog tuner.  Right now it is set to low
> > current to minimize phase noise when tuned to a channel.  Perhaps
> > setting the PLL charge pump to high current while chaning the channel to
> > get a faster lock, and low current after a short time, will help get a
> > good SIF output from the analog tuner assembly sooner.  Perhaps when I
> > have time....
> ..
> 
> What's weird, is that things work most of the time.
> But as soon as one fallback is needed, the chip then fails
> continuously afterward, requiring fallback after fallback.
> Until the driver is reloaded.

Hmmm.  Interesting observation. 

> So to me, that suggests that perhaps some register has gotten corrupted,
> or some part of the chip has gone wanky.
>
> Perhaps if the driver could re-init more of the chip when tuning,
> which might correct whatever bits/state happen to need fixing?

If needed, once we're in a forced mode, we could stop the
microcontroller, reload all of the microcontroller firmware, and restart
it.  Kind of heavy handed, but it may work.


> I might have a look later, and see if there are any obvious registers
> that perhaps I could have it dump out prior to doing the fallback,
> and then compare that state with a "good" tuning state.  Or something.


# v4l2-dbg -d /dev/video0 -c host1 --list-registers=min=0x800,max=0x9ff

Keep in mind that some of these registers aren't settable and only read
out the state of various hardware blocks and functions.


Dumping the state of the microcontroller memory could also be done, but
I'd have to modify the driver to do it.
cx18-av-firmware.c:cx18_av_verifyfw() has code that's really close to
doing that.

Regards,
Andy

