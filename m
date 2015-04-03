Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36310 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbbDCM60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 08:58:26 -0400
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
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH v2 0/7] Allow UVC devices to remain runtime-suspended when sleeping
Date: Fri,  3 Apr 2015 14:57:49 +0200
Message-Id: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2:	* Let creators of the input device to decide whether it should remain
	runtime suspended when the system goes into a sleep state
	* Don't enable PM runtime on all evdev handlers
	* Cope with another wrong wakeup setting in usb_dev_prepare

Hi,

this series contain what I needed to do in order to have my USB webcam to not
be resumed when the system resumes, reducing considerably the total time that
resuming takes.

It makes use of the facility that Rafael Wysocki added in aae4518b3 ("PM /
sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily"),
which requires that a device and all its descendants opt-in by having their
dev_pm_ops.prepare callback return 1, to have runtime PM enabled, and to be
runtime suspended when the system goes to a sleep state.

Thanks,

Tomeu

Tomeu Vizoso (7):
  Input: Implement dev_pm_ops.prepare in input_class
  Input: Add input_dev.stay_runtime_suspended flag
  [media] uvcvideo: Set input_dev.stay_runtime_suspended flag
  [media] uvcvideo: Enable runtime PM of descendant devices
  [media] v4l2-core: Implement dev_pm_ops.prepare()
  [media] media-devnode: Implement dev_pm_ops.prepare callback
  USB / PM: Allow USB devices to remain runtime-suspended when sleeping

 drivers/input/input.c              | 20 ++++++++++++++++++++
 drivers/media/media-devnode.c      | 10 ++++++++++
 drivers/media/usb/uvc/uvc_driver.c | 11 +++++++++++
 drivers/media/usb/uvc/uvc_status.c |  1 +
 drivers/media/v4l2-core/v4l2-dev.c | 10 ++++++++++
 drivers/usb/core/endpoint.c        | 17 +++++++++++++++++
 drivers/usb/core/message.c         | 16 ++++++++++++++++
 drivers/usb/core/port.c            |  6 ++++++
 drivers/usb/core/usb.c             |  8 +++++++-
 include/linux/input.h              |  4 ++++
 10 files changed, 102 insertions(+), 1 deletion(-)

-- 
2.3.4

