Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LDfEGv024873
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 09:41:14 -0400
Received: from mail2.mxsweep.com (mail151.emailantidote.com [80.169.59.151])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LDf0cX000636
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 09:41:01 -0400
Message-Id: <200810211341.m9LDf0cX000636@mx3.redhat.com>
Date: Tue, 21 Oct 2008 11:20:35 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <489AD045.7030404@hhs.nl>	<200808071237.47230.laurent.pinchart@skynet.be>	<1218186636.1734.13.camel@localhost>	<200808081129.02118.hverkuil@xs4all.nl>
	<48A81B11.3080308@hhs.nl>
In-Reply-To: <48A81B11.3080308@hhs.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
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

Hans de Goede wrote:
> 
> I agree that this is a per device thing, and that the flag thus should
> be moved to v4l2_capability. I'll redo a new patch against the gspca
> zc3xx driver with the flag moved to v4l2_capability.
> 
> 
> About adding fake controls for HFLIP VFLIP to libv4l for devices which
> don't do this natively. This might be good to have, but my current patch
> for the upside down issue only supports. 180 degree rotation so, both
> vflip and hflip in one go.

you're referring flipping in hardware above right?

> Adding support for doing just vflip or just hflip is possible, but will
> take some time.

Any update on this.

Personally I'm using a 0402:5606 webcam with the latest uvcvideo.ko
There is a firmware update available for the webcam to flip the image,
so I'm presuming that is just changing the appropriate setting
to tell the hardware to flip the image.

There is no mention of *FLIP* capability in the uvcvideo driver at all.
Is there a standard way to get/set that in the camera?

> Also faking v4l2 controls currently is not done yet in libv4l, so doing
> this requires adding some infrastructure. All doable, but not at the top
> of my todo list at the moment.

So there is no software support yet.

cheers,
Pádraig.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
