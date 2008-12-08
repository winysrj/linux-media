Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8M0VeE016602
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 17:00:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mB8Lwudp014257
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 16:58:57 -0500
Date: Mon, 8 Dec 2008 19:58:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20081208195848.2b7d9c0c@pedra.chehab.org>
In-Reply-To: <20081208194235.4991873d@pedra.chehab.org>
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
	<20081208194235.4991873d@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: [PATCH] Add OMAP2 camera driver
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

On Mon, 8 Dec 2008 19:42:35 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> On Thu, 27 Nov 2008 00:14:51 +0530
> "Trilok Soni" <soni.trilok@gmail.com> wrote:
> 
> > +
> > +/*
> > + *
> > + * DMA hardware.
> > + *
> > + */
> > +
> > +/* Ack all interrupt on CSR and IRQSTATUS_L0 */
> > +static void omap24xxcam_dmahw_ack_all(unsigned long base)
> 
> Oh, no! yet another dma video buffers handling...
> 
> Soni, couldn't this be converted to use videobuf?
> 

Just explaining myself: I can see two different parts on your omap driver:

1) omap specific functions (like omap register setups);

2) a scatter/gather DMA driver that seems to be tailored specifically to omap2.

I'm not sure why you didn't just use videobuf-dma-sg for (2). You should
have your reasons. 

However, instead of adding a new DMA S/G handler inside the
driver, the better would be either to:

a) patch the existing one to attend your needs; 
b) if what you need is so different than the existing driver, you may write
another videobuf-dma-sg-foo driver, clearly documenting why you couldn't use
the existing driver, and making it generic enough to be used by other drivers.

Splitting this into two files/drivers make easier for it to be analyzed and
understood.

Btw, I'm now reviewing all the patches from the pending pull request. I may
have other comments later, since this is a big series of patches, and will
require me some time to deeply inspect each one.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
