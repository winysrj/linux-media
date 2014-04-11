Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4033 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDKIMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com
Subject: [REVIEWv3 PATCH 00/13] vb2: various small fixes/improvements
Date: Fri, 11 Apr 2014 10:11:06 +0200
Message-Id: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the third version of this review patch series.
The previous can be found here:

http://www.spinics.net/lists/linux-media/msg75428.html

Changes since v2:

- Updated v4l2-pci-skeleton.c as well in patch 01/13
- Dropped patch 10/13 as it is not needed
- Added comment to patch 06/13 as suggested by Pawel
- Added patch 13/13: fix HDTV interlaced handling in v4l2-pci-skeleton.c

If there are no more comments, then I plan on posting a pull request
on Monday.

Regards,

	Hans

