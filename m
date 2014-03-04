Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4049 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaCDKnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 05:43:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Subject: [REVIEWv4 PATCH 00/18] vb2: fixes, balancing callbacks (PART 1)
Date: Tue,  4 Mar 2014 11:42:08 +0100
Message-Id: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fourth version, hopefully the last as well.

Changes since REVIEWv3:

- Split off the pwc patch into the buf_finish return type change and
  the patch that only decompresses the image if the buffer state is
  DONE.

- Extend the comments in patch 07/18: explain that the buf_finish call in
  queue_cancel shouldn't be moved to __vb2_dqbuf, or we'll get the same
  bug that I introduced in an earlier version of this patch series.

The actual code has been unchanged since v3.

If there are no more comments, then I'll plan on making a pull request on
Friday.

Regards,

	Hans

