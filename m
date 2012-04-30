Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4033 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2D3Gay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 02:30:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL for v3.5] Control events support for uvcvideo
Date: Mon, 30 Apr 2012 08:30:39 +0200
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <3052114.LipUdaOlsN@avalon>
In-Reply-To: <3052114.LipUdaOlsN@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204300830.39501.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I know I am very late with this, but I looked through the event/control core
changes and I found a locking bug there. I didn't have a chance to review the
patch series when HdG posted it earlier this month, so my apologies for coming
up with this only now.

The problem is in v4l2-ctrls.c:

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 7023e6d..2a44355 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2381,10 +2381,22 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
-void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
-                               struct v4l2_subscribed_event *sev)
+static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev)
 {
-       v4l2_ctrl_lock(ctrl);

This lock...

+       struct v4l2_ctrl_handler *hdl = sev->fh->ctrl_handler;
+       struct v4l2_ctrl_ref *ref;
+       struct v4l2_ctrl *ctrl;
+       int ret = 0;
+
+       mutex_lock(&hdl->lock);

...and this lock are not necessarily the same. If the control was from a
subdevice then they will be different. This doesn't happen in uvc, but it
will in other drivers.

+
+       ref = find_ref(hdl, sev->id);

The right approach is to use v4l2_ctrl_find here and then call
v4l2_ctrl_lock(ctrl), just as was done in the original code.

+       if (!ref) {
+               ret = -EINVAL;
+               goto leave;
+       }
+       ctrl = ref->ctrl;
+
        list_add_tail(&sev->node, &ctrl->ev_subs);
        if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
            (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
@@ -2396,18 +2408,42 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
                fill_event(&ev, ctrl, changes);
                v4l2_event_queue_fh(sev->fh, &ev);
        }
-       v4l2_ctrl_unlock(ctrl);
+leave:
+       mutex_unlock(&hdl->lock);
+       return ret;
 }
-EXPORT_SYMBOL(v4l2_ctrl_add_event);
 
-void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
-                               struct v4l2_subscribed_event *sev)
+static void v4l2_ctrl_del_event(struct v4l2_subscribed_event *sev)
 {
-       v4l2_ctrl_lock(ctrl);
+       struct v4l2_ctrl_handler *hdl = sev->fh->ctrl_handler;
+
+       mutex_lock(&hdl->lock);

Same problem here.

        list_del(&sev->node);
-       v4l2_ctrl_unlock(ctrl);
+       mutex_unlock(&hdl->lock);
 }
-EXPORT_SYMBOL(v4l2_ctrl_del_event);

So the code should be:

static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev)
{
		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);

		if (ctrl == NULL)
				return -EINVAL;
        v4l2_ctrl_lock(ctrl);
        list_add_tail(&sev->node, &ctrl->ev_subs);
        if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
            (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
                struct v4l2_event ev;
                u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;

                if (!(ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY))
                        changes |= V4L2_EVENT_CTRL_CH_VALUE;
                fill_event(&ev, ctrl, changes);
                v4l2_event_queue_fh(sev->fh, &ev);
        }
        v4l2_ctrl_unlock(ctrl);
		return 0;
}

and:

static void v4l2_ctrl_del_event(struct v4l2_subscribed_event *sev)
{
		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);

        v4l2_ctrl_lock(ctrl);
        list_del(&sev->node);
        v4l2_ctrl_unlock(ctrl);
}

Regards,

	Hans

On Sunday, April 29, 2012 19:59:01 Laurent Pinchart wrote:
> Hi Mauro,
> 
> The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:
> 
>   [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-events
> 
> Hans de Goede (10):
>       media/radio: use v4l2_ctrl_subscribe_event where possible
>       v4l2-event: Add v4l2_subscribed_event_ops
>       v4l2-ctrls: Use v4l2_subscribed_event_ops
>       uvcvideo: Fix a "ignoring return value of ‘__clear_user’" warning
>       uvcvideo: Refactor uvc_ctrl_get and query
>       uvcvideo: Move __uvc_ctrl_get() up
>       uvcvideo: Add support for control events
>       uvcvideo: Properly report the inactive flag for inactive controls
>       uvcvideo: Send control change events for slave ctrls when the master changes
>       uvcvideo: Drop unused ctrl member from struct uvc_control_mapping
> 
>  Documentation/video4linux/v4l2-framework.txt |   28 ++-
>  drivers/media/radio/radio-isa.c              |   10 +-
>  drivers/media/radio/radio-keene.c            |   14 +-
>  drivers/media/video/ivtv/ivtv-ioctl.c        |    3 +-
>  drivers/media/video/omap3isp/ispccdc.c       |    2 +-
>  drivers/media/video/omap3isp/ispstat.c       |    2 +-
>  drivers/media/video/uvc/uvc_ctrl.c           |  320 +++++++++++++++++++++----
>  drivers/media/video/uvc/uvc_v4l2.c           |   46 +++-
>  drivers/media/video/uvc/uvcvideo.h           |   26 ++-
>  drivers/media/video/v4l2-ctrls.c             |   58 ++++-
>  drivers/media/video/v4l2-event.c             |   71 +++---
>  drivers/usb/gadget/uvc_v4l2.c                |    2 +-
>  include/media/v4l2-ctrls.h                   |    7 +-
>  include/media/v4l2-event.h                   |   24 ++-
>  14 files changed, 456 insertions(+), 157 deletions(-)
> 
> 
