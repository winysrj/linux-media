Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:55824 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab2IYNsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 09:48:35 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: davinci: vpif: set device capabilities
Date: Tue, 25 Sep 2012 15:48:10 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	VGER <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1348571784-4237-1-git-send-email-prabhakar.lad@ti.com> <201209251354.29824.hansverk@cisco.com> <CA+V-a8uLTmCSzY7xtp_TpAcmt=w5hMEWEpk24py1OD9qxOtYbw@mail.gmail.com>
In-Reply-To: <CA+V-a8uLTmCSzY7xtp_TpAcmt=w5hMEWEpk24py1OD9qxOtYbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251548.10830.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 25 September 2012 15:26:11 Prabhakar Lad wrote:
> Hi Hans/Laurent
> 
> On Tue, Sep 25, 2012 at 5:24 PM, Hans Verkuil <hansverk@cisco.com> wrote:
> > On Tue 25 September 2012 13:49:16 Laurent Pinchart wrote:
> >> Hi Hans,
> >>
> >> On Tuesday 25 September 2012 13:43:36 Hans Verkuil wrote:
> >> > On Tue 25 September 2012 13:16:24 Prabhakar wrote:
> >> > > From: Lad, Prabhakar <prabhakar.lad@ti.com>
> >> > >
> >> > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> >> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> >> > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >> > > ---
> >> > >
> >> > >  drivers/media/platform/davinci/vpif_capture.c |    4 +++-
> >> > >  drivers/media/platform/davinci/vpif_display.c |    4 +++-
> >> > >  2 files changed, 6 insertions(+), 2 deletions(-)
> >> > >
> >> > > diff --git a/drivers/media/platform/davinci/vpif_capture.c
> >> > > b/drivers/media/platform/davinci/vpif_capture.c index 4828888..faeca98
> >> > > 100644
> >> > > --- a/drivers/media/platform/davinci/vpif_capture.c
> >> > > +++ b/drivers/media/platform/davinci/vpif_capture.c
> >> > > @@ -1630,7 +1630,9 @@ static int vpif_querycap(struct file *file, void
> >> > > *priv,>
> >> > >  {
> >> > >
> >> > >   struct vpif_capture_config *config = vpif_dev->platform_data;
> >> > >
> >> > > - cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> >> > > + cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> >> > > +                 V4L2_CAP_READWRITE;
> >> > > + cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> >> > >
> >> > >   strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
> >> >
> >> > This should be the real driver name which is 'vpif_capture'.
> >> >
> >> > >   strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
> >> >
> >> > For bus_info I would use: "platform:vpif_capture".
> >> >
> >> > The 'platform:' prefix is going to be the standard for platform drivers.
> >>
> >> What about
> >>
> >> snprintf(cap->driver, sizeof(cap->driver), "platform:%s", dev_name(vpif_dev));
> >>
> >> That would handle cases where multiple platform devices of the same type are
> >> present.
> >
> > Sure, that's even better. You do have to check that this gives you what you'd
> > expect (i.e., that you don't end up with "platform:platform:vpif_capture").
> >
> But the driver field is max 16, should i extend it to 32 ?

I'm certain Laurent meant to say:

snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s", dev_name(vpif_dev));

It makes no sense to use cap->driver.

Regards,

	Hans

> 
> Regards,
> --Prabhakar Lad
> 
> > Regards,
> >
> >         Hans
> 
