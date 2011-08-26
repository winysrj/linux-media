Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4515 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1HZMAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [RFCv2 PATCH 0/8] Add V4L2_CTRL_FLAG_VOLATILE and change volatile autocluster handling.
Date: Fri, 26 Aug 2011 14:00:05 +0200
Message-Id: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second patch for this. The first is here:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/36650

This second version changes the pwc code as suggested by Hans de Goede and it
adds documentation. The v4l2-ctrls.c code has also been improved to avoid
unnecessary calls to update_from_auto_cluster(). Thanks to Hans de Goede for
pointing me in the right direction.

If there are no additional comments, then I will make a pull request early next
week.

This will also be the basis for converting soc-camera to the control framework.

Regards,

	Hans

