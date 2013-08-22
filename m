Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1479 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3HVKOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:14:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com
Subject: [RFCv3 PATCH 00/10] Matrix and Motion Detection support
Date: Thu, 22 Aug 2013 12:14:14 +0200
Message-Id: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This third patch series adds support for matrices and motion detection and
converts the solo6x10 and go7007 driver to use these new APIs.

See this RFCv2 for details on the motion detection API:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html

And this RFC for details on the matrix API (which superseeds the v4l2_md_blocks
in the RFC above):

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/65195

I have tested this with the solo and go7007 boards, both global motion detection
and regional motion detection, and it works well. Although note the commit
message for patch 10 regarding some uncertainties regarding regional MD in
the go7007 driver.

Changes since the second RFC patch series:

- Removed the ref field as per Sakari's comment. The reserved fields must now
  be cleared by the application as well, otherwise we wouldn't be able to add
  a ref field later.
- Cleaned up the compat-ioctl32 code as suggested by Laurent.
- Improved the matrix documentation. The documentation on the region matrix
  type in particular was rather obscure as Laurent pointed out.

Changes since the first RFC patch series:

- document the new APIs
- implemented motion detection in the go7007 driver

I have adapted v4l2-ctl to support the new APIs:

http://git.linuxtv.org/hverkuil/v4l-utils.git/shortlog/refs/heads/matrix

If there are no more comments regarding this patch series, then I'll make
a pull request for this.

Once this is in, I can move the solo and go7007 drivers into the mainline
kernel, since the missing motion detection API is the only bit keeping
them in staging.

Regards,

	Hans

