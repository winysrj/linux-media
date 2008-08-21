Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7L8oN60029702
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 04:50:23 -0400
Received: from mail1.sea5.speakeasy.net (mail1.sea5.speakeasy.net
	[69.17.117.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7L8oBvL027070
	for <video4linux-list@redhat.com>; Thu, 21 Aug 2008 04:50:11 -0400
Date: Thu, 21 Aug 2008 01:50:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <jdelvare@suse.de>
In-Reply-To: <200808202334.20872.jdelvare@suse.de>
Message-ID: <Pine.LNX.4.58.0808210107110.23833@shell4.speakeasy.net>
References: <200808181918.05975.jdelvare@suse.de>
	<Pine.LNX.4.58.0808181054150.23833@shell4.speakeasy.net>
	<200808202334.20872.jdelvare@suse.de>
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

On Wed, 20 Aug 2008, Jean Delvare wrote:

> Hi Trent,
>
> Le lundi 18 août 2008, Trent Piepho a écrit :
> > What's more, yuv420 works by sending one line at 2 bytes/pixel and the next
> > line at 1 byte/pixel.  If the bt878 had a large fifo, the bit rate might
> > average out, but it doesn't.  It's something microscopic like 128 bytes.
>
> You're right, it's (in practice) 128 bytes.
>
> While reading the BT878 datasheet to try to better understand how
> this all happens, I came to wonder how the chip can actually handle
> planar formats with vertical subsampling.
>
> To do vertical subsampling, you obviously need to handle several
> lines together (2 in the case of yuv420). However, the FIFO is too

2 is needed for simple averaging.  Higher quality requires even more lines
for a multi-tap FIR filter for some kind.

> small to contain a complete line of data, and there doesn't seem to
> be any RISC instruction for fetching chroma information back from
> memory either. This suggests that the BT878 is cheating on vertical
> subsampling, and instead of averaging on 2 lines (2x2 chroma
> subsampling), it averages on 1 line (2x1 chroma subsampling) and just
> skips the chroma information of the next line. Can you please confirm
> or infirm this? If I'm wrong then I would be grateful if you could
> explain how the BT878 achieves vertical subsampling.

4:2:0 YUV is achieved by setting the chip to 4:2:2 mode and then dropping
"every other" chroma line with RISC DMA program.

Note that every other line means something totally different if you are
talking about fields vs frames.  Historically bttv got this wrong for field
capture, and didn't take field dominance into account for frame capture.  I
don't know if it's been fixed or not.

I suppose one could drop the just the U samples for one line, then drop
just the V for the next line, to get a better average bit rate.

A better question would be how does the bt878 do horizontal and vertical
scaling?  If you look at the description of ultralock and the number of
taps avaiable for the vertical scaling filters, the chip must have some
kind of multi-line buffer before the scaler.  But this buffer, and the
delay it must introduce, is never mentioned in the datasheet.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
