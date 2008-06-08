Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58LO3DO018761
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 17:24:03 -0400
Received: from mailrelay001.isp.belgacom.be (mailrelay001.isp.belgacom.be
	[195.238.6.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m58LNmKT022641
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 17:23:49 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Sun, 8 Jun 2008 23:23:41 +0200
References: <484934FD.1080401@hhs.nl>
	<200806070054.51210.laurent.pinchart@skynet.be>
	<484A2B45.1090200@hhs.nl>
In-Reply-To: <484A2B45.1090200@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806082323.41607.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: uvc open/close race (Was Re: v4l1 compat wrapper version 0.3)
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

Hi Hans,

On Saturday 07 June 2008, Hans de Goede wrote:
> Laurent Pinchart wrote:
> > Hi Hans,
> >
> >> Some notes:
> >> 1) TRY_FMT should really never do I/O (but then I guess the
> >>     problem would still persists with S_FMT)
> >
> > Why not ? The UVC specification defines probe requests to negotiate the
> > streaming format. Unlike for most other devices, the UVC model requires
> > I/O in TRY_FMT.
>
> I would expect the driver to ask the camera what format it supports once,
> at probe and then cache that info,

The driver reads the list of supported frame formats, frames sizes and frame 
rates at initialisation time and caches the information. Calls to 
VIDIOC_ENUM_FRAMEFORMATS and VIDIOC_ENUM_FRAMESIZES do not result in any 
request to the device.

The UVC specification defines a protocol to negotiate the format with the 
camera. This is really a collaborative process. The drivers requests a set of 
streaming parameters, and the camera responds with possibly modified values 
depending on its capabilities.

> many applications do a lot of TRY_FMT calls in quick succession, so doing
> the querying then and each time seems like a bad idea to me.

Applications shouldn't. If they want to list the supported formats and sizes 
they should use VIDIOC_ENUM_FRAMEFORMATS and VIDIOC_ENUM_FRAMESIZES instead 
of VIDIOC_TRY_FMT.

> Esp as, as seen in my example try_fmt can now throw IO/errors whichs is
> somewhat strange IMHO. 
>
> Quoting from:
> http://lwn.net/Articles/227533/
>
> "The VIDIOC_TRY_FMT handlers are optional for drivers, but omitting this
> functionality is not recommended. If provided, this function is callable at
> any time, even if the device is currently operating. It should not make any
> changes to the actual hardware operating parameters; it is just a way for
> the application to find out what is possible."

The negotiation process doesn't change any hardware parameter. It just probes 
the device without committing any change.

> >> 2) I've also seen it fail at TRY_FMT 1 without first failing
> >>     a TRY_FMT 2, I guess that was just me doing arrow-up -> enter to
> >> quickly :)
> >
> > Could you please tell me what webcam you used, as well as what kernel
> > version you are running ?
>
> I'm using a Logitech sphere usb id: 046d:08cc
>
> Fedora kernel: kernel-2.6.25-8.fc9, which includes UVC (added by Fedora).

That's a very buggy webcam. It has nasty firmware issues. See 
http://www.quickcamteam.net/documentation/faq/logitech-webcam-linux-usb-incompatibilities

> > I would also appreciate if you could check the kernel log
> > for error messages after triggering the problem.
>
> No messages I'm afraid.

Now that's weird. The only error path that can return -EIO print a message to 
the kernel log. Could you please double check ?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
