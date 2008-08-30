Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7U78IML006893
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 03:08:19 -0400
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7U7825X018473
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 03:08:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sat, 30 Aug 2008 09:08:01 +0200
References: <A24693684029E5489D1D202277BE89441191E339@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89441191E339@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808300908.01182.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [PATCH 2/15] OMAP3 camera driver: V4L2: Adding internal IOCTLs
	for crop.
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

Hi,

Did something happen to PATCH 1/15? Patch 2/15 is the first I see.

Regards,

	Hans

On Saturday 30 August 2008 01:37:11 Aguirre Rodriguez, Sergio Alberto 
wrote:
> From: Sameer Venkatraman <sameerv@ti.com>
>
> V4L2: Adding internal IOCTLs for crop.
>
> Adding internal IOCTLs for crop.
>
> Signed-off-by: Sameer Venkatraman <sameerv@ti.com>
> Signed-off-by: Mohit Jalori <mjalori@ti.com>
> ---
>  include/media/v4l2-int-device.h |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> Index: linux-omap-2.6/include/media/v4l2-int-device.h
> ===================================================================
> --- linux-omap-2.6.orig/include/media/v4l2-int-device.h	2008-08-25
> 12:19:09.000000000 -0500 +++
> linux-omap-2.6/include/media/v4l2-int-device.h	2008-08-25
> 12:19:10.000000000 -0500 @@ -170,6 +170,9 @@
>  	vidioc_int_queryctrl_num,
>  	vidioc_int_g_ctrl_num,
>  	vidioc_int_s_ctrl_num,
> +	vidioc_int_cropcap_num,
> +	vidioc_int_g_crop_num,
> +	vidioc_int_s_crop_num,
>  	vidioc_int_g_parm_num,
>  	vidioc_int_s_parm_num,
>
> @@ -266,6 +269,9 @@
>  V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
>  V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
>  V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
> +V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
> +V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
> +V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
>  V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
>  V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
>
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
