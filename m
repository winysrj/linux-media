Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33425 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab2CFAoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 19:44:54 -0500
Received: by iagz16 with SMTP id z16so6274800iag.19
        for <linux-media@vger.kernel.org>; Mon, 05 Mar 2012 16:44:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120305182736.563df8b4@tele>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
 <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
 <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
 <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
 <20120305182736.563df8b4@tele>
From: Xavion <xavion.0@gmail.com>
Date: Tue, 6 Mar 2012 11:44:34 +1100
Message-ID: <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
To: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Cc: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guys

Thanks very much for the follow-up emails.  Our time-zone differences
prevented me from replying sooner.  I'm guessing you guys are both in
Europe, whereas I'm down and across in Australia.

As I plan to use this webcam for home security, I would prefer to keep
the JPEG quality at or above 90% if possible.  This is because it'd be
difficult enough to see a burglar's face clearly at 640x480 with
lossless quality.

The good news is that the nasty errors I was getting yesterday have
magically disappeared overnight!  All I'm seeing today (at 90% and 75%
quality) is what look to be non-fatal errors, since Motion seems to
work correctly.

    root@Desktop /etc/motion # tail /var/log/kernel.log
    Mar  6 08:34:17 Desktop kernel: [ 7240.125167] gspca_main: ISOC
data error: [0] len=0, status=-18
    Mar  6 08:34:17 Desktop kernel: [ 7240.125172] gspca_main: ISOC
data error: [1] len=0, status=-18
    Mar  6 08:36:40 Desktop kernel: [ 7382.545241] gspca_main: ISOC
data error: [0] len=0, status=-18
    Mar  6 08:36:40 Desktop kernel: [ 7382.545246] gspca_main: ISOC
data error: [1] len=0, status=-18
    Mar  6 08:37:46 Desktop kernel: [ 7448.680301] gspca_sn9c20x: Set 640x480
    Mar  6 08:40:12 Desktop kernel: [ 7594.685124] gspca_main: ISOC
data error: [0] len=0, status=-18
    Mar  6 08:40:12 Desktop kernel: [ 7594.685129] gspca_main: ISOC
data error: [1] len=0, status=-18
    Mar  6 08:42:37 Desktop kernel: [ 7739.715758] gspca_sn9c20x: Set 640x480
    Mar  6 08:46:06 Desktop kernel: [ 7948.598533] gspca_main: ISOC
data error: [0] len=0, status=-18
    Mar  6 08:46:06 Desktop kernel: [ 7948.598538] gspca_main: ISOC
data error: [1] len=0, status=-18

In fairness to Motion, the default JPEG quality listed in its
configuration file is only 75%.  I had upped this to 90% for clarity,
but subsequently reverting to the default configuration file didn't
stop these errors.

They also remained after I increased the three "vga_mode" ratios to "6
/ 8" or changed Line 2093 of "sn9c20x.c" to "sd->quality = 75;".
Entering either of the following commands before starting Motion
didn't make any difference either.
    export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
    export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so

The other thing I'm wondering about is how to force SXGA (1280x1024)
mode to be used.  I've set the 'width' and 'height' variables in the
Motion configuration file correctly, but I still see the following
kernel output:
    Mar  6 08:37:46 Desktop kernel: [ 7448.680301] gspca_sn9c20x: Set 640x480

I should note that Motion defaults to "V4L2_PIX_FMT_YUV420" in its
configuration file, which is what I'd been using until now.  From the
look of the code in the "sn9c20x.c" file, I must use
"V4L2_PIX_FMT_SBGGR8" to get the 1280x1024 resolution.

After making this change, I still saw "Set 640x480" in the kernel
output.  How can the above errors be overcome and how can I force SXGA
mode to be used by my applications?  Thanks again for all of the
assistance you've given me so far.
