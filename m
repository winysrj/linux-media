Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44655 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab0BJOZd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 09:25:33 -0500
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
 (DVB-S) and USB HVR Hauppauge 950q
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Richard Lemieux <rlemieu@cooptel.qc.ca>,
	linux-media@vger.kernel.org
In-Reply-To: <829197381002091912h5391129dpbf075485ab011936@mail.gmail.com>
References: <4B70E7DB.7060101@cooptel.qc.ca>
	 <1265768091.3064.109.camel@palomino.walls.org>
	 <4B722266.4070805@cooptel.qc.ca>
	 <829197381002091912h5391129dpbf075485ab011936@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 10 Feb 2010 09:24:29 -0500
Message-Id: <1265811869.4019.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-02-09 at 22:12 -0500, Devin Heitmueller wrote:
> On Tue, Feb 9, 2010 at 10:05 PM, Richard Lemieux <rlemieu@cooptel.qc.ca> wrote:
> > Andy,
> >
> > This is a great answer!  Thanks very much.  When I get into this situation
> > again
> > I will know what to look for.
> >
> > A possible reason why I got into this problem in the first place is that I
> > tried
> > many combinations of parameters with mplayer and azap in order to learn how
> > to use the USB tuner in both the ATSC and the NTSC mode.  I will look back
> > in the terminal history to see if I can find anything.
> 
> I think the key to figuring out the bug at this point is you finding a
> sequence where you can reliably reproduce the oops.  If we have that,
> then I can start giving you some code to try which we can see if it
> addresses the problem.

Also the verbose output of udevadm monitor (see man udevadm) would help
us get a feeling for the timing relationships for the firmware
requests.


> For example, I would start by giving you a fix which results in us not
> calling the firmware release if the request_firmware() call failed,
> but it wouldn't be much help if you could not definitively tell me if
> the problem is fixed.

Definitely.


Also, given the slow loading due to a chip I2C limitation, Richard, you
may just want to increase your firmware loading timeout:

$ su - root
Password:

# cat /sys/class/firmware/timeout 
10

# echo 90 > /sys/class/firmware/timeout

# cat /sys/class/firmware/timeout 
90

And see if the problem "goes away".  Again having some sort of steps to
reliably reproduce the oops would be helpful in determining the efficacy
of such a work around.

Regards,
Andy

> Devin


