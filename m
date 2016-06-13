Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34821 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422913AbcFMLrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 07:47:19 -0400
Date: Mon, 13 Jun 2016 13:47:13 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@vger.kernel.org, netdev@vger.kernel.org,
	henrk@austad.us, Arnd Bergmann <arnd@linaro.org>
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
Message-ID: <20160613114713.GA9544@localhost.localdomain>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465686096-22156-1-git-send-email-henrik@austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Henrik,

On Sun, Jun 12, 2016 at 01:01:28AM +0200, Henrik Austad wrote:
> There are at least one AVB-driver (the AV-part of TSN) in the kernel
> already,

Which driver is that?

> however this driver aims to solve a wider scope as TSN can do
> much more than just audio. A very basic ALSA-driver is added to the end
> that allows you to play music between 2 machines using aplay in one end
> and arecord | aplay on the other (some fiddling required) We have plans
> for doing the same for v4l2 eventually (but there are other fishes to
> fry first). The same goes for a TSN_SOCK type approach as well.

Please, no new socket type for this.
 
> What remains
> - tie to (g)PTP properly, currently using ktime_get() for presentation
>   time
> - get time from shim into TSN and vice versa

... and a whole lot more, see below.

> - let shim create/manage buffer

(BTW, shim is a terrible name for that.)

[sigh]

People have been asking me about TSN and Linux, and we've made some
thoughts about it.  The interest is there, and so I am glad to see
discussion on this topic.

Having said that, your series does not even begin to address the real
issues.  I did not review the patches too carefully (because the
important stuff is missing), but surely configfs is the wrong
interface for this.  In the end, we will be able to support TSN using
the existing networking and audio interfaces, adding appropriate
extensions.

Your patch features a buffer shared by networking and audio.  This
isn't strictly necessary for TSN, and it may be harmful.  The
Listeners are supposed to calculate the delay from frame reception to
the DA conversion.  They can easily include the time needed for a user
space program to parse the frames, copy (and combine/convert) the
data, and re-start the audio transfer.  A flexible TSN implementation
will leave all of the format and encoding task to the userland.  After
all, TSN will some include more that just AV data, as you know.

Lets take a look at the big picture.  One aspect of TSN is already
fully supported, namely the gPTP.  Using the linuxptp user stack and a
modern kernel, you have a complete 802.1AS-2011 solution.

Here is what is missing to support audio TSN:

* User Space

1. A proper userland stack for AVDECC, MAAP, FQTSS, and so on.  The
   OpenAVB project does not offer much beyond simple examples.

2. A user space audio application that puts it all together, making
   use of the services in #1, the linuxptp gPTP service, the ALSA
   services, and the network connections.  This program will have all
   the knowledge about packet formats, AV encodings, and the local HW
   capabilities.  This program cannot yet be written, as we still need
   some kernel work in the audio and networking subsystems.

* Kernel Space

1. Providing frames with a future transmit time.  For normal sockets,
   this can be in the CMESG data.  For mmap'ed buffers, we will need a
   new format.  (I think Arnd is working on a new layout.)

2. Time based qdisc for transmitted frames.  For MACs that support
   this (like the i210), we only have to place the frame into the
   correct queue.  For normal HW, we want to be able to reserve a time
   window in which non-TSN frames are blocked.  This is some work, but
   in the end it should be a generic solution that not only works
   "perfectly" with TSN HW but also provides best effort service using
   any NIC.

3. ALSA support for tunable AD/DA clocks.  The rate of the Listener's
   DA clock must match that of the Talker and the other Listeners.
   Either you adjust it in HW using a VCO or similar, or you do
   adaptive sample rate conversion in the application. (And that is
   another reason for *not* having a shared kernel buffer.)  For the
   Talker, either you adjust the AD clock to match the PTP time, or
   you measure the frequency offset.

4. ALSA support for time triggered playback.  The patch series
   completely ignore the critical issue of media clock recovery.  The
   Listener must buffer the stream in order to play it exactly at a
   specified time.  It cannot simply send the stream ASAP to the audio
   HW, because some other Listener might need longer.  AFAICT, there
   is nothing in ALSA that allows you to say, sample X should be
   played at time Y.

These are some ideas about implementing TSN.  Maybe some of it is
wrong (especially about ALSA), but we definitely need a proper design
to get the kernel parts right.  There is plenty of work to do, but we
really don't need some hacky, in-kernel buffer with hard coded audio
formats.

Thanks,
Richard
