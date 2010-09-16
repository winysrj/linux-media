Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:31232 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab0IPWsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 18:48:46 -0400
Subject: Re: HVR 1600 Distortion
From: Andy Walls <awalls@md.metrocast.net>
To: Josh Borke <joshborke@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTimt5bs1fNp=+36VLaTy0Kwi1rDPcpUTeN4z+c35@mail.gmail.com>
References: <AANLkTimt5bs1fNp=+36VLaTy0Kwi1rDPcpUTeN4z+c35@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 18:48:45 -0400
Message-ID: <1284677325.2056.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2010-09-15 at 22:54 -0400, Josh Borke wrote:
> I've recently noticed some distortion coming from my hvr1600 when
> viewing analog channels.  It happens to all analog channels with some
> slightly better than others.  I am running Fedora 12 linux with kernel
> version 2.6.32.21-166.


> I know I need to include more information but I'm not sure what to
> include.  Any help would be appreciated.

1. Would you say the distortion is something you would possibly
encounter on an analog television set, or does it look "uniquely
digital"?  On systems with a long uptime and lots of usage, MPEG encoder
firmware could wind up in a screwed up state giving weird output image.
Simple solution in this case is to reboot.

2. Have you ensured your cable plant isn't affecting signal integrity?
http://ivtvdriver.org/index.php/Howto:Improve_signal_quality


3. Does this happen with only the RF tuner or only CVBS or only SVideo
or more than one of them?  If the problem is only with RF, then it could
be an incoming signal distortion problem.  Do you have cable or an over
the air antenna for analog RF?

4. What does v4l2-ctl --log-status show as your analog tuner?

5. Do you have a kernel with the new concurrency managed workqueues?
On these kernels 'ps axf' will *not* show kernel threads with names like
[cx18-0-in], [cx18-0-out/0], [cx18-0-out/1].  This is a major kernel
change which could cause some MPEG buffers to be lost or reordered, if
the new workqueue implementation has bugs.

6. Have you recently installed new hardware in the subject computer?  Of
most interest are adapter cards with cables coming off of them and cards
very close to the HVR-1600.  EMI can be picked up by the HVR-1600's
board traces that are not shielded.

7. Does the distortion look like loss of horizontal line sync and happen
only near very bright parts of the image on the left edge?  If it does,
the baseband video signal level is too high.

8. Care to post a short image in a paste bin or email a small MPEG to
me?

Regards,
Andy


