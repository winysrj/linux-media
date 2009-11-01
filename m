Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:41050 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbZKAW5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Nov 2009 17:57:12 -0500
Subject: Re: cx18: YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Simon Farnsworth <simon.farnsworth@onelan.com>
In-Reply-To: <de8cad4d0911011010g1bb3d595ge87e3b168ce41c32@mail.gmail.com>
References: <1257020204.3087.18.camel@palomino.walls.org>
	 <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
	 <1257036094.3181.7.camel@palomino.walls.org>
	 <de8cad4d0910311925u28895ca9q454ccf0ac1032302@mail.gmail.com>
	 <1257079055.3061.19.camel@palomino.walls.org>
	 <de8cad4d0911011010g1bb3d595ge87e3b168ce41c32@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 01 Nov 2009 17:59:14 -0500
Message-Id: <1257116354.3076.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-01 at 13:10 -0500, Brandon Jenkins wrote:
> On Sun, Nov 1, 2009 at 7:37 AM, Andy Walls <awalls@radix.net> wrote:
> > On Sat, 2009-10-31 at 22:25 -0400, Brandon Jenkins wrote:
> >> On Sat, Oct 31, 2009 at 8:41 PM, Andy Walls <awalls@radix.net> wrote:
> >> > On Sat, 2009-10-31 at 16:28 -0400, Devin Heitmueller wrote:
> >> >> On Sat, Oct 31, 2009 at 4:16 PM, Andy Walls <awalls@radix.net> wrote:

> > Could you provide the panic to me?  Off-list is fine.
> >
> > If I can't get this large buffer scheme to work for the general case to
> > mainatin YUV frame alignment, I'll have to figure out what will likely
> > be a much more complex scheme to ensure alignment is maintained in for
> > YUV streams. :(
> >
> > Oh, well.
> >
> > Regards,
> > Andy
> >
> >
> >
> Hi Andy,
> 
> The panic happens upon reboot and it is only 1 line of text oddly shifted.
> 
> Kernel panic - not syncing: DMA: Memory would be corrupted
> 
> If I switch back to the current v4l-dvb drivers no issue. To switch
> back I have to boot from a USB drive.

Brandon,

Eww.  OK.  Nevermind performing any more data collection.  I'm going to
use a new strategy (when I find the time).

(Thinking out loud ...)
Working under the assumptions that:

1. The encoder always returns 720 pixels worth of data per line (no
matter what the scaling)

2. The software HM12 decoders can only deal with full, not partial,
16x8x2 UV macroblocks at 4:2:0, so scaled YUV height needs to be in
multiples of 32 lines

3. The CX23418 actually can handle Memory Descriptor Lists (MDLs) with
more than one buffer per list

I'm going to use the MDLs to actually hold buffer lists with multiple
buffers, where individual buffers are 720 * 32 * 3 / 2 = 33.75 kB each.
That way I can build up buffer lists to hold precisely one frame of YUV
data at a time, no matter what the scaling, and then know that if the
cx18 driver misses an incoming MDL notification, the YUV frames will
stay aligned.  The 33.75 kB buffers should be no problem from a DMA
perspective, compared to 607.5 kB buffers.

The pain is that the cx18 driver right now has the hard-coded assumption
that there is only one buffer per MDL.  It will take a bit of effort to
fix that assumption in the driver and generalize it to having 1 or more
buffers per MDL.


Anyway, thanks for the testing.

Regards,
Andy


