Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37787 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2CHFe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 00:34:59 -0500
Received: by yenl12 with SMTP id l12so49652yen.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 21:34:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120307163224.412b4d2f@tele>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
 <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
 <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
 <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
 <20120305182736.563df8b4@tele> <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com>
 <4F55DB8B.8050907@redhat.com> <CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com>
 <20120307163224.412b4d2f@tele>
From: Xavion <xavion.0@gmail.com>
Date: Thu, 8 Mar 2012 16:34:39 +1100
Message-ID: <CAKnx8Y43mdhn8PyiR43=gYbEpyuV5i1_+Ahj8S7Yy3mLCZHiUA@mail.gmail.com>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Hans de Goede <hdegoede@redhat.com>,
	"Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Francois

> It seems that the webcams handled by the driver sn9c20x work the same
> as the ones handled by sonixj. In this last driver, I adjust the JPEG
> compression to avoid the errors "USB FIFO full", and I think that these
> errors also raise the URB error -18 with the sn9c20x. I will need some
> time to put a same code into the sn9c20x, then I'd be glad to have it
> tested.
>
> There was an other problem in the driver sonixj: the end of frame
> marker was not always at the right place. Xavion, as you have
> ms-windows, may you do some USB traces with this system? I need a
> capture sequence of about 15 seconds (not more) with big luminosity
> changes.

I've never needed to capture USB data manually until now, so I'm not
sure of which (free) Windows application I should use.  I'm assuming
that a software-only analyser would be good enough to provide the
information you're wanting.

I'm guessing that continuously blocking and unblocking the webcam's
vision will suffice for big luminosity changes.  Let me know if that's
not going to cut it and I'll repeatedly toggle the switch for the
ceiling light in my lounge-room (at night) instead.

I just tried to get the data using three different USB packet
sniffers.  The unfortunate results on my 32-bit Windows XP laptop are
listed below.  BTW, what size should the log-file have been after
capturing the fifteen seconds you're wanting?
* BusDog: Couldn't find the webcam device
* SniffUSB: The log file was 100+ MiB in size
* SnoopyPro: Couldn't capture any packets

> The sensor ov7660 can do VGA only (640x480).
>
> Otherwise, I uploaded a new gspca test version (2.15.3) with the JPEG compression control (default 80%). May you try it?

I've downloaded and tested GSPCA v2.15.3.  I'm sorry to nitpick, but
you still had "2.15.1" listed near the top of the "gspca.h" file.  I'm
also sorry to report that GSPCA v2.15.3 caused the following fatal
errors with my SN9C201 webcam:

    `--> tail /var/log/kernel.log
    Mar  8 10:21:09 Desktop kernel: [13758.712077] usb 1-5.5: new
high-speed USB device number 10 using ehci_hcd
    Mar  8 10:21:09 Desktop kernel: [13758.852838] Linux media interface: v0.10
    Mar  8 10:21:09 Desktop kernel: [13758.857354] Linux video capture
interface: v2.00
    Mar  8 10:21:09 Desktop kernel: [13758.858018] gspca_main: v2.15.3
registered
    Mar  8 10:21:09 Desktop kernel: [13758.858357] gspca_main:
gspca_sn9c20x-2.15.3 probing 0c45:627b
    Mar  8 10:21:09 Desktop kernel: [13758.886556] gspca_sn9c20x:
OV7660 sensor detected
    Mar  8 10:21:09 Desktop kernel: [13758.886647] input:
gspca_sn9c20x as
/devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5.5/input/input16
    Mar  8 10:21:09 Desktop kernel: [13758.886791] gspca_main: video0 created
    Mar  8 10:21:09 Desktop kernel: [13758.886823] usbcore: registered
new interface driver gspca_sn9c20x
    Mar  8 10:22:04 Desktop kernel: [13813.347291] gspca_sn9c20x: Set 640x480

    `--> tail /var/log/errors.log
    Mar  8 10:24:09 Desktop motion: [1] Error starting stream
VIDIOC_STREAMON: Input/output error
    Mar  8 10:24:09 Desktop motion: [1] ioctl (VIDIOCGCAP):
Inappropriate ioctl for device
    Mar  8 10:24:09 Desktop motion: [1] Could not fetch initial image
from camera
    Mar  8 10:24:09 Desktop motion: [1] Motion continues using width
and height from config file(s)
    Mar  8 10:24:10 Desktop motion: [1] Retrying until successful
connection with camera
    Mar  8 10:24:10 Desktop motion: [1] Error requesting buffers 4 for
memory map. VIDIOC_REQBUFS: Device or resource busy
    Mar  8 10:24:10 Desktop motion: [1] ioctl (VIDIOCGCAP):
Inappropriate ioctl for device
    Mar  8 10:24:20 Desktop motion: [1] Retrying until successful
connection with camera
    Mar  8 10:24:20 Desktop motion: [1] Error requesting buffers 4 for
memory map. VIDIOC_REQBUFS: Device or resource busy
    Mar  8 10:24:20 Desktop motion: [1] ioctl (VIDIOCGCAP):
Inappropriate ioctl for device
