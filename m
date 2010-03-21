Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4803 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0CUIUB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 04:20:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
Date: Sun, 21 Mar 2010 09:19:42 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
References: <201003200958.49649.hverkuil@xs4all.nl> <4BA5559C.8000203@redhat.com>
In-Reply-To: <4BA5559C.8000203@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003210919.43101.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 21 March 2010 00:09:16 Hans de Goede wrote:
> Hi,
> 
> On 03/20/2010 09:58 AM, Hans Verkuil wrote:
> > Hi all,
> >
> > Well, I certainly fired everyone up with my RFC. Based on the replies I got I
> > do think the time is right to start the removal process.
> >
> > Phase 1 would be to convert the remaining V4L1 drivers.
> >
> > To see what needs to be done I decided to analyse the remaining V4L1 drivers:
> >
> > - usbvideo (really four drivers: vicam, ibmcam, konicawc, quickcam_messenger)
> >
> > Hans de Goede added support for the quickcam_messenger to gspca, so that driver
> > is scheduled for removal. Devin has hardware to test the vicam driver. David
> > Ellingsworth has hardware to test the ibmcam driver. It would be great if
> > Devin and David can either send it to Hans de Goede or work on it themselves.
> >
> > The konicawc is for an Intel YC76 webcam. I found one for sale here:
> >
> > http://www.ecrater.com/product.php?pid=6593985
> >
> > Unfortunately the seller does not ship to the Netherlands or to Norway. Can
> > some kind US developer buy it and donate it to Hans de Goede? It's fairly
> > expensive at $39.99, but it's for a good cause.
> >
> > So in theory all these drivers can be tested and converted.
> >
> > - bw-qcam
> >
> > A parallel port Connectix QuickCam webcam. To my knowledge no one has hardware
> > to test this. However, it should not be hard to convert this to V4L2, even
> > without having hardware since this driver doesn't do any streaming or DMA.
> >
> 
> It is parallel port only so lets just drop it.
> 
> > - c-qcam
> >
> > A parallel port color Connectix QuickCam webcam. To my knowledge no one has
> > hardware to test this. However, it should not be hard to convert this to V4L2,
> > even without having hardware since this driver doesn't do any streaming or DMA.
> >
> 
> It is parallel port only so lets just drop it.
> 
> 
> > - w9966
> >
> > A parallel port LifeView FlyCam Supra webcam. To my knowledge no one has
> > hardware to test this. However, it should not be hard to convert this to V4L2,
> > even without having hardware since this driver doesn't do any streaming or DMA.
> >
> 
> It is parallel port only so lets just drop it.

But these three are trivial to convert and the c-qcam can actually be tested.
Because of that I see no reason to drop the support for this.

> 
> > - cpia_pp
> >
> > Parallel port webcam driver for the Creative Webcam II. I found one on eBay,
> > so with luck I can get hold of the hardware and get it to HdG.
> >
> 
> Although I appreaciate your effort in getting this cam into my hands, I don't
> know what to with it once I have it, my stance on it can be summarized as:
> It is parallel port only so lets just drop it.
> 
> > - cpia_usb
> >
> > USB variant of cpia_pp. Deprecated since it is now supported by gspca.
> >
> 
> Ack, note that there is no sane way to make the gspca code also support the
> parallel port version, so if we would like to do that we would have
> to keep the pp part of the old cpia1 v4l1 driver which could do both pp and
> usb around, and convert that v4l2.

This looks like it might be a lot more work, so at some point we will have
to decide to either convert or drop it.

> 
> <snip>
> 
> > So if we all pitch in, then can get everything converted without having to
> > remove drivers.
> 
> I'm not sure if the parallel port attached are worth keeping support for. But
> if someone else is willing to convert those, sure.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
