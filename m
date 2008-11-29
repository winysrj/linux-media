Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATJ8hkT010979
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 14:08:43 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mATJ8UQI010790
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 14:08:31 -0500
Date: Sat, 29 Nov 2008 20:08:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200811291519.39549.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0811292002300.8352@axis700.grange>
References: <200811242309.37489.hverkuil@xs4all.nl>
	<200811251848.09593.hverkuil@xs4all.nl>
	<200811290034.44340.laurent.pinchart@skynet.be>
	<200811291519.39549.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 1/3)
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

On Sat, 29 Nov 2008, Hans Verkuil wrote:

> > > +Introduction
> > > +------------
> > > +
> > > +The V4L2 drivers tend to be very complex due to the complexity of
> > > the +hardware: most devices have multiple ICs, export multiple
> > > device nodes in +/dev, and create also non-V4L2 devices such as
> > > DVB, ALSA, FB, I2C and input +(IR) devices.
> > > +
> > > +Especially the fact that V4L2 drivers have to setup supporting ICs
> > > to +do audio/video muxing/encoding/decoding makes it more complex
> > > than most. +Usually these ICs are connected to the main bridge
> > > driver through one or +more I2C busses, but other busses can also
> > > be used. Such devices are +called 'sub-devices'.
> >
> > Do you know of other busses being used in (Linux supported) real
> > video hardware, or is it currently theoretical only ?
> 
> The pxa_camera driver is one example of that. Also devices driven by 
> GPIO pins can be implemented this way. I did that in ivtv for example: 
> most cards use i2c audio muxers, but some have audio muxers that are 
> commanded through GPIO so I created a v4l2_subdev that uses GPIO to 
> drive these chips. Works very well indeed.

I think pxa-camera (as well as sh-mobile-ceu and other soc-camera host 
drivers in the works) is not a very good example here. Sensors connected 
to embedded controllers like PXA indeed use a dedicated camera bus but 
only for data exchange. This bus comprises of data and synchronisation 
lines only. Sensors are still connected over an i2c bus for control and 
configuration, also been open to other busses, I haven't seen such 
examples as yet. I might have misunderstood what has been discussed here 
though.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
