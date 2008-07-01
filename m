Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61LSVN5026971
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 17:28:31 -0400
Received: from mailrelay007.isp.belgacom.be (mailrelay007.isp.belgacom.be
	[195.238.6.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61LSAJs018543
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 17:28:10 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "David Ellingsworth" <david@identd.dyndns.org>
Date: Tue, 1 Jul 2008 23:28:08 +0200
References: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
	<200806300315.42610.laurent.pinchart@skynet.be>
	<30353c3d0806292009r5556afd6s5d5e271d1c7ff575@mail.gmail.com>
In-Reply-To: <30353c3d0806292009r5556afd6s5d5e271d1c7ff575@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012328.08469.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] videodev: properly reference count video_device
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

Hi David,

you sure seem in a hurry :-) I haven't had time to answer your mail yesterday, 
sorry.

On Monday 30 June 2008, David Ellingsworth wrote:
> On Sun, Jun 29, 2008 at 9:15 PM, Laurent Pinchart
>
> <laurent.pinchart@skynet.be> wrote:
> > Hi David,
> >
> > On Sunday 29 June 2008, David Ellingsworth wrote:
> >> I noticed that the video_device structure wasn't properly being
> >> reference counted. Under certain circumstances,
> >
> > Can you detail those certain circumstances ?
>
> Sure.
>
> For drivers which have to handle unexpected disconnects, I.E. usb and
> pci drivers, it's possible for a user to physically remove the device
> while it is in use. In the usb/pci disconnect callback, the correct 
> thing to do is to unregister the device in order to prevent future
> opens.

Unregistering the device ultimately frees resources, so 
video_unregister_device() in its current form can't be called in the 
disconnect callback, we agree on that.

> When video_unregister_device is called in this context, it sets 
> video_device[minor number] to NULL and calls device_unregister().
> device_unregister() causes the release callback to be called when the
> sysfs entry is no longer in use. Under most circumstances, the release
> callback occurs right after the call to device_unregister(). This will
> cause a crash in __video_do_ioctl(), called from video_ioctl2, when
> subsequent ioctls are encountered since the return value of
> video_devdata() is NULL

Your analysis is correct.

> Current drivers do one of two things to avoid this crash. They either
> use a custom ioctl callback and return an error when video_devdata()
> is NULL,

That opens the door to race conditions. I don't think this approach can safely 
be implemented without modifying the videodev core.

> or they delay the call to video_unregister_device until the 
> final close occurs. The first solution means that if a usb/pci driver
> uses video_devdata() in its ioctl or release callback, it has to check
> that the return is not NULL. The second means the drivers must be
> prepared to handle opens after the pci/usb disconnect callback has
> been called since the video device is still registered.

That's right. This is just a matter of setting a flag in the disconnect 
callback, and checking the flag in the open handler.

> This patch prevents the video_device struct from being freed under the
> circumstances above, and should not affect the behavior of current
> drivers. The reference count is set to 1 during video_register_device,
> incremented during video_open, and decremented during video_close and
> video_unregister_device. Thus allowing for the following series of
> calls to occur.
>
> With patch:
> -----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect -> video_unregister_device
> video_ioctl2
> video_close -> usb/pci_close
> release_callback
>
> Without patch:
> -----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect -> video_unregister_device
> release_callback
> video_ioctl2 (crash)
>
> Without patch (crash avoidance #1)
> ----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect -> video_unregister_device
> release_callback
> usb/pci_ioctl (return err, video_devdata() is NULL)
> usb/pci_close (return err, video_devdata() is NULL)
>
> Without patch (crash avoidance #2)
> ----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect
> video_ioctl2
> usb/pci_close -> video_unregister_device
> release_callback

What's wrong with the 'crash avoidance #2' use case ?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
