Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LJc2Lt029029
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 15:38:02 -0400
Received: from mailrelay007.isp.belgacom.be (mailrelay007.isp.belgacom.be
	[195.238.6.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LJbqdF025200
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 15:37:52 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 21 Oct 2008 21:38:03 +0200
References: <489AD045.7030404@hhs.nl> <48A81B11.3080308@hhs.nl>
	<200810211341.m9LDf0cX000636@mx3.redhat.com>
In-Reply-To: <200810211341.m9LDf0cX000636@mx3.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810212138.03496.laurent.pinchart@skynet.be>
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

Hi,

On Tuesday 21 October 2008, Pádraig Brady wrote:
> Hans de Goede wrote:
> > I agree that this is a per device thing, and that the flag thus should
> > be moved to v4l2_capability. I'll redo a new patch against the gspca
> > zc3xx driver with the flag moved to v4l2_capability.
> >
> >
> > About adding fake controls for HFLIP VFLIP to libv4l for devices which
> > don't do this natively. This might be good to have, but my current patch
> > for the upside down issue only supports. 180 degree rotation so, both
> > vflip and hflip in one go.
>
> you're referring flipping in hardware above right?
>
> > Adding support for doing just vflip or just hflip is possible, but will
> > take some time.
>
> Any update on this.
>
> Personally I'm using a 0402:5606 webcam with the latest uvcvideo.ko
> There is a firmware update available for the webcam to flip the image,
> so I'm presuming that is just changing the appropriate setting
> to tell the hardware to flip the image.

Most image sensors support vertical and horizontal flipping (or at least image 
rotation). So it's really a matter of setting the image sensor parameters 
correctly.

> There is no mention of *FLIP* capability in the uvcvideo driver at all.
> Is there a standard way to get/set that in the camera?

Unfortunately the upside-down cameras don't export any hflip/vflip control, so 
there's no (known) way to control image rotation from the host.

> > Also faking v4l2 controls currently is not done yet in libv4l, so doing
> > this requires adding some infrastructure. All doable, but not at the top
> > of my todo list at the moment.
>
> So there is no software support yet.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
