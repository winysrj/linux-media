Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51657 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2FROXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 10:23:46 -0400
Received: by obbtb18 with SMTP id tb18so8541222obb.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 07:23:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340028940.32360.70.camel@obelisk.thedillows.org>
References: <1339994998.32360.61.camel@obelisk.thedillows.org>
	<201206180929.48107.hverkuil@xs4all.nl>
	<1340028940.32360.70.camel@obelisk.thedillows.org>
Date: Mon, 18 Jun 2012 10:23:46 -0400
Message-ID: <CAGoCfize92S-8cR9f-RjQDcZARKiT84UtX-oH0EcPomCYFAyxQ@mail.gmail.com>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Dillow <dave@thedillows.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 18, 2012 at 10:15 AM, David Dillow <dave@thedillows.org> wrote:
>> Tuner standards and frequencies must be persistent. So cx231xx is wrong.
>> Actually, all V4L2 settings must in general be persistent (there are
>> some per-filehandle settings when dealing with low-level subdev setups or
>> mem2mem devices).
>
> Is there a document somewhere I can reference; I need to go through the
> cx231xx driver and make sure it is doing the right things and it would
> be handy to have a checklist.

This isn't just the cx231xx driver.  Almost all USB devices that have
tuners which support power management have this problem
(em28xx/au0828/cx231xx with Xceive or tda18271 tuners).  Really the
tuner_core should be resending the set_params call to the tuner after
waking it up (it shouldn't be the tuner's responsibility to remember
its settings).

The other thing to watch out for is that the API is pretty brittle in
terms of cases where initializing the tuner takes a long time.  In the
case of the Xceive tuners it can take upwards of ten seconds on
devices with slow i2c busses (au0828 in particular due to a hardware
bug in clock stretching), and the 18271 initialization has a
"calibration loop" which can take 5-10 seconds.  Hence you would have
to be very careful in terms of figuring out where to put the call to
reset the tuner, since you don't want every call to v4l2-ctl taking
ten seconds.

And of course you don't want to leave the tuner running if it's no
longer in use (since it will run down the battery on laptops),
although figuring out when that is can be nearly impossible if the
sequence of events is a series of calls to the v4l2-ctl command line
tool followed by reading from the device node.

I'm certainly in favor of this long-standing problem being fixed, but
it will take considerable investigation to figure out the right place
to make the change.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
