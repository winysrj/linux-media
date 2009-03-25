Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2P91vE6011742
	for <video4linux-list@redhat.com>; Wed, 25 Mar 2009 05:01:57 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2P91bBS018341
	for <video4linux-list@redhat.com>; Wed, 25 Mar 2009 05:01:37 -0400
Message-ID: <49C9F356.2010801@hhs.nl>
Date: Wed, 25 Mar 2009 10:03:18 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Lamarque Vieira Souza <lamarque@gmail.com>
References: <200903231708.08860.lamarque@gmail.com> <49C8AF04.7070208@hhs.nl>
	<200903241909.59494.lamarque@gmail.com>
In-Reply-To: <200903241909.59494.lamarque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

On 03/24/2009 11:09 PM, Lamarque Vieira Souza wrote:
> 	Hi,
>
> 	Applying this patch to libv4l makes Skype works with my webcam without
> changing the driver. Do you think the patch is ok?
>

No it is not ok, luckily I've also read the rest of this thread, where you write:

 > 	I have found the problem. The vidioc_try_fmt_vid_cap function in the driver
 > return -EINVAL if the fmt.pix.field is different from V4L2_FIELD_ANY or
 > V4L2_FIELD_NONE. Skype seems to set this field as V4L2_FIELD_INTERLACED.
 > Because of that libv4l assumes that all destination formats (YUV420 included)
 > are invalid. Commenting this part of the driver makes Skype work and it is
 > showing pictures. YES!!! :-)
 >

What you are seeing is a bug in the driver. VIDIOC_TRY_FMT should *never*
return -EINVAL, except, and that is the only exception when it does not
support the passed in type, so v4l2_format.type is something which is not
supported, note that when vidioc_try_fmt_vid_cap is called the type is
already checked (hence the _vid_ in the function name).

When any member of fmt.pix. is not supported it should set it to something
which it does support (and the app should check what it got) so the proper
fix is to always set fmt.pix.field to V4L2_FIELD_NONE in the driver
(V4L2_FIELD_ANY is an input only value, a format returned by a driver
should never have V4L2_FIELD_ANY).

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
