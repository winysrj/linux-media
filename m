Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54818 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab1BWVxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 16:53:34 -0500
Subject: Re: Question on V4L2 S_STD call
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>
References: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 16:53:41 -0500
Message-ID: <1298498021.2408.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-02-23 at 16:09 -0500, Devin Heitmueller wrote:
> Hello there,
> 
> I was debugging some PAL issues with cx231xx, and noticed some
> unexpected behavior with regards to selecting PAL standards.
> 
> In particular, tvtime has an option for PAL which corresponds to the
> underlying value "0xff".  This basically selects *any* PAL standard.
> However, the cx231xx has code for setting up the DIF which basically
> says:
> 
> if (standard & V4L2_STD_MN) {
>  ...
> } else if ((standard == V4L2_STD_PAL_I) |
>                         (standard & V4L2_STD_PAL_D) |
> 			(standard & V4L2_STD_SECAM)) {
>  ...
> } else {
>   /* default PAL BG */
>   ...
> }
> 
> As a result, if you have a PAL-B/G signal and select "PAL" in tvtime,
> the test passes for PAL_I/PAL_D/SECAM since that matches the bitmask.
> The result of course is garbage video.
> 
> So here is the question:
> 
> How are we expected to interpret an application asking for "PAL" in
> cases when the driver needs a more specific video standard?

Notwithstanding any bugs in how the driver handles the flags, the
specified behavior for drivers is pretty clear:

http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-std.html

"When the standard set is ambiguous drivers may return EINVAL or choose
any of the requested standards."

If you don't have standard autodetection before the DIF, your
safest bet is to have the driver return EINVAL, if you have flags 
that don't all fall into one of the compound statements in the if()
statement.

In the situation where you already have the DIF set up to a particular
standard, and that current standard matches one of the flags passed in,
you could alternatively leave it set to the currently set standard.

Regards,
Andy

> I can obviously add code to tvtime in the long term to have the user
> provide a more specific standard instead of "PAL", but since it is
> supported in the V4L2 spec, I would like to understand what the
> expected behavior should be in drivers.

> Devin



