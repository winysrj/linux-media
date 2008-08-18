Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IIiGVP031301
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 14:44:16 -0400
Received: from mail5.sea5.speakeasy.net (mail5.sea5.speakeasy.net
	[69.17.117.7])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7IIhWlN013768
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 14:43:32 -0400
Date: Mon, 18 Aug 2008 11:43:26 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <jdelvare@suse.de>
In-Reply-To: <200808181918.05975.jdelvare@suse.de>
Message-ID: <Pine.LNX.4.58.0808181054150.23833@shell4.speakeasy.net>
References: <200808181918.05975.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] bttv driver errors
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

On Mon, 18 Aug 2008, Jean Delvare wrote:
>
> My initial guess was that the PCI bandwidth was insufficient, however
> a quick computation shows that the problems start far below the limit:
> (5cams*4cif*yuv420)=(5*640*480*30*1.5)=66 MB/s, only half of the PCI
> bandwidth. The vendor claims that the adapter should be able to capture

Analog video doesn't transmit at a constant rate.  There are empty spaces
between lines and a large delay between frames.

What's more, yuv420 works by sending one line at 2 bytes/pixel and the next
line at 1 byte/pixel.  If the bt878 had a large fifo, the bit rate might
average out, but it doesn't.  It's something microscopic like 128 bytes.

An NTSC line has active data for about 52.6 us out of 63.5 us.  For square
pixel (640x480) it should be 52.15 and R.601 should be 53.33, but I won't
count on the bttv driver getting that right.

640 pixels/line * 2 bytes/pixel / 52.15 us/line = 24.5 bytes/us (MB/s)

With 5 cams you're over 122 MB/s.  Obviously the peak datarate is too high.

Even if it wasn't, you'd still want to do a latency calculation based on
the bt848 fifo size and trigger point.  The FIFO can overflow even well
below max PCI bandwidth.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
