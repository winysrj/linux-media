Return-path: <linux-media-owner@vger.kernel.org>
Received: from jim.sh ([75.150.123.25]:51870 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZH2QcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 12:32:17 -0400
Date: Sat, 29 Aug 2009 12:32:12 -0400
From: Jim Paris <jim@jtan.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-media@vger.kernel.org,
	moinejf@free.fr
Subject: Re: [Fwd: How to debug problem with Playstation Eye webcam?]
Message-ID: <20090829163211.GA23792@psychosis.jim.sh>
References: <1251508203.3200.34.camel@palomino.walls.org> <20090829173527.5cb7fb76.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090829173527.5cb7fb76.ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antonio Ospite wrote:
> > -------- Forwarded Message --------
> > From: Tim Bird <tim.bird@am.sony.com>
> 
> > I'm trying to get a Playstation Eye webcam working under a new install of
> > Fedora 11 and not having much luck.
> > 
> > I'm running a stock Fedora kernel (2.6.29.4).
> >
> 
> Hi Tim,
> 
> before doing any further investigation about code in 2.6.29.4, forgive
> the silly question: is using a more recent kernel/driver an option for
> you?
> I've just tried latest code from v4l-dvb and it "just works" with the
> applications I use. You can get the mercurial repository here
> http://linuxtv.org/hg/v4l-dvb
> 
> I know that there was a regression in 2.6.30 (not sure about 2.6.29.4)
> and a patch has been sent by Jim Paris to fix it, I don't know if it is
> already in a 2.6.30.x release, tho. The change is this one:
> http://patchwork.kernel.org/patch/42114/

I believe 2.6.29.4 should be okay.  However, the Fedora folks might
have pulled some newer patches which also added the bug.  You might
try a stock 2.6.29.4 kernel instead of Fedora's, or just apply the
patch that Antonio refers to (if thta's the problem).

If your kernel does have the same bug, the symptoms would be as you
described, with the camera's red LED turning on during an attempted
capture.  Do you get the red LED?

You would also probably see the same problem, regardless of kernel
version, if the camera were connected to a full-speed instead of
high-speed USB port.

> I tested the driver with "mplayer" and "luvcview" during development,
> and I am now using it with "cheese", I've never run v4l-test.

Agreed.  luvcview is probably the easiest to test with, and I can
provide command lines for mplayer, ffmpeg, etc, if necessary.

-jim


