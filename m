Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81Mu3Xu007002
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 18:56:04 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m81MtD2H026389
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 18:55:14 -0400
Date: Tue, 2 Sep 2008 00:54:50 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Jean Delvare <jdelvare@suse.de>
Message-ID: <20080901225450.GA1424@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<200809011144.54233.jdelvare@suse.de>
	<20080901123544.GA447@daniel.bse>
	<200809012126.06532.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809012126.06532.jdelvare@suse.de>
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

On Mon, Sep 01, 2008 at 09:26:06PM +0200, Jean Delvare wrote:
> This is because each master never needs its full grant, the FIFO is
> empty before and they return the bus control early. If each master
> was to keep control of the bus for as long as control was originally
> granted, things would be much different. Would it be difficult to
> modify your simulation tool to allow this case?

It is impossible to extend a transaction by an arbitrary number of
cycles without violating the spec. Every DWord must be ready in 8
cycles. When the data rate is below 16.7 MB/s, the next DWord will
not be ready in time.

> I would also like to be able to add an arbitrary number of setup
> cycles at the beginning of every transaction. Your assumption that
> there are no such cycles wasted is a bit optimistic, and I'd like
> to get more realistic figures.

It's not like the bridge has to fetch a cachline from memory.
It just needs to decode the address. Either there are buffers waiting
or it can't accept data (in which case it will probably signal RETRY).
Address decoding is specified as medium DEVSEL timing, which equals
1 wait cycle worst case.

> Which raises a question... do you know if the XIO2000 can merge
> writes?

I don't know. TI support might be able to answer this.

> And do you know how much of a buffer it has?

The XIO2000A FAQ says a PCIe transaction payload can be 512 bytes
maximum. It furthermore says that Intel chipsets accept only transactions
up to 128 bytes. The number of buffers would be interesting, too.
And if the second VC has the same number of buffers...

> The problem I have with low trigger is that it means many short
> transactions, which in turn means small effective bandwidth, and I
> know that in my case we can't have too much bandwidth.

When the bus is loaded, transaction lengths will grow automatically
above the trigger point up to the latency counter value.
The simulation for 5 masters required a minimum latency of 20 even
though the trigger was 4.

> I think your code assumes YUY2 as a capture format, i.e. 2 bytes
> per pixel? I already know that 8 masters can't do that concurrently
> over the same PCI bus, no matter how we tweak the PCI settings. I'll
> have to change the code to assume Y8 as a capture format.

8 masters doing Y8 is less traffic with more FIFOs than 5 masters doing
YUY2. It probably works out of the box.

If grayscale is not what your customer wants, there is a 8 bit color
mode V4L2_PIX_FMT_HI240.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
