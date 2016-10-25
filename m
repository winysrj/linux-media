Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:14129
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932674AbcJYFv4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 01:51:56 -0400
Date: Tue, 25 Oct 2016 07:51:51 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
cc: Andrey Utkin <andrey_utkin@fastmail.com>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?ISO-8859-15?Q?Rafael_Louren=E7o_de_Lima_Chehab?=
        <chehabrafael@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] au0828-video: Use kcalloc() in
 au0828_init_isoc()
In-Reply-To: <20161024221115.3632aa5c@vento.lan>
Message-ID: <alpine.DEB.2.20.1610250750450.2084@hadrien>
References: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>        <68ad1aaa-c029-04b9-805a-e859f6c2d2d5@users.sourceforge.net>        <20161024222844.GD25320@dell-m4800.home> <20161024221115.3632aa5c@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 24 Oct 2016, Mauro Carvalho Chehab wrote:

> Em Mon, 24 Oct 2016 23:28:44 +0100
> Andrey Utkin <andrey_utkin@fastmail.com> escreveu:
>
> > On Mon, Oct 24, 2016 at 10:59:24PM +0200, SF Markus Elfring wrote:
> > > From: Markus Elfring <elfring@users.sourceforge.net>
> > > Date: Mon, 24 Oct 2016 22:08:47 +0200
> > >
> > > * Multiplications for the size determination of memory allocations
> > >   indicated that array data structures should be processed.
> > >   Thus use the corresponding function "kcalloc".
> > >
> > >   This issue was detected by using the Coccinelle software.
> > >
> > > * Replace the specification of data types by pointer dereferences
> > >   to make the corresponding size determination a bit safer according to
> > >   the Linux coding style convention.
> > >
> > > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > > ---
> > >  drivers/media/usb/au0828/au0828-video.c | 11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> > > index 85dd9a8..85b13c1 100644
> > > --- a/drivers/media/usb/au0828/au0828-video.c
> > > +++ b/drivers/media/usb/au0828/au0828-video.c
> > > @@ -221,15 +221,18 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
> > >
> > >  	dev->isoc_ctl.isoc_copy = isoc_copy;
> > >  	dev->isoc_ctl.num_bufs = num_bufs;
> > > -
> >
> > > -	dev->isoc_ctl.urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
> > > +	dev->isoc_ctl.urb = kcalloc(num_bufs,
> > > +				    sizeof(*dev->isoc_ctl.urb),
> > > +				    GFP_KERNEL);
> >
> > What about this (for both hunks)?
> >
> > -	dev->isoc_ctl.urb = kzalloc(sizeof(void *)*num_bufs,  GFP_KERNEL);
> > +	dev->isoc_ctl.urb =
> > +		kcalloc(num_bufs, sizeof(*dev->isoc_ctl.urb), GFP_KERNEL);
>
>
> That's worse :)
>
> The usual Kernel style is:
>
> 		var = foo(bar1,
> 		          bar2,
> 		          bar3);

Isn't it more like

var = foo(bar1, bar2,
          bar3)

Otherwise, Markus is going to send millions of patches to put every
function argument on its own line...

julia

>
> instead of something like:
>
> 		var =
> 		    foo(bar1,
> 			bar2,
> 			bar3);
>
> The places where it is different than that is because people ran
> ./scripts/Lindent to try to follow the Kernel coding style.
>
> On my experiences, at the end, using it caused more harm than
> good, IMHO, and cause very weird indentation on lines with
> more than 80 columns like the above.
>
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
