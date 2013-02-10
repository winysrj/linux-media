Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3269 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3BJRxA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [RFCv2 PATCH 00/12] stk-webcam: v4l2-compliance fixes
Date: Sun, 10 Feb 2013 18:52:41 +0100
Message-Id: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This second patch series updates this driver to the control framework,
switches it to unlocked_ioctl and fixes a variety of V4L2 compliance issues.

This patch series has been tested by Arvydas Sidorenko. Thank you!

I also like to thank Jose Gómez who also did some testing for me.

Changes in this second patch series:

- The first patch is new and fixes a bug introduced by commit
  7a29ee2e37b3f9675f46c87998c67b68c315c54a ("stk-webcam: Add an upside down
  dmi table, and add the Asus G1 to it").
- Patches 10-12 are also new and fix some more bugs found when running
  the compliance tests.

If there are no more comments then I intend to post the pull request on Friday.

Regards,

        Hans

