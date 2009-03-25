Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2PEHfv3030295
	for <video4linux-list@redhat.com>; Wed, 25 Mar 2009 10:17:41 -0400
Received: from mail-qy0-f104.google.com (mail-qy0-f104.google.com
	[209.85.221.104])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2PEHJxD013551
	for <video4linux-list@redhat.com>; Wed, 25 Mar 2009 10:17:19 -0400
Received: by qyk2 with SMTP id 2so81893qyk.23
	for <video4linux-list@redhat.com>; Wed, 25 Mar 2009 07:17:18 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Wed, 25 Mar 2009 11:17:06 -0300
References: <200903231708.08860.lamarque@gmail.com>
	<200903241909.59494.lamarque@gmail.com> <49C9F356.2010801@hhs.nl>
In-Reply-To: <49C9F356.2010801@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251117.07201.lamarque@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4
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

Em Wednesday 25 March 2009, Hans de Goede escreveu:
> On 03/24/2009 11:09 PM, Lamarque Vieira Souza wrote:
> > 	Hi,
> >
> > 	Applying this patch to libv4l makes Skype works with my webcam without
> > changing the driver. Do you think the patch is ok?
>
> No it is not ok, luckily I've also read the rest of this thread, where you 
write:
>  > 	I have found the problem. The vidioc_try_fmt_vid_cap function in the
>  > driver return -EINVAL if the fmt.pix.field is different from
>  > V4L2_FIELD_ANY or V4L2_FIELD_NONE. Skype seems to set this field as
>  > V4L2_FIELD_INTERLACED. Because of that libv4l assumes that all
>  > destination formats (YUV420 included) are invalid. Commenting this part
>  > of the driver makes Skype work and it is showing pictures. YES!!! :-)
>
> What you are seeing is a bug in the driver. VIDIOC_TRY_FMT should *never*
> return -EINVAL, except, and that is the only exception when it does not
> support the passed in type, so v4l2_format.type is something which is not
> supported, note that when vidioc_try_fmt_vid_cap is called the type is
> already checked (hence the _vid_ in the function name).

	Well, so there are some drivers in the kernel with this bug too (all in 
linux/drivers/media/video/ directory): meye.c and soc_camera.c (those two does 
exactly as zr364xx.c does); bt8xx/bttv-driver.c (this one returns -EINVAL if a 
combination of field (V4L2_FIELD_SEQ_TB) and flags (FORMAT_FLAGS_PLANAR) is 
invalid) or when field value is unknow, if it is unknow it really should 
return -EINVAL. Some drivers (cx18/cx18-ioctl.c, em28xx/em28xx-video.c, 
ivtv/ivtv-ioctl.c and stk-webcam.c) just set the field value to one they 
accept without even reading what value was passed to them and some 
(cx23885/cx23885-417.c and gspca/gspca.c) just ignores the field value 
returning what as passed to them. cx23885/cx23885-video.c, cx88/cx88-video.c 
and saa7134/saa7134-video.c will return -EINVAL if you pass 
V4L2_FIELD_ALTERNATE or V4L2_FIELD_SEQ_TB in the field field, if you pass 
V4L2_FIELD_ANY they will try to find one field value that is ok for them. 
s2255drv.c does more effort to validate the field value, in some cases it will 
return -EINVAL if it does not find a good value for the field field.

	Besides, vivi.c does something similar to zr364xx.c. It returns -EINVAL if 
the field value is different from V4L2_FIELD_ANY or V4L2_FIELD_INTERLACED. So 
if you pass V4L2_FIELD_NONE to vivi.c's try_fmt it will return -EINVAL too.

	What I am seeing here is that each driver behaves differently. So what is the 
correct behaviour?:

1. ignores the field value.
2. set the field value inconditionally to one value that the driver accepts.
3. only set the field value to one value that the driver accepts if 
V4L2_FIELD_ANY is passed to the driver (this one is what zr364xx.c and vivi.c 
do).

> When any member of fmt.pix. is not supported it should set it to something
> which it does support (and the app should check what it got) so the proper
> fix is to always set fmt.pix.field to V4L2_FIELD_NONE in the driver
> (V4L2_FIELD_ANY is an input only value, a format returned by a driver
> should never have V4L2_FIELD_ANY).

	So the behaviour number two is the correct one. So someone must change vivi.c 
as it is used as a guide to create new v4l2 drivers, although I still thinks 
the zr364xx.c and vivi.c do the logical thing: only changes the field value if 
the application allowed them to (when passing V4L2_FIELD_ANY).

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
