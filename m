Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab2CFJim (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 04:38:42 -0500
Message-ID: <4F55DB8B.8050907@redhat.com>
Date: Tue, 06 Mar 2012 10:40:27 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Xavion <xavion.0@gmail.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	"Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com> <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com> <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com> <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com> <20120305182736.563df8b4@tele> <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com>
In-Reply-To: <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/06/2012 01:44 AM, Xavion wrote:
> Hi Guys
>
> Thanks very much for the follow-up emails.  Our time-zone differences
> prevented me from replying sooner.  I'm guessing you guys are both in
> Europe, whereas I'm down and across in Australia.
>
> As I plan to use this webcam for home security, I would prefer to keep
> the JPEG quality at or above 90% if possible.  This is because it'd be
> difficult enough to see a burglar's face clearly at 640x480 with
> lossless quality.
>
> The good news is that the nasty errors I was getting yesterday have
> magically disappeared overnight!

That is likely because the scene you're pointing at (or the lighting
conditions) have changed, not all pictures compress equally well
with JPEG. If you point the camera at the same scene as when you were
getting these errors (with similar, good, lighting conditions) you'll
likely see those errors re-surface.

> All I'm seeing today (at 90% and 75%
> quality) is what look to be non-fatal errors, since Motion seems to
> work correctly.
>
>      root@Desktop /etc/motion # tail /var/log/kernel.log
>      Mar  6 08:34:17 Desktop kernel: [ 7240.125167] gspca_main: ISOC
> data error: [0] len=0, status=-18
>      Mar  6 08:34:17 Desktop kernel: [ 7240.125172] gspca_main: ISOC
> data error: [1] len=0, status=-18
>      Mar  6 08:36:40 Desktop kernel: [ 7382.545241] gspca_main: ISOC
> data error: [0] len=0, status=-18
>      Mar  6 08:36:40 Desktop kernel: [ 7382.545246] gspca_main: ISOC
> data error: [1] len=0, status=-18
>      Mar  6 08:37:46 Desktop kernel: [ 7448.680301] gspca_sn9c20x: Set 640x480
>      Mar  6 08:40:12 Desktop kernel: [ 7594.685124] gspca_main: ISOC
> data error: [0] len=0, status=-18
>      Mar  6 08:40:12 Desktop kernel: [ 7594.685129] gspca_main: ISOC
> data error: [1] len=0, status=-18
>      Mar  6 08:42:37 Desktop kernel: [ 7739.715758] gspca_sn9c20x: Set 640x480
>      Mar  6 08:46:06 Desktop kernel: [ 7948.598533] gspca_main: ISOC
> data error: [0] len=0, status=-18
>      Mar  6 08:46:06 Desktop kernel: [ 7948.598538] gspca_main: ISOC
> data error: [1] len=0, status=-18

Hmm, error -18 is EXDEV, which according to Documentation/usb/error-codes.txt is:

-EXDEV                  ISO transfer only partially completed
                         (only set in iso_frame_desc[n].status, not urb->status)

I've seen those before, and I think we should simply ignore them rather then
log an error for them. Jean-Francois, what do you think?

> In fairness to Motion, the default JPEG quality listed in its
> configuration file is only 75%.  I had upped this to 90% for clarity,
> but subsequently reverting to the default configuration file didn't
> stop these errors.

That is a different JPG setting, that is the compression quality for the
JPEG's motion saves to disk if it detects motion. We're are talking about
the compression quality of the JPEG's going over the USB wire, which is
controller by the driver, not by motion.

> They also remained after I increased the three "vga_mode" ratios to "6
> / 8" or changed Line 2093 of "sn9c20x.c" to "sd->quality = 75;".

You mean the -18 error remain, right, that is expected, the
ratios / sd->quality only fix the errors you were seeing previously.

> Entering either of the following commands before starting Motion
> didn't make any difference either.
>      export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
>      export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
>
> The other thing I'm wondering about is how to force SXGA (1280x1024)
> mode to be used.  I've set the 'width' and 'height' variables in the
> Motion configuration file correctly, but I still see the following
> kernel output:
>      Mar  6 08:37:46 Desktop kernel: [ 7448.680301] gspca_sn9c20x: Set 640x480
>
> I should note that Motion defaults to "V4L2_PIX_FMT_YUV420" in its
> configuration file, which is what I'd been using until now.  From the
> look of the code in the "sn9c20x.c" file, I must use
> "V4L2_PIX_FMT_SBGGR8" to get the 1280x1024 resolution.

For sxga mode you will need to use libv4l, but I doubt if your camera supports
it at all, most don't. What does dmesg say immediately after unplugging and
replugging the camera?

Regards,

Hans
