Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UKYiHn015931
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 16:34:45 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7UKYWMI028131
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 16:34:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sat, 30 Aug 2008 22:34:26 +0200
References: <A24693684029E5489D1D202277BE89441191E339@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89441191E339@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302234.26296.hverkuil@xs4all.nl>
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

Some initial comments (things seen when scanning through the patches):

- Please add a small comment at the top of the driver sources explaining 
what a certain abbreviation means (e.g. 'ISP', 'H3A', etc.) and what 
the driver does.

- Patch 10 seems to have some devfs support (resizer). Devfs is dead and 
should not be used.

- The previewer uses register_chrdev while the resizer uses 
alloc_chrdev_region. The latter is the preferred solution since 
register_chrdev allocates a block of 256 minors, which seems to be 
overkill.

- The previewer and resizer basically create a new public API. Can you 
give a short description of that API and how it is used? I need some 
more information about it. In general I would say that a document 
describing these drivers and esp. the driver-specific public API is 
required.

- Can you test whether these patches apply to the latest v4l-dvb 
repository? There have been a lot of changes this weekend and it is 
probably good to check this.

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
