Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HB3oh0001411
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 07:03:50 -0400
Received: from smtp-vbr13.xs4all.nl (smtp-vbr13.xs4all.nl [194.109.24.33])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HB3cdo022676
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 07:03:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Thu, 17 Jul 2008 13:03:32 +0200
References: <200807171237.38433.laurent.pinchart@skynet.be>
In-Reply-To: <200807171237.38433.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171303.33026.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] uvcvideo: Return sensible min and max values when
	querying a boolean control.
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

On Thursday 17 July 2008 12:37:37 Laurent Pinchart wrote:
> Although the V4L2 spec states that the minimum and maximum fields may
> not be valid for control types other than V4L2_CTRL_TYPE_INTEGER, it
> makes sense to set the bounds to 0 and 1 for boolean controls instead
> of returning uninitialized values.

Hi Laurent,

Are you aware of the control support functions in v4l2-common.c? In my 
opinion it would be a good idea if you would try to use those. In 
particular adding the control definitions for the standard camera 
controls to v4l2-common.c so that every driver that uses those will get 
the same control strings and data.

I also do not see any support for the V4L2_CID_CAMERA_CLASS control: it 
should return a description of the camera control class. It is used in 
e.g. v4l2-ctl --list-ctrls:

User Controls

                     brightness (int)  : min=0 max=255 step=1... 

where the string "User Controls" comes from the V4L2_CID_USER_CLASS.

I want to prevent having different driver present different control 
query results to the user, even though it's the same control.

Testing with v4l2-ctl is a good way to verify that it is all working as 
it should. Also qv4l2 is a useful tool to see if the controls use the 
correct GUI elements. Note that this currently only builds for qt3. 
Mauro made a patch to allow it to build for qt4, but I haven't gotten 
around to testing that (sorry Mauro).

Regards,

	Hans

>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c
> index f0ee46d..0a446f0 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -592,6 +592,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device
> *video, if (ctrl == NULL)
>  		return -EINVAL;
>
> +	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
>  	v4l2_ctrl->id = mapping->id;
>  	v4l2_ctrl->type = mapping->v4l2_type;
>  	strncpy(v4l2_ctrl->name, mapping->name, sizeof v4l2_ctrl->name);
> @@ -608,7 +609,8 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device
> *video, v4l2_ctrl->default_value = uvc_get_le_value(data, mapping); }
>
> -	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
> +	switch (mapping->v4l2_type) {
> +	case V4L2_CTRL_TYPE_MENU:
>  		v4l2_ctrl->minimum = 0;
>  		v4l2_ctrl->maximum = mapping->menu_count - 1;
>  		v4l2_ctrl->step = 1;
> @@ -622,6 +624,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device
> *video, }
>
>  		return 0;
> +
> +	case V4L2_CTRL_TYPE_BOOLEAN:
> +		v4l2_ctrl->minimum = 0;
> +		v4l2_ctrl->maximum = 1;
> +		v4l2_ctrl->step = 1;
> +		return 0;
> +
> +	default:
> +		break;
>  	}
>
>  	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
