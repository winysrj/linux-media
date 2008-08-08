Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m789TGlE010568
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 05:29:16 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m789T4W8021323
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 05:29:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 8 Aug 2008 11:29:02 +0200
References: <489AD045.7030404@hhs.nl>
	<200808071237.47230.laurent.pinchart@skynet.be>
	<1218186636.1734.13.camel@localhost>
In-Reply-To: <1218186636.1734.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081129.02118.hverkuil@xs4all.nl>
Cc: 
Subject: Re: RFC: adding a flag to indicate a webcam sensor is installed
	upside down
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

On Friday 08 August 2008 11:10:36 Jean-Francois Moine wrote:
> On Thu, 2008-08-07 at 12:37 +0200, Laurent Pinchart wrote:
> > On Thursday 07 August 2008, Hans de Goede wrote:
> > > Hi all,
> > >
> > > I have this Philips SPC 200NC webcam, which has its sensor
> > > installed upside down and the sensor does not seem to support
> > > flipping the image. So I believe the windows drivers fix this
> > > little problem in software.
> > >
> > > I would like to add a flag somewhere to indicate this to
> > > userspace (and then add flipping code to libv4l).
> > >
> > > I think the best place for this would the flags field of the
> > > v4l2_fmtdesc struct. Any other ideas / objections to this?
> >
> > More often than sensors being mounted upside down in a webcam, what
> > I've noticed frequently is webcam modules being mounted upside down
> > in a laptop screen. There is no way that I'm aware of to check the
> > module orientation based on the USB descriptors only. We will need
> > a pure userspace solution.
>
> Agree.
>
> Having a horizontal or vertical inversion may exist in any webcam
> (and tuner?), and may be the fact of wire inversion when assembling
> the device. So, having a flag in the driver could not work with
> hardware error.
>
> If the sensor (or bridge?) may do H or V flip, we are done. If not,
> this may be done by software, but in the userspace, i.e. at decoding
> time.
>
> What I propose is to add a check of the control commands
> V4L2_CID_HFLIP and V4L2_CID_VFLIP in the v4l library: if the driver
> does not have these controls, the library silenctly adds them and
> handles their requests. Then, at frame decoding time, the hflip and
> vflip may be given to the decoding functions.
>
> How do you feel it, Hans?

I'm a different Hans :-), but I was thinking along the same lines. 
Having the v4l lib implement HFLIP/VFLIP if the driver doesn't seems 
like a good idea.

I also think that the UPSIDEDOWN flag doesn't belong to v4l2_fmtdesc 
since this is a global property, not specific to a format. I would 
suggest adding it to v4l2_capability instead: 
V4L2_CAP_SENSOR_UPSIDE_DOWN. It should only be set if you know that the 
sensor is always upside down for that specific device and if there is 
no VFLIP capability (because if there is, then you can VFLIP by default 
for that device).

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
