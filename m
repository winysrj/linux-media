Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60734 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZDNC30 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 22:29:26 -0400
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: Corey Taylor <johnfivealive@yahoo.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	ivtv-users@ivtv-driver.org
In-Reply-To: <de8cad4d0903310302s2df38ba8re605fc0cc3a4f266@mail.gmail.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
	 <1237425168.3303.94.camel@palomino.walls.org>
	 <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
	 <871136.15243.qm@web56908.mail.re3.yahoo.com>
	 <1238297237.3235.42.camel@palomino.walls.org>
	 <de8cad4d0903290725t2e7764a8pe2c0d1b7d67ea8c4@mail.gmail.com>
	 <de8cad4d0903310302s2df38ba8re605fc0cc3a4f266@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 23:26:07 -0400
Message-Id: <1239679567.3163.85.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-31 at 06:02 -0400, Brandon Jenkins wrote:
> >>
> >> Corey and Brandon,
> >>
> >> I found a race condition between the cx driver and the CX23418 firmware.
> >> I have a patch that mitigates the problem here:
> >>
> >> http://linuxtv.org/hg/~awalls/cx18/rev/9f5f44e0ce6c
> >>
> >> I think the final form of the patch could be better.  However, this
> >> patch essentially eliminated any artifacts I was getting playing back
> >> digital TV.  I also had positive results running mplayer without the
> >> "-cache" command line for both digital and analog captures.
> >>
> >> I haven't tested on a single processor machine, nor in a multicard
> >> setup, but things looked good enough that I thought it ready for test by
> >> others.
> >>
> >> Let me know if it helps or not.
> >>
> >> Regards,
> >> Andy
> >>

> Andy,
> 
> Based on continued discussions it seems you're still exploring things.
> I can tell you that the analog captures are still exhibiting
> artifacts. I'll get to some of the HD captures tonight.
> 
> Brandon

Brandon and Corey,

I have a series of changes to improve performance of the cx18 driver in
delivering incoming buffers to applications.  Please test the code here
if you'd like:

http://linuxtv.org/hg/~awalls/cx18-perf/

These patches remove all the sleeps from incoming buffer handling
(unless your system starts getting very far behind, in which case a
fallback strategy starts letting sleeps happen again).


If you still have performance problems, there is one more patch I can
add, that avoids some sleeps in the new work handler threads that pass
empty buffers back out to the firmware.  A copy of that patch is here:

http://linuxtv.org/hg/~awalls/cx18/rev/b42156ceee11



The trade-off I had to make with all these patches was to have the
cx18-driver prefer to "spin" rather than "sleep" when waiting for a
resource (i.e. the capture stream buffer queues), while handling
incoming buffers.  This makes the live playback much nicer, but at the
expense of CPU cycles and perhaps total system throughput for other
things.  I'd be interested in how a multicard multistream capture fares.



BTW, the above cx18-perf repo is missing a very small patch to fix a
recent bug with line-in audio not working.  If you need line-in audio to
work during testing, a patch is in the main v4l-dvb repo already:

http://linuxtv.org/hg/v4l-dvb/rev/d19938a76e7a


Regards,
Andy

