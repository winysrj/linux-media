Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7LMq0bK025341
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 18:52:00 -0400
Received: from mail5.sea5.speakeasy.net (mail5.sea5.speakeasy.net
	[69.17.117.7])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7LMp5lJ004038
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 18:51:05 -0400
Date: Thu, 21 Aug 2008 15:50:59 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <jdelvare@suse.de>
In-Reply-To: <200808211114.27290.jdelvare@suse.de>
Message-ID: <Pine.LNX.4.58.0808211445230.23833@shell4.speakeasy.net>
References: <200808181918.05975.jdelvare@suse.de>
	<200808202334.20872.jdelvare@suse.de>
	<Pine.LNX.4.58.0808210107110.23833@shell4.speakeasy.net>
	<200808211114.27290.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv driver errors
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 21 Aug 2008, Jean Delvare wrote:
> Le jeudi 21 août 2008, Trent Piepho a écrit :
> > On Wed, 20 Aug 2008, Jean Delvare wrote:
> > > While reading the BT878 datasheet to try to better understand how
> > > this all happens, I came to wonder how the chip can actually handle
> > > planar formats with vertical subsampling.
> > >
> > > To do vertical subsampling, you obviously need to handle several
> > > lines together (2 in the case of yuv420). However, the FIFO is too
> >
> > 2 is needed for simple averaging.  Higher quality requires even more lines
> > for a multi-tap FIR filter for some kind.
> >
> > > small to contain a complete line of data, and there doesn't seem to
> > > be any RISC instruction for fetching chroma information back from
> > > memory either. This suggests that the BT878 is cheating on vertical
> > > subsampling, and instead of averaging on 2 lines (2x2 chroma
> > > subsampling), it averages on 1 line (2x1 chroma subsampling) and just
> > > skips the chroma information of the next line. Can you please confirm
> > > or infirm this? If I'm wrong then I would be grateful if you could
> > > explain how the BT878 achieves vertical subsampling.
> >
> > 4:2:0 YUV is achieved by setting the chip to 4:2:2 mode and then dropping
> > "every other" chroma line with RISC DMA program.
>
> OK. So you agree with me that this is approximative and not "real"
> vertical subsampling. I'm curious if more recent video chips are

Depends on what you mean by "real".  Think of the top line of the chroma as
x(0), the line below it as x(1), the next line x(2) and so on.  The line
above would be x(-1), then x(-2), etc.

It sounds like you think the formula for the subsampled chroma should be:
0.5 * x(0) + 0.5 * x(1)

And this is a pretty common way to do it.  The formula the bt878 uses is:
1.0 * x(0)

That's also a perfectly valid and real formula to use, though not a
particularly good one.  You could also use something like:
0.125 * x(-1) + 0.375 * x(0) + 0.375 * x(1) + 0.125 * x(2)

> > I suppose one could drop the just the U samples for one line, then drop
> > just the V for the next line, to get a better average bit rate.
>
> This would make some sense indeed, but I suspect that the BT878
> doesn't actually do this. Looking at the available RISC instructions,
> I see an instruction copying Y data from FIFO to RAM and skipping U
> and V data, and another instruction copying all of Y, U and V data
> from FIFO to RAM. But no instruction copying Y and U or Y and V. So

You're right, I forgot about that.  There is only WRITE123 and WRITE1S23,
no WRITE12S3.

You might try switching to packed mode instead of planar.  In that mode the
three FIFOs are merged.  Another thing I've heard about is using shorter
write commands.  When the bt878 processes a WRITE123, it doesn't write one
pixel of Y, one pixel of U, one pixel of V, then the next Y, the next V,
etc.  What it does is write all the Y, then all the U, then all the V.  So
while all the Y data is getting written, the U and V FIFOs are still
getting filled.  What that means is the latency for the V FIFO is the time
it took the bt878 to be granted bus access, plus the time it takes to empty
the Y FIFO (or finish the current RISC instruction), plus the time it takes
to empty the U FIFO.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
