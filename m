Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37648 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbDQPZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 11:25:48 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH v3 0/2] Allow UVC devices to remain runtime-suspended when sleeping
Date: Fri, 17 Apr 2015 17:24:48 +0200
Message-Id: <1429284290-25153-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v3:	* Add a new power.force_direct_complete to let devices express that it's
	safe to let them be runtime-suspended at system sleep regardless of the state
	of their descendants

v2:	* Let creators of the input device to decide whether it should remain
	runtime suspended when the system goes into a sleep state
	* Don't enable PM runtime on all evdev handlers
	* Cope with another wrong wakeup setting in usb_dev_prepare

Hi,

this series contain what I needed to do in order to have my USB webcam to not
be resumed when the system resumes, reducing considerably the total time that
resuming takes.

It makes use of the facility that Rafael Wysocki added in aae4518b3 ("PM /
sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily").

Thanks,

Tomeu

Tomeu Vizoso (2):
  PM / sleep: Let devices force direct_complete
  [media] uvcvideo: Remain runtime-suspended at sleeps

 drivers/base/power/main.c          | 13 +++++++++----
 drivers/media/usb/uvc/uvc_driver.c |  2 ++
 include/linux/pm.h                 |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.3.5

