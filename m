Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64964 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbZKAMeu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Nov 2009 07:34:50 -0500
Subject: Re: cx18: YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Simon Farnsworth <simon.farnsworth@onelan.com>
In-Reply-To: <de8cad4d0910311925u28895ca9q454ccf0ac1032302@mail.gmail.com>
References: <1257020204.3087.18.camel@palomino.walls.org>
	 <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
	 <1257036094.3181.7.camel@palomino.walls.org>
	 <de8cad4d0910311925u28895ca9q454ccf0ac1032302@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 01 Nov 2009 07:37:35 -0500
Message-Id: <1257079055.3061.19.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-10-31 at 22:25 -0400, Brandon Jenkins wrote:
> On Sat, Oct 31, 2009 at 8:41 PM, Andy Walls <awalls@radix.net> wrote:
> > On Sat, 2009-10-31 at 16:28 -0400, Devin Heitmueller wrote:
> >> On Sat, Oct 31, 2009 at 4:16 PM, Andy Walls <awalls@radix.net> wrote:
> >
> >>
> >> Hi Andy,
> >>
> >> How does this code work if the cx23418 scaler is used (resulting in
> >> the size of the frames to be non-constant)?  Or is the scaler not
> >> currently supported in the driver?
> >
> > I also forgot to mention, changing size while the encoder has an analog
> > stream running (MPEG, VBI, YUV, IDX) is not permitted by the firmware.
> > So this change works just fine as it computes the buffer size to use
> > just as it sets up to start the capture.
> >
> > Regards,
> > Andy

> Hi Andy,

Hi Brandon,

> I tried to pull your changes and received an error on a missing .hg.

Sorry, I can't help there.  The following should work:

hg clone http://linuxtv.org/hg/~awalls/cx18-yuv


> Subsequently, I downloaded the bz2 file and upon reboot I received a
> kernel panic due to DMA issues.

Did it fail on MPEG or Digital TS captures or on a YUV capture?

Did you try setting enc_yuv_bufs=0, to inhibit YUV buffer allocation, to
see if the panic went away?

Could you provide the panic to me?  Off-list is fine.

If I can't get this large buffer scheme to work for the general case to
mainatin YUV frame alignment, I'll have to figure out what will likely
be a much more complex scheme to ensure alignment is maintained in for
YUV streams. :(

Oh, well.

Regards,
Andy


