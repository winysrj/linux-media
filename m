Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3942 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZAYJaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 04:30:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Shah, Hardik" <hardik.shah@ti.com>
Subject: Re: [RFC] Adding new ioctl for transparency color keying
Date: Sun, 25 Jan 2009 10:29:49 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EB82@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EB82@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901251029.50095.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 24 January 2009 17:59:27 Shah, Hardik wrote:
> > -----Original Message-----
> > From: Shah, Hardik
> > Sent: Thursday, January 22, 2009 10:27 AM
> > To: 'linux-media@vger.kernel.org'; video4linux-list@redhat.com
> > Subject: [RFC] Adding new ioctl for transparency color keying
> >
> > Hi,
> > OMAP class of device supports transparency color keying.  Color keying
> > can be source color keying or destination color keying.
> >
> > OMAP3 has three pipelines one graphics plane and two video planes.  Any
> > of these pipelines can go to either the TV or LCD.
> >
> > The destination transparency color key value defines the encoded pixels
> > in the graphics layer to become transparent and display the underlying
> > video pixels. While the source transparency key value defines the
> > encoded pixels in the video layer to become transparent and display the
> > underlying graphics pixels. This color keying works only if the video
> > and graphics planes are on the same output like TV or LCD and images of
> > both the pipelines overlapped.
> >
> > I propose to have the one ioctl to set the encoded pixel value and type
> > of color keying source and destination.  Also we should have the CID to
> > enable/disable the color keying functionality.
> >
> > Please let us know your opinions/comments.
>
> [Shah, Hardik] Hi Any comments on above IOCTLs,
> Hans/Mauro,
> Shall I send patch to add these new ioctls.

Hi Hardik,

Sorry, I haven't yet had the opportunity to review the new ioctls. You can 
expect that next week.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
