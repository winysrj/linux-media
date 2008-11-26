Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQHFNLv002873
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 12:15:23 -0500
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQHFAHH014611
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 12:15:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Wed, 26 Nov 2008 18:15:07 +0100
References: <hvaibhav@ti.com>
	<1227719079-19459-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1227719079-19459-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811261815.07648.hverkuil@xs4all.nl>
Cc: linux-omap@vger.kernel.org, Karicheri Muralidharan <m-karicheri2@ti.com>,
	davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: Re: [PATCH 1/2] Add Input/Output related ioctl support
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

On Wednesday 26 November 2008 18:04:39 hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
> Note - Resending again with TVP driver for completeness.
>
> Added ioctl support for query std, set std, enum input,
> get input, set input, enum output, get output and set output.
>
> For sensor kind of slave drivers v4l2-int-device.h provides
> necessary ioctl support, but the ioctls required to interface
> with decoders and encoders are missing. Most of the decoders
> and encoders supports multiple inputs and outputs, like
> S-Video or Composite.
>
> With these ioctl''s user can select the specific input/output.
>
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> Signed-off-by: Manjunath Hadli <mrh@ti.com>
> Signed-off-by: R Sivaraj <sivaraj@ti.com>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Karicheri Muralidharan <m-karicheri2@ti.com>
> ---
>  include/media/v4l2-int-device.h |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/include/media/v4l2-int-device.h
> b/include/media/v4l2-int-device.h index 9c2df41..2325b2a 100644
> --- a/include/media/v4l2-int-device.h
> +++ b/include/media/v4l2-int-device.h
> @@ -102,6 +102,7 @@ enum v4l2_power {
>  	V4L2_POWER_OFF = 0,
>  	V4L2_POWER_ON,
>  	V4L2_POWER_STANDBY,
> +	V4L2_POWER_RESUME,
>  };

Why is POWER_RESUME added? In an earlier discussion with Sakari Ailus it 
was decided not to add this (see the video4linux thread with 
subject "[PATCH 4/6] V4L: Int if: Define new power state changes").

It also wasn't in your original patch.

Regards,

	Hans

>
>  /* Slave interface type. */
> @@ -183,6 +184,14 @@ enum v4l2_int_ioctl_num {
>  	vidioc_int_s_crop_num,
>  	vidioc_int_g_parm_num,
>  	vidioc_int_s_parm_num,
> +	vidioc_int_querystd_num,
> +	vidioc_int_s_std_num,
> +	vidioc_int_enum_input_num,
> +	vidioc_int_g_input_num,
> +	vidioc_int_s_input_num,
> +	vidioc_int_enumoutput_num,
> +	vidioc_int_g_output_num,
> +	vidioc_int_s_output_num,
>
>  	/*
>  	 *
> @@ -284,6 +293,14 @@ V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
>  V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
>  V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
>  V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
> +V4L2_INT_WRAPPER_1(querystd, v4l2_std_id, *);
> +V4L2_INT_WRAPPER_1(s_std, v4l2_std_id, *);
> +V4L2_INT_WRAPPER_1(enum_input, struct v4l2_input, *);
> +V4L2_INT_WRAPPER_1(g_input, int, *);
> +V4L2_INT_WRAPPER_1(s_input, int, );
> +V4L2_INT_WRAPPER_1(enumoutput, struct v4l2_output, *);
> +V4L2_INT_WRAPPER_1(g_output, int, *);
> +V4L2_INT_WRAPPER_1(s_output, int, );
>
>  V4L2_INT_WRAPPER_0(dev_init);
>  V4L2_INT_WRAPPER_0(dev_exit);
> --
> 1.5.6
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
