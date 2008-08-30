Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UFD6kC027074
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 11:13:07 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7UFCswN025465
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 11:12:55 -0400
Date: Sat, 30 Aug 2008 17:12:33 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Jean Delvare <jdelvare@suse.de>
Message-ID: <20080830151233.GA221@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<200808281611.38241.jdelvare@suse.de>
	<20080828202043.GB824@daniel.bse>
	<200808301201.47561.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808301201.47561.jdelvare@suse.de>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: Re: bttv driver questions
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

On Sat, Aug 30, 2008 at 12:01:47PM +0200, Jean Delvare wrote:
> My assumption that there was a
> VBI interrupt was wrong, probably because my video source is a VCR
> and it doesn't send any information during VBI?

When there is an application requesting VBI capture, there will be a
VBI interrupt, regardless of the content in those lines.

> > There is only one program with jumps that are patched at runtime to
> > point to the program fragments for capture.
> 
> And this all happens magically inside the BT878 without the bttv
> driver having to care? Wow! Tricky.

No, this is how bttv does it.
Other implementations may use a single loop without jumps.

> In my case there's a PCI Express-to-PCI bridge on the path, so I
> presume that this acts as the target. I suppose that the board was
> designed that way precisely to make sure that no extra latency would
> happen on the PCI bus due to the host being slow/busy. If the bridge
> has large enough buffers, it should be easy for it to send the data
> down to the host bridge, given that PCI Express x1 is much faster
> than PCI.

It's not that much faster. Of the 250MB/s a lot is lost to overhead,
especially when there are mostly short packets. And there may be other
bottlenecks before the data reaches the RAM.

> > I think for competing Bt878s the smallest trigger point in combination
> > with a high latency counter should perform best.
> 
> I don't quite follow you here. Care to explain how you reached this
> conclusion?

A smaller trigger point will make the PCI bus less idle but the average
FIFO fill will be lower.

Yesterday I wrote a small program that simulates a number of PCI masters
with constant data rate filling their FIFOs. There is a simple round
robin arbiter and neither the target nor the master needs wait cycles.

For 5 masters with 24.2MB/s each (peak data rate of YUY2 640x480 NTSC),
a latency counter of 254, and a FIFO trigger of 4, the bus is never idle.
The maximum FIFO fill is 16 DWords. With a latency counter below 20,
the FIFO fill rises infinitely.

With a FIFO trigger of 32 and a latency counter of 254, the maximum fill
is 33 DWords and the bus is 4.5% idle.

Those 17 less FIFO entries in the 4-entry-trigger case can buffer for 93
PCI cycles. The 4.5% idle cycles in the 32-entry-trigger case are wasted
if there is no other master on the bus, as is the case when the Bt878s are
behind a bridge.

In reality there are always idle phases during syncs and additional
traffic will be generated to fetch RISC instructions and to access
registers.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
