Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60657 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965302Ab2CFW7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 17:59:49 -0500
Received: by iagz16 with SMTP id z16so7706564iag.19
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2012 14:59:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F55DB8B.8050907@redhat.com>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
 <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
 <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
 <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
 <20120305182736.563df8b4@tele> <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com>
 <4F55DB8B.8050907@redhat.com>
From: Xavion <xavion.0@gmail.com>
Date: Wed, 7 Mar 2012 09:59:28 +1100
Message-ID: <CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	"Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

>> The good news is that the nasty errors I was getting yesterday have
>> magically disappeared overnight!
>
> That is likely because the scene you're pointing at (or the lighting
> conditions) have changed, not all pictures compress equally well
> with JPEG. If you point the camera at the same scene as when you were
> getting these errors (with similar, good, lighting conditions) you'll
> likely see those errors re-surface.

At the time, I thought it was probably just because I hadn't rebooted
my computer after installing GSPCA v2.15.1 the previous day.  If those
nastier errors resurface, I'll test whether they can be suppressed by
making those changes to "sn9c20x.c" again.

>>     root@Desktop /etc/motion # tail /var/log/kernel.log
>>     Mar  6 08:34:17 Desktop kernel: [ 7240.125167] gspca_main: ISOC
>> data error: [0] len=0, status=-18
>>    ...
>
> Hmm, error -18 is EXDEV, which according to
> Documentation/usb/error-codes.txt is:
>
> -EXDEV                  ISO transfer only partially completed
>                        (only set in iso_frame_desc[n].status, not
> urb->status)
>
> I've seen those before, and I think we should simply ignore them rather then
> log an error for them. Jean-Francois, what do you think?

I'll let you guys decide what to do about this, but remember that I'm
here to help if you need more testing done.  If you want my opinion,
I'd be leaning towards trying to prevent any errors that appear
regularly.

>> In fairness to Motion, the default JPEG quality listed in its
>> configuration file is only 75%.  I had upped this to 90% for clarity,
>> but subsequently reverting to the default configuration file didn't
>> stop these errors.
>
> That is a different JPG setting, that is the compression quality for the
> JPEG's motion saves to disk if it detects motion. We're are talking about
> the compression quality of the JPEG's going over the USB wire, which is
> controller by the driver, not by motion.

I thought that was probably the case, but I left open the possibility
that Motion could've been telling GSPCA what JPEG setting to use for
USB transfers.

>> They also remained after I increased the three "vga_mode" ratios to "6
>> / 8" or changed Line 2093 of "sn9c20x.c" to "sd->quality = 75;".
>
> You mean the -18 error remain, right, that is expected, the
> ratios / sd->quality only fix the errors you were seeing previously.

Yes, I was only seeing the "-18" error message yesterday.  I knew that
the "vga_mode" and "sd->quality" suggestions were intended for the
other (nastier) errors.  As I couldn't be sure that the "-18" error
wasn't somehow related, I decided to test those suggestions on it as
well.

>> Entering either of the following commands before starting Motion
>> didn't make any difference either.
>>     export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
>>     export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
>>
>> The other thing I'm wondering about is how to force SXGA (1280x1024)
>> mode to be used.  I've set the 'width' and 'height' variables in the
>> Motion configuration file correctly, but I still see the following
>> kernel output:
>>     Mar  6 08:37:46 Desktop kernel: [ 7448.680301] gspca_sn9c20x: Set
>> 640x480
>>
>> I should note that Motion defaults to "V4L2_PIX_FMT_YUV420" in its
>> configuration file, which is what I'd been using until now.  From the
>> look of the code in the "sn9c20x.c" file, I must use
>> "V4L2_PIX_FMT_SBGGR8" to get the 1280x1024 resolution.
>
> For sxga mode you will need to use libv4l, but I doubt if your camera
> supports
> it at all, most don't. What does dmesg say immediately after unplugging and
> replugging the camera?

The software I use to control my webcam in Windows can increase the
snapshot zoom to what it calls 'SXGA'.  Closer inspection reveals that
it's actually just doubling the 640x480 image - via nearest-neighbour
interpolation - to get a rather pixelated 1280x960.

This isn't even the proper SXGA resolution, which is supposed to be
1280x1024.  The Sonix website claims that their SN9C201 webcam can
provide up to a 1.3 MP (SXGA) video size!  Do you happen to know of
any inexpensive webcams that are capable of true SXGA in Linux?

    `--> lsusb | grep Cam
    Bus 001 Device 006: ID 0c45:627b Microdia PC Camera (SN9C201 + OV7660)

    `--> dmesg
    ...
    [ 5155.396674] usb 5-5.5: USB disconnect, device number 5
    [ 5155.396835] gspca_main: video0 disconnect
    [ 5155.440019] gspca_main: video0 released
    [ 5159.946302] usb 5-5.5: new high-speed USB device number 6 using ehci_hcd
    [ 5160.045863] gspca_main: sn9c20x-2.15.1 probing 0c45:627b
    [ 5160.071035] gspca_sn9c20x: OV7660 sensor detected
    [ 5160.071146] input: sn9c20x as
/devices/pci0000:00/0000:00:1d.7/usb5/5-5/5-5.5/input/input8
    [ 5160.071277] gspca_main: video0 created

As mentioned above, I had already tried exporting "LD_PRELOAD" for
both V4L v1 and v2 beforehand.  Furthermore, the two
"V4L2_PIX_FMT_..." Motion settings I've used both begin with "V4L2".
Let me know if there's anything else I should do to ensure that Motion
is using V4L.
