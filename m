Return-path: <linux-media-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:12115
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753833Ab0DTJOt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 05:14:49 -0400
Subject: Re: xHCI bandwidth error with USB webcam
From: Andiry Xu <andiry.xu@amd.com>
To: Sarah Sharp <sarah.a.sharp@intel.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Yang, Libin" <Libin.Yang@amd.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20100416145123.GA4659@xanatos>
References: <20100412222932.GA18647@xanatos>
	 <1793EC4BDC456040AA0FC17136E1732B25FCAF@sshaexmb1.amd.com>
	 <20100416145123.GA4659@xanatos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Apr 2010 17:14:34 +0800
Message-ID: <1271754874.2797.14.camel@brienza-laptop>
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-04-16 at 07:51 -0700, Sarah Sharp wrote:
> > I'm also verifying usb webcam these days. The host controller also
> > rejects alternate setting, indicating not enough bandwidth. Fortunately
> > the webcam I used is using gspca and the patch for gspca below does
> > work. After several times of failure, it will set the alt setting
> > successfully. See the log and descriptors.
> 
> Good to know that works!  I'll resubmit it as a real patch then.
> 
> > But I don't think it's normal behavior. The xHC should accept the alt
> > setting request at the first time. I'm also using the NEC chips, perhaps
> > it's a HW or FW issue but I can't make sure. 
> 
> I have a patch to fix this.  I wasn't setting the Average TRB Length or
> Max ESIT fields in the isoc endpoint descriptor.  Apparently the NEC
> chip only needs the avg. TRB length to accept the alternate setting, but
> the xHCI spec says it's really the max ESIT payload that is used for
> scheduling, so I've set both.

I've tested the patches and they works. Thanks. 

> I'll send the patch in a view minutes.  Unfortunately, with my gspca
> full speed webcam, I hang my machine after installing the interface,
> when the driver first submits an isochronous URB.  It's a "scheduling
> while atomic" error with a very odd backtrace.  But it happens every
> time I plug in the webcam, so I know it's related to that.  Gzipped log
> file is attached.  Ignore the values of the tx_info field in the
> endpoint, I had a bug with the math in the patch that I've since fixed.

I've checked this issue and figured out the root cause. I used
prepare_ring() to check the room for each td in the URB, but not for the
whole URB. If a URB carrying multple packets/tds is failed to enqueue
due to not enough room on the ring, perhaps some of its tds have already
been inserted to the ring before the check failure, which is a mistake.
A URB should be inserted to the ring as a whole: either it can be
enqueued, or not. Not part of it.

I'll submit the updated patches to fix this issue. It used
prepare_ring() in the beginning to guarantee there is enough room for
the whole URB. This should fix your issue. 

> > Another problem of the isoc transfer is the size of the transfer ring.
> > Currently in xhci_endpoint_init() of xhci-mem.c, the ring allocated
> > for each endpoint just contains one segment, which can hold 64 - 1 =
> > 63 trbs. But the gspca will submit 3 urbs at one time, each consists
> > of 32 packets. Each packet needs an isoc TD to carry, and the driver
> > will insert 96 trbs to the ring at one time. It will cause the
> > room_on_ring check failure since the xHC cannot process the trbs in
> > time.  After I modify the parameter of xhci_ring_alloc() in
> > xhci_endpoint_init() to allocate 2 segments, the webcam works
> > smoothly. It looks like dynamic ring allocation is necessary for isoc
> > endpoint since it will put multiple trbs on the ring and the fixed
> > size is too small.
> 
> Yes, it looks like dynamic ring resizing is necessary, but feel free to
> submit your patch for xhci_endpoint_init() for now.

I will submit the patch to allocate bigger ring for isoc endpoints as a
temporary workaround. 

Andiry Xu

