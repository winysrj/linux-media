Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7CGG4wI012423
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 12:16:04 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7CGFqXa008716
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 12:15:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 12 Aug 2008 18:15:50 +0200
References: <sivaraj@ti.com> <1218532908-11505-1-git-send-email-sivaraj@ti.com>
In-Reply-To: <1218532908-11505-1-git-send-email-sivaraj@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121815.50930.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [PATCH] Addition of Input/Output related V4L2 Int Ioctl
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

On Tuesday 12 August 2008 11:21:48 Sivaraj R wrote:
> Added v4l2 interface ioctls for query std, set std, enum input, set
> input, get input, enum output, set output and get output.
>
> Reason for change:
> v4l2-int-device.h file was introduced to interface with sensor device
> drivers (slave) with main video driver (master). But the ioctls
> required to interface with decoders and encoders were missing. Most
> of the decoders and encoders support multiple inputs/outputs
> interfaces like s-video/composite. These ioctls are used to select
> between these inputs/outputs.

I discussed this patch with Manju today, and I want to hold off on this 
patch until I have a better idea how it is used in an actual driver. I 
am not convinced this is the right approach, but I need to see actual 
code that uses it before I can judge it.

So - for now - I NAK this patch.

Regards,

	Hans

>
> Signed-off-by: Brijesh R Jadav <brijesh.j@ti.com>
>                Hardik Shah <hardik.shah@ti.com>
>                Manjunath Hadli <mrh@ti.com>
>                Sivaraj R <sivaraj@ti.com>
>                Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  include/media/v4l2-int-device.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/include/media/v4l2-int-device.h
> b/include/media/v4l2-int-device.h index c8b80e0..856f1fe 100644
> --- a/include/media/v4l2-int-device.h
> +++ b/include/media/v4l2-int-device.h
> @@ -172,6 +172,14 @@ enum v4l2_int_ioctl_num {
>  	vidioc_int_s_ctrl_num,
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
> @@ -263,6 +271,14 @@ V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control,
> *); V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
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
