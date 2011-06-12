Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47185 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1FLP3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 11:29:42 -0400
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <201106121423.17503.hverkuil@xs4all.nl> <4DF4C912.7050805@redhat.com> <201106121633.45020.hverkuil@xs4all.nl>
In-Reply-To: <201106121633.45020.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner mode.
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 12 Jun 2011 11:29:48 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <551d8a80-376f-45db-b62b-14b7b44ca403@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>On Sunday, June 12, 2011 16:11:30 Mauro Carvalho Chehab wrote:
>> Em 12-06-2011 09:23, Hans Verkuil escreveu:
>> > That's not unreasonably to do at some point in time, but it doesn't
>actually
>> > answer my question, which is: should the core refuse
>VIDIOC_S_FREQUENCY calls
>> > where the type doesn't match the device node (i.e. radio vs tv)? I
>think it
>> > makes no sense to call VIDIOC_S_FREQUENCY on a radio node with type
>ANALOG_TV.
>> 
>> No. The core shouldn't do it, otherwise tuner will break. The code
>doesn't know if
>> the opened device is radio or video.
>
>I don't follow this. In v4l2-ioctl.c it is easy to tell if the opened
>device
>is radio or not by looking at vfd->vfl_type.
>
>> >> diff --git a/drivers/media/video/cx18/cx18-ioctl.c
>b/drivers/media/video/cx18/cx18-ioctl.c
>> >> index 1933d4d..5463548 100644
>> >> --- a/drivers/media/video/cx18/cx18-ioctl.c
>> >> +++ b/drivers/media/video/cx18/cx18-ioctl.c
>> >> @@ -611,6 +611,11 @@ static int cx18_g_frequency(struct file
>*file, void *fh,
>> >>  	if (vf->tuner != 0)
>> >>  		return -EINVAL;
>> >>  
>> >> +	if (test_bit(CX18_F_I_RADIO_USER, &cx->i_flags))
>> >> +		vf->type = V4L2_TUNER_RADIO;
>> >> +	else
>> >> +		vf->type = V4L2_TUNER_ANALOG_TV;
>> >> +
>> > 
>> > NACK.
>> > 
>> > This sets the type to the current mode. But what we want is to set
>the type to
>> > the current device node. That's what my RFCv4 does (and that patch
>requires no
>> > driver change).
>> 
>> I didn't get your RFCv4 patches here yet, but the fix should be at
>the driver: it
>> needs to set the type before calling g_frequency. G_FREQUENCY
>shouldn't change the
>> device mode, but, instead, to return the frequency and mode currently
>in usage..
>
>Why bother changing drivers (and probably missing a few) if you can do
>it
>in v4l2-ioctl.c and let drivers just pass it on?
>
>This is the patch in question, BTW:
>
>diff --git a/drivers/media/video/v4l2-ioctl.c
>b/drivers/media/video/v4l2-ioctl.c
>index 213ba7d..26bf3bf 100644
>--- a/drivers/media/video/v4l2-ioctl.c
>+++ b/drivers/media/video/v4l2-ioctl.c
>@@ -1822,6 +1822,8 @@ static long __video_do_ioctl(struct file *file,
>                if (!ops->vidioc_g_tuner)
>                        break;
> 
>+               p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>+                       V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>                ret = ops->vidioc_g_tuner(file, fh, p);
>                if (!ret)
>                        dbgarg(cmd, "index=%d, name=%s, type=%d, "
>@@ -1840,6 +1842,8 @@ static long __video_do_ioctl(struct file *file,
> 
>                if (!ops->vidioc_s_tuner)
>                        break;
>+               p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>+                       V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>                dbgarg(cmd, "index=%d, name=%s, type=%d, "
>                                "capability=0x%x, rangelow=%d, "
>                                "rangehigh=%d, signal=%d, afc=%d, "
>@@ -1858,6 +1862,8 @@ static long __video_do_ioctl(struct file *file,
>                if (!ops->vidioc_g_frequency)
>                        break;
> 
>+               p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>+                       V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>                ret = ops->vidioc_g_frequency(file, fh, p);
>                if (!ret)
>                       dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
>
>Neither of these three ioctls will change the tuner mode, BTW. With
>this
>code in place drivers that use video_ioctl2 can now rely on the type
>field
>being a sensible value.
> 
>Regards,
>
>	Hans
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Right.  In fact for s_tuner (and g_tuner) the spec implies that app writers should not fill in the field. 

BTW, S_tuner only really changes analog audio decoding right?

Regards,
Andy
