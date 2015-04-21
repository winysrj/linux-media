Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34896 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbbDUM70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 08:59:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de
Subject: [RFCv2 PATCH 00/15] Request API
Date: Tue, 21 Apr 2015 14:58:43 +0200
Message-Id: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the request API (formerly called the
configuration store API: http://www.spinics.net/lists/linux-media/msg81024.html).

This second version takes into account all the feedback I received from
various people and from the discussions in Düsseldorf last year.

Utilities that understand requests are available here:

http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=requests

The git repo with these patches is here:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=requests

Note: this will be rebased to the latest media_tree master on a regular
basis.

The last patch adds a document going into more detail of how everything
works, so refer to that patch to get a good overview of this functionality.

The patch adding request support to vivid is also useful to look at.

DocBook patches are missing since I am waiting for a driver that will
actually need this. If anyone is working on such a driver, then please
let me know.

If anyone has questions, or if anyone has ideas or thinks additional support
for some functionality is needed in the core, then let me know as well.

Regards,

	Hans

Hans Verkuil (15):
  videodev2.h: add max_reqs to struct v4l2_query_ext_ctrl
  videodev2.h: add request to v4l2_ext_controls
  videodev2.h: add request field to v4l2_buffer.
  vb2: add allow_requests flag
  v4l2-ctrls: add request support
  v4l2-ctrls: add function to apply a request.
  v4l2-ctrls: implement delete request(s)
  v4l2-ctrls: add VIDIOC_REQUEST_CMD
  v4l2: add initial V4L2_REQ_CMD_QUEUE support
  vb2: add helper function to queue request-specific buffer.
  v4l2-device: keep track of registered video_devices
  v4l2-device: add v4l2_device_req_queue
  vivid: add request support for video capture.
  v4l2-ctrls: add REQ_KEEP flag
  Documentation: add v4l2-requests.txt

 Documentation/video4linux/v4l2-requests.txt      | 233 ++++++++++++
 drivers/media/platform/vivid/vivid-core.c        |   2 +
 drivers/media/platform/vivid/vivid-ctrls.c       |   4 +
 drivers/media/platform/vivid/vivid-kthread-cap.c |   2 +
 drivers/media/usb/cpia2/cpia2_v4l.c              |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c             | 440 ++++++++++++++++++++---
 drivers/media/v4l2-core/v4l2-dev.c               |   9 +
 drivers/media/v4l2-core/v4l2-device.c            |  26 ++
 drivers/media/v4l2-core/v4l2-ioctl.c             | 123 ++++++-
 drivers/media/v4l2-core/v4l2-subdev.c            |  78 +++-
 drivers/media/v4l2-core/videobuf2-core.c         |  26 ++
 include/media/v4l2-ctrls.h                       |  35 +-
 include/media/v4l2-dev.h                         |   3 +
 include/media/v4l2-device.h                      |   7 +
 include/media/v4l2-fh.h                          |   4 +
 include/media/videobuf2-core.h                   |   3 +
 include/uapi/linux/videodev2.h                   |  38 +-
 18 files changed, 957 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/video4linux/v4l2-requests.txt

-- 
2.1.4

