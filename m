Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG9MGuR015331
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:22:17 -0500
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBG9M0xm028394
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:22:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antonio Ospite <ospite@studenti.unina.it>
Date: Tue, 16 Dec 2008 10:21:58 +0100
References: <200812151145.54346.hverkuil@xs4all.nl>
	<20081215155715.7e8f34e9.ospite@studenti.unina.it>
In-Reply-To: <20081215155715.7e8f34e9.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161021.58430.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Integrating v4l2_device/v4l2_subdev into the soc_camera
	framework
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

On Monday 15 December 2008 15:57:14 Antonio Ospite wrote:
> On Mon, 15 Dec 2008 11:45:54 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Guennadi,
> >
> > Now that the v4l2_device and v4l2_subdev structs are merged into
> > the master v4l-dvb repository it is time to look at what needs to
> > be done to integrate it into the soc-camera framework.
> >
> > The goal is to make the i2c sub-device drivers independent from how
> > they are used. That is, whether a sensor is used in an embedded
> > device or in a USB webcam or something else should not matter for
> > the sensor driver.
>
> Is something like this planned for gspca as well?

My understanding is that most if not all of the 'subdevices' used in 
gspca are reversed engineered and as such can by definition only work 
within gspca.

So in this case I see no need to move to the new structs. That said, 
there is nothing that prevents gspca to start using these structs as 
well, in particular since they will be extended over time to take care 
of e.g. control processing, etc.

Note that it is easy (although not yet implemented since nobody needs it 
right now) to add driver-specific ops to v4l2_subdev. This could be 
ideal for gspca. So it is still possible to use the gspca-specific ops 
while also being able at the same time to use the standard ops and 
other features that the framework will offer in the future.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
