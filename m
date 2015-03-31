Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34027 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbbCaQPj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 12:15:39 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Dan Williams <dan.j.williams@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Julius Werner <jwerner@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pratyush Anand <pratyush.anand@st.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Scot Doyle <lkml14@scotdoyle.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 0/6] Allow UVC devices to remain runtime-suspended when sleeping
Date: Tue, 31 Mar 2015 18:14:44 +0200
Message-Id: <1427818501-10201-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this series contain what I needed to do in order to have my USB webcam to not be resumed when the system resumes, reducing considerably the total time that resuming takes.

It makes use of the facility that Rafael Wysocki added in aae4518b3 ("PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily"), which requires that a devices and all its descendants opt-in by having their dev_pm_ops.prepare callback return 1, to have runtime PM enabled, and to be runtime suspended when the system goes to a sleep state.

Thanks,

Tomeu

Tomeu Vizoso (6):
  [media] uvcvideo: Enable runtime PM of descendant devices
  [media] v4l2-core: Implement dev_pm_ops.prepare()
  Input: Implement dev_pm_ops.prepare()
  [media] media-devnode: Implement dev_pm_ops.prepare callback
  Input: evdev - Enable runtime PM of the evdev input handler
  USB / PM: Allow USB devices to remain runtime-suspended when sleeping

 drivers/input/evdev.c              |  3 +++
 drivers/input/input.c              | 13 +++++++++++++
 drivers/media/media-devnode.c      | 10 ++++++++++
 drivers/media/usb/uvc/uvc_driver.c |  4 ++++
 drivers/media/usb/uvc/uvc_status.c |  3 +++
 drivers/media/v4l2-core/v4l2-dev.c | 10 ++++++++++
 drivers/usb/core/endpoint.c        | 17 +++++++++++++++++
 drivers/usb/core/message.c         | 16 ++++++++++++++++
 drivers/usb/core/port.c            |  6 ++++++
 drivers/usb/core/usb.c             |  2 +-
 10 files changed, 83 insertions(+), 1 deletion(-)

-- 
2.3.4

