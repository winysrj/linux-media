Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:34723 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZDXBFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 21:05:33 -0400
Received: by qyk16 with SMTP id 16so1737389qyk.33
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2009 18:05:32 -0700 (PDT)
Date: Thu, 23 Apr 2009 22:05:25 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] uvc: Add Microsoft VX 500 webcam
Message-ID: <20090423220525.307f1f6a@gmail.com>
In-Reply-To: <200904202007.31599.laurent.pinchart@skynet.be>
References: <68cac7520904150003n150bff9bp616cc49e684d947d@mail.gmail.com>
	<200904151146.52459.laurent.pinchart@skynet.be>
	<20090415104808.13062f47@gmail.com>
	<200904202007.31599.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On Mon, 20 Apr 2009 20:07:31 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Douglas,
> 
> On Wednesday 15 April 2009 15:48:08 Douglas Schilling Landgraf wrote:
> > Hello Laurent,
> >
> > On Wed, 15 Apr 2009 11:46:52 +0200
> >
> > Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > Hi Douglas,
> > >
> > > On Wednesday 15 April 2009 09:03:45 Douglas Schilling Landgraf
> > > wrote:
> > > > Hello Laurent,
> > > >
> > > >     Attached patch for the following:
> > > >
> > > >     Added Microsoft VX 500 webcam to uvc driver.
> > > >
> > > > Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
> > >
> > > Could you please send me the output of
> > >
> > > lsusb -v -d 045e:074a
> > >
> > > using usbutils 0.72 or newer (0.73+ preferred) ?
> >
> > usbutils-0.73-2
> >
> > > Have you tried the latest driver ?
> >
> > Yes
> >
> > > The MINMAX quirk isn't required
> > > anymore for most cameras (although the two supported Microsoft
> > > webcams still need it, so I doubt it will work as-is).
> >
> > Indeed, attached new patch.
> 
> The new patch shouldn't be needed at all, as it doesn't declare any
> quirk. The camera should work out of the box using the latest driver.

It doesn't work to me. :-(
 
> Best regards,
> 
> Laurent Pinchart
> 
