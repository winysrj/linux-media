Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab2CEIbd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Mar 2012 03:31:33 -0500
Message-ID: <4F547A4E.9090703@redhat.com>
Date: Mon, 05 Mar 2012 09:33:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Xavion <xavion.0@gmail.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	"Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com> <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com> <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com> <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
In-Reply-To: <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/04/2012 10:58 PM, Xavion wrote:
> Hi Jean-Francois
>
> I can confirm that GSPCA v2.15.1 removes the bad pixels when I use
> Cheese or VLC.  However, I'm sorry to report that the Motion problems
> unfortunately still remain.  Is there something else I must do to
> overcome the below errors?  I'm happy to keep testing newer GSPCA
> versions for you until we get this fixed.

I guess that motion is using the JPG compressed frames rather then
the i420 like special format these cameras also support, and it looks
like we don't reserve enoug space to buffer these frames. To fix this
we need to enlarge the size we reserve per frame in the sn9c20x driver,
edit sn9c20x.c and search for vga_mode, in that table you will
find a factor "4 / 8" (its in there 3 times), change all 3 occurences
to "5 / 8" and try again, then "6 / 8", etc.

Normally I would be suspicious about SOF / EOF detection when we
need such a factor, but the timestamps in your log exactly match 30
fps, so that seems to be fine. And in my experience with the USB bandwidth
stuff the sn9c20x does seem to compress less then other JPG cams, so
it makes sense that it needs bigger buffers to store the frames too.

Alternatively you can try if motion can be made to use a different format
then JPG, by forcing it to use libv4l by starting it like this:
LD_PRELOAD=/usr/lib/libv4l/v4l1-compat.so motion

Note if you're on a rpm based 64 bit distro and motion is 64 bit too
that should be:
LD_PRELOAD=/usr/lib64/libv4l/v4l1-compat.so motion

But that would just be working around the issue, it is better to
fix the issue with using the JPG mode of the camera instead.

Regards,

Hans





>
>
> `-->  tail /var/log/kernel.log
> Mar  5 08:25:52 Desktop kernel: [ 6673.781987] gspca_main: frame
> overflow 156309>  155648
> Mar  5 08:25:52 Desktop kernel: [ 6673.813992] gspca_main: frame
> overflow 156309>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6673.849986] gspca_main: frame
> overflow 155693>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6673.881989] gspca_main: frame
> overflow 156021>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6673.917991] gspca_main: frame
> overflow 156309>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6673.949993] gspca_main: frame
> overflow 156309>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6673.985990] gspca_main: frame
> overflow 156309>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6674.021981] gspca_main: frame
> overflow 156309>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6674.053985] gspca_main: frame
> overflow 156309>  155648
> Mar  5 08:25:53 Desktop kernel: [ 6674.089989] gspca_main: frame
> overflow 156309>  155648
>
>
> `-->  tail /var/log/errors.log
> Mar  5 08:24:16 Desktop motion: [1] v4l2_next: VIDIOC_QBUF: Invalid argument
> Mar  5 08:24:16 Desktop motion: [1] Video device fatal error - Closing
> video device
> Mar  5 08:24:20 Desktop motion: [1] Retrying until successful
> connection with camera
> Mar  5 08:24:27 Desktop motion: [1] v4l2_next: VIDIOC_DQBUF: EIO
> (s->pframe 3): Input/output error
> Mar  5 08:24:27 Desktop motion: [1] v4l2_next: VIDIOC_QBUF: Invalid argument
> Mar  5 08:24:27 Desktop motion: [1] Video device fatal error - Closing
> video device
> Mar  5 08:24:30 Desktop motion: [1] Retrying until successful
> connection with camera
> Mar  5 08:24:33 Desktop motion: [1] v4l2_next: VIDIOC_DQBUF: EIO
> (s->pframe 0): Input/output error
> Mar  5 08:24:33 Desktop motion: [1] v4l2_next: VIDIOC_QBUF: Invalid argument
> Mar  5 08:24:33 Desktop motion: [1] Video device fatal error - Closing
> video device
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
