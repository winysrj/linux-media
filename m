Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:56410 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2INLPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 07:15:43 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id q8EBFghM000742
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 11:15:42 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 API PATCH 1/4] Two fixes and two v4l2-ctrl enhancements
Date: Fri, 14 Sep 2012 13:15:32 +0200
Message-Id: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The first and last patches are bug fixes, and the second and third add
two new features to the control framework:

The first new feature adds a notifier to a control. When set the notifier
will be called whenever the control changes value. This feature is needed
to allow bridge drivers to detect changes in controls of a subdevice,
even if those controls are private to the subdevice. It does for kernel
drivers what the V4L2 event API does for userspace.

This functionality is initially required for the em28xx conversion to
the control framework, but it is also required for drivers that have to
deal with e.g. HDMI connectors with all the hotplug etc. events.

The second feature adds a filter function to the v4l2_ctrl_add_handler
function that allows you to select more precisely which controls you
want to add.

The primary purpose is to add only the audio controls to a control handler
for a radio device. Currently you will also see the video controls when
listing controls from the radio device of a combine tv/radio card and with
this filter function it is easy to fix that.

Comments are welcome!

Regards,

	Hans

