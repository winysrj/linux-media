Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:55935 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2FROcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 10:32:47 -0400
Message-ID: <1340029964.23706.4.camel@obelisk.thedillows.org>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
From: David Dillow <dave@thedillows.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Mon, 18 Jun 2012 10:32:44 -0400
In-Reply-To: <CAGoCfize92S-8cR9f-RjQDcZARKiT84UtX-oH0EcPomCYFAyxQ@mail.gmail.com>
References: <1339994998.32360.61.camel@obelisk.thedillows.org>
	 <201206180929.48107.hverkuil@xs4all.nl>
	 <1340028940.32360.70.camel@obelisk.thedillows.org>
	 <CAGoCfize92S-8cR9f-RjQDcZARKiT84UtX-oH0EcPomCYFAyxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-06-18 at 10:23 -0400, Devin Heitmueller wrote:
> This isn't just the cx231xx driver.  Almost all USB devices that have
> tuners which support power management have this problem
> (em28xx/au0828/cx231xx with Xceive or tda18271 tuners).  Really the
> tuner_core should be resending the set_params call to the tuner after
> waking it up (it shouldn't be the tuner's responsibility to remember
> its settings).
> 
> The other thing to watch out for is that the API is pretty brittle in
> terms of cases where initializing the tuner takes a long time.  In the
> case of the Xceive tuners it can take upwards of ten seconds on
> devices with slow i2c busses (au0828 in particular due to a hardware
> bug in clock stretching), and the 18271 initialization has a
> "calibration loop" which can take 5-10 seconds.  Hence you would have
> to be very careful in terms of figuring out where to put the call to
> reset the tuner, since you don't want every call to v4l2-ctl taking
> ten seconds.
> 
> And of course you don't want to leave the tuner running if it's no
> longer in use (since it will run down the battery on laptops),
> although figuring out when that is can be nearly impossible if the
> sequence of events is a series of calls to the v4l2-ctl command line
> tool followed by reading from the device node.
> 
> I'm certainly in favor of this long-standing problem being fixed, but
> it will take considerable investigation to figure out the right place
> to make the change.

Hmm, it sounds like perhaps changing the standby call in the tuner core
to asynchronously power down the tuner may be the way to go -- ie, when
we tell it to standby, it will do a schedule_work for some 10 seconds
later to really pull it down. If we get a resume call prior to then,
we'll just cancel the work, otherwise we wait for the work to finish and
then issue the resume.

Does that sound reasonable?

