Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53800 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab0DMKgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 06:36:52 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC3D81E.9060808@pobox.com>
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
Content-Type: text/plain
Date: Tue, 13 Apr 2010 06:35:32 -0400
Message-Id: <1271154932.3077.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-04-12 at 22:34 -0400, Mark Lord wrote:
> On 12/04/10 10:30 PM, Mark Lord wrote:
> ..
> > Mmm.. further to that: the problem went away as soon as I told
> > it to tune to a different channel. No more fallbacks (for now).
> > It can now even retune the original channel without fallbacks.
> >
> > So.. tuning to a new channel appears to fix whatever the bad state was
> > that was triggering the fallbacks. Based on my sample of one, anyway. ;)
> ..
> 
> Nope.. what that second email should have said, was
> Changing channels in LiveTV, no fallbacks required
> because the audio is already working from the initial fallback.
> 
> As soon as I quit from LiveTV, the next recording still needed
> a new fallback.  So the chip is still in some weird state where
> auto-audio will continue to fail until I reload the module.


Thansk you for all the testing and feedback.

At this point I'm going to brush up the fixes by properly incorporating
support for the cx18_av_g_tuner()/cx18_av_s_tuner() calls so that user
space can still influence the audio mode (mono, stereo, Lang1, lang2,
etc.) even when audio standard and format are forced.  I'll have time on
Friday for this.



The *only* other thing I can think of, that I have control over, is the
PLL charge pump current in the analog tuner.  Right now it is set to low
current to minimize phase noise when tuned to a channel.  Perhaps
setting the PLL charge pump to high current while chaning the channel to
get a faster lock, and low current after a short time, will help get a
good SIF output from the analog tuner assembly sooner.  Perhaps when I
have time....

Regards,
Andy


