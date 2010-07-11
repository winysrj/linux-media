Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:31377 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab0GKNXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jul 2010 09:23:04 -0400
Subject: Re: RFC: Use of s_std calling s_freq when tuner powered down
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTikYq6w4ELQntkKMF-PuB1JkO7Eu6kx5XqxSAnU6@mail.gmail.com>
References: <AANLkTikYq6w4ELQntkKMF-PuB1JkO7Eu6kx5XqxSAnU6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 09:23:34 -0400
Message-ID: <1278854614.2283.8.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-09 at 14:09 -0400, Devin Heitmueller wrote:
> Hello all,
> 
> Here's the scenario:
> 
> 1.  I have a USB device that supports both an analog tuner and
> composite/s-video inputs
> 2.  The bridge is smart enough to power down the tuner when capturing
> on composite/s-video
> 3.  Changing the video standard appears to send set_freq() calls to
> the tuner, which in i2c fail because it's powered down.
> 
> So I looked at the tuner-core code, and I'm seeing that tuner_s_std()
> will call set_freq() if the tuner->tv_freq field is nonzero.  This
> seems reasonable, except as far as I can tell there is no way to set
> it to zero (because the places that set the value to zero will return
> failure because zero is outside the tuning range).
> 
> This behavior happens with tvtime, which always does a tuning on
> startup, before switching to the A/V inputs.  While I agree that I
> should probably fix tvtime so it doesn't do this, it seems strange
> that there is no way to reset tv_freq to zero when toggling away from
> the tuner input, so that these errors don't occur.
> 
> Any thoughts?

At the risk of missing something obvious:

In your bridge driver's VIDIOC_S_STD ioctl()

a. power up the analog tuner if it is not already
b. call s_std for the subdevices (including the tuner),
c. power down that analog tuner if not using the tuner input.

No I2C errors in the log and the tuner is powered down when not in use,

IMO, VIDIOC_S_STD is not a timing critical operation from userspace and
it doesn't happen that often.  You can also filter the cases when
VIDIOC_S_STD is called on the same input, but the standard is not being
changed.

Regards,
Andy

>   Obviously I would like to eliminate the i2c errors from
> littering the dmesg log when there is no real failure condition.


> Devin


