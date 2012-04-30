Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38668 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab2D3KQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 06:16:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [GIT PULL for v3.5] (v3) Control events support for uvcvideo
Date: Mon, 30 Apr 2012 12:17:03 +0200
Message-ID: <5140337.GoVX3LbcVr@avalon>
In-Reply-To: <201204301149.54269.hverkuil@xs4all.nl>
References: <3052114.LipUdaOlsN@avalon> <2717715.JRhGBvOjaF@avalon> <201204301149.54269.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 30 April 2012 11:49:54 Hans Verkuil wrote:
> On Monday 30 April 2012 11:43:10 Laurent Pinchart wrote:
> > Hi Mauro,
> > 
> > A locking bug was present in the previous pull request. Please ignore it
> > and pull this one instead.
> 
> I hate to say it, but while you did update v4l2_ctrl_add_event, you forgot
> to update v4l2_ctrl_del_event as well. That one still has the same locking
> issue...

If it wasn't noon already I'd blame it on not having woken up completely :-)

> Time for a v3 :-)

Here it is.

Mauro, could you please pull the following ? Sorry for the noise.

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-events

Hans de Goede (10):
      media/radio: use v4l2_ctrl_subscribe_event where possible
      v4l2-event: Add v4l2_subscribed_event_ops
      v4l2-ctrls: Use v4l2_subscribed_event_ops
      uvcvideo: Fix a "ignoring return value of ‘__clear_user’" warning
      uvcvideo: Refactor uvc_ctrl_get and query
      uvcvideo: Move __uvc_ctrl_get() up
      uvcvideo: Add support for control events
      uvcvideo: Properly report the inactive flag for inactive controls
      uvcvideo: Send control change events for slave ctrls when the master changes
      uvcvideo: Drop unused ctrl member from struct uvc_control_mapping

 Documentation/video4linux/v4l2-framework.txt |   28 ++-
 drivers/media/radio/radio-isa.c              |   10 +-
 drivers/media/radio/radio-keene.c            |   14 +-
 drivers/media/video/ivtv/ivtv-ioctl.c        |    3 +-
 drivers/media/video/omap3isp/ispccdc.c       |    2 +-
 drivers/media/video/omap3isp/ispstat.c       |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c           |  320 ++++++++++++++++++++++----
 drivers/media/video/uvc/uvc_v4l2.c           |   46 +++-
 drivers/media/video/uvc/uvcvideo.h           |   26 ++-
 drivers/media/video/v4l2-ctrls.c             |   41 +++-
 drivers/media/video/v4l2-event.c             |   71 +++---
 drivers/usb/gadget/uvc_v4l2.c                |    2 +-
 include/media/v4l2-ctrls.h                   |    7 +-
 include/media/v4l2-event.h                   |   24 ++-
 14 files changed, 443 insertions(+), 153 deletions(-)

-- 
Regards,

Laurent Pinchart

