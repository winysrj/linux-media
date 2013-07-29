Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53334 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3G2NTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 09:19:04 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so4147363wgg.4
        for <linux-media@vger.kernel.org>; Mon, 29 Jul 2013 06:19:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F59481.6050300@nrdvana.net>
References: <51F59481.6050300@nrdvana.net>
Date: Mon, 29 Jul 2013 09:19:02 -0400
Message-ID: <CAGoCfiy+vngm3_ZfDr1eac=W1uNfhygxCuK1q0H6qiATOi9L0g@mail.gmail.com>
Subject: Re: Green/purple video from 950Q + security cam
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Conrad <mike@nrdvana.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Sun, Jul 28, 2013 at 6:00 PM, Michael Conrad <mike@nrdvana.net> wrote:
> When I plug either of these cameras into the video plug on a plain old TV,
> they work great.  When I plug either camera into the 950Q on Windows using
> the supplied WinTV software, they work great.  When I plug the rear-view
> camera into the 950Q on Linux, it works great.  But when I plug the security
> camera into 950Q on Linux, it mostly works and then the picture starts
> randomly jumping sideways (like it is having trouble keeping a horizontal
> sync on the signal) and then will suddenly flip to a green-grayscale image
> with all bright areas as purple-grayscale.  Once turned green/purple, it
> remains like this until I reset the camera, but the video is full framerate,
> low latency, and looks flawless aside from the bizarre colors.

Yeah, there have been some issues with frame alignment on that
particular chip, which primarily manifest themselves when using highly
unstable video sources.  This might sound like a cop-out, but you
would be better suited with *any* $29 capture device from NewEgg than
with the 950q.

I've got workarounds in the driver code which cover most of the edge
cases, but they aren't foolproof.

> For the tests under Linux, I am using the v4l2 API directly in a simple demo
> C program I wrote.  It is attached.  I tried both the "read" API, and the
> mmap API.  Both produce identical results.

Won't make a difference whether using mmap or read in this case.

> My other attempts on Linux had been to use v4l2-ctl to select the composite
> channel, and then play the device with VLC or Cheese.  Neither were
> successful (no video at all) but I need to do this from C in the long run,
> anyway.

Cheese typically doesn't work with anything other than webcams since
they typically don't support all the colorspaces (and the 950q in
particular uses one that is unusual for raw video).  VLC should work
though if you get the correct magic incantation of command line
arguments (I use it regularly with the 950q).

> Anyone seen anything like this before?

Yes, I have.  :-)

It can certainly be made to work via hacking at the driver (but I
don't have a video source which readily reproduces the issue).  But
with Kworld 2800d units being available for $29 on Ebay, that is
probably by far the easier approach.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
