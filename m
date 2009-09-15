Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60279 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbZIOKlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 06:41:10 -0400
Date: Tue, 15 Sep 2009 12:41:06 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: James Blanford <jhblanford@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Race in gspca main or missing lock in stv06xx subdriver?
Message-ID: <20090915124106.35ad1382@tele>
In-Reply-To: <20090914111757.543c7e77@blackbart.localnet.prv>
References: <20090914111757.543c7e77@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Sep 2009 11:17:57 -0400
James Blanford <jhblanford@gmail.com> wrote:

> Howdy folks,
> 
> I have my old quickcam express webcam working, with HDCS1000
> sensor, 046d:840. It's clearly throwing away every other frame.  What
> seems to be happening is, while the last packet of the previous frame
> is being analyzed by the subdriver, the first packet of the next frame
> is assigned to the current frame buffer.  By the time that packet is
> analysed and sent back to the main driver, it's frame buffer has been
> completely filled and marked as "DONE."  The entire frame is then
> marked for "DISCARD."  This does _not_ happen with all cams using this
> subdriver.
> 
> Here's a little patch, supplied only to help illustrate the problem,
> that allows for the full, expected frame rate of the webcam.  What it
> does is wait until the very last moment to assign a frame buffer to
> any packet, but the last.  I also threw in a few printks so I can see
> where failure takes place without wading through a swamp of debug
> output.
	[snip]
> It works, at least until there is any disruption to the stream, such
> as an exposure change, and then something gets out of sync and it
> starts throwing out every other frame again.  It shows that the driver
> framework and USB bus is capable of handling the full frame rate.
> 
> I'll keep looking for an actual solution, but there is a lot I don't
> understand.  Any suggestions or ideas would be appreciated.  Several
> questions come to mind.  Why bother assigning a frame buffer with
> get_i_frame, before it's needed?  What purpose has frame_wait, when
> it's not called until the frame is completed and the buffer is marked
> as "DONE."  Why are there five, fr_i fr_q fr_o fr_queue index , buffer
> indexing counters?  I'm sure I don't understand all the different
> tasks this driver has to handle and all the different hardware it has
> to deal with.  But I would be surprised if my cam is the only one
> this is happening with.

Hi James,

I think you may have found a big problem, and this one should exist in
all drivers!

As I understood, you say that the URB completion routine (isoc_irq) may
be run many times at the same time.

With gspca, the problem is critical: the frame queue is managed without
any lock thanks to a circular buffer list (the pointers fr_i, fr_q and
fr_o). This mechanism works well when there are only one producer
(interrupt) and one consumer (application) (and to answer the question,
get_i_frame can be called anywere in the interrupt function because the
application is not running). Then, if there may be many producers...

For other drivers, the problem remains: the image fragments could be
received out of order.

How is this possible? Looking at some kernel documents, I found that
the URB completion routine is called from the bottom-half entity (thus,
not under hardware interrupt). A bottom-half may be a tasklet or a soft
irq. There may be only one active tasklet at a time, while there may be
many softirqs running (on the interrupt CPU). It seems that we are in
the last case, and I could not find any mean to change that.

Then, to fix this problem, I see only one solution: have a private
tasklet to do the video streaming, as this is done for some bulk
transfer...

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
