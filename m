Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85JGXId006344
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 15:16:34 -0400
Received: from mail4.sea5.speakeasy.net (mail4.sea5.speakeasy.net
	[69.17.117.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m85JGIKB003945
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 15:16:19 -0400
Date: Fri, 5 Sep 2008 12:16:00 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <jdelvare@suse.de>
In-Reply-To: <200809021109.31007.jdelvare@suse.de>
Message-ID: <Pine.LNX.4.58.0809051205480.2423@shell2.speakeasy.net>
References: <200808251445.22005.jdelvare@suse.de>
	<200809012126.06532.jdelvare@suse.de>
	<20080901225450.GA1424@daniel.bse>
	<200809021109.31007.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] bttv driver questions
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

On Tue, 2 Sep 2008, Jean Delvare wrote:
> Le mardi 02 septembre 2008, Daniel Glöckner a écrit :
> > If grayscale is not what your customer wants, there is a 8 bit color
> > mode V4L2_PIX_FMT_HI240.
>
> I've seen this, and BT878 supports that format. But I don't know how
> to check how it looks like visually... mplayer doesn't seem to

It looks "ok".  I used to use it when I watched tv with overlay and a video
card in 8-bit pseudocolor.  It will probably compress very poorly.  You can
turn dithering on and off, on looks better, but jpeg compress will probably
be much worse with dithering.

> support that pixel format. Apparently ffmpeg forces the format to
> YUV 4:2:0 planar (a pretty bad choice if you ask me), so I can't use

Most codecs operate on planar 4:2:0, so it makes the most sense to request
the right format from the hardware, instead of converting from packed to
planar in software.  ffmpeg doesn't know that DMA of planar formats is
harder for the bt8x8 and that you are running out of PCI bandwidth but
might have lots of memory bandwidth and CPU cycles to use.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
