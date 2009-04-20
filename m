Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37129 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZDTSFE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 14:05:04 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH] uvc: Add Microsoft VX 500 webcam
Date: Mon, 20 Apr 2009 20:07:31 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <68cac7520904150003n150bff9bp616cc49e684d947d@mail.gmail.com> <200904151146.52459.laurent.pinchart@skynet.be> <20090415104808.13062f47@gmail.com>
In-Reply-To: <20090415104808.13062f47@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202007.31599.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Douglas,

On Wednesday 15 April 2009 15:48:08 Douglas Schilling Landgraf wrote:
> Hello Laurent,
>
> On Wed, 15 Apr 2009 11:46:52 +0200
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > Hi Douglas,
> >
> > On Wednesday 15 April 2009 09:03:45 Douglas Schilling Landgraf wrote:
> > > Hello Laurent,
> > >
> > >     Attached patch for the following:
> > >
> > >     Added Microsoft VX 500 webcam to uvc driver.
> > >
> > > Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
> >
> > Could you please send me the output of
> >
> > lsusb -v -d 045e:074a
> >
> > using usbutils 0.72 or newer (0.73+ preferred) ?
>
> usbutils-0.73-2
>
> > Have you tried the latest driver ?
>
> Yes
>
> > The MINMAX quirk isn't required
> > anymore for most cameras (although the two supported Microsoft
> > webcams still need it, so I doubt it will work as-is).
>
> Indeed, attached new patch.

The new patch shouldn't be needed at all, as it doesn't declare any quirk. The 
camera should work out of the box using the latest driver.

Best regards,

Laurent Pinchart

