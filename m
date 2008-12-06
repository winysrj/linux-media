Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6AO67u015550
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 05:24:06 -0500
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6ANprG004721
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 05:23:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Sat, 6 Dec 2008 11:23:46 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061123.46313.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: v4l2-compat-ioctl32.c weirdness
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

Hi Mauro,

Can you take a look at v4l2-compat-ioctl32.c, do_video_ioctl()?

This code can't be right:

        case VIDIOC_S_INPUT:
        case VIDIOC_OVERLAY:
        case VIDIOC_STREAMON:
        case VIDIOC_STREAMOFF:
                err = get_user(karg.vx, (u32 __user *)up);
                compatible_arg = 1;
                break;

Either compatible_arg should be 0, or these cases can be removed since 
they are handled in a standard manner.

In addition, karg.vx is an unsigned long, which does not match the 'int' 
I think it should be.

I also do not understand why there is special handling for ENUMINPUT and 
ENUMSTD.

And this looks extremely weird:

static inline int get_v4l2_input32(struct v4l2_input *kp, struct 
v4l2_input __user *up)
{
        if (copy_from_user(kp, up, sizeof(struct v4l2_input) - 4))
                return -EFAULT;
        return 0;
}

No comments to enlighten the reader of what's going on here.

I'm trying to add the missing ioctls to this source, but I first like to 
understand what is going on in the first place.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
