Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35036 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbeKCBAJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:00:09 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 0/4] vicodec: a couple fixes towards spec compliancy
Date: Fri,  2 Nov 2018 12:52:02 -0300
Message-Id: <20181102155206.13681-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Given the stateful codec specification is still a moving target,
it doesn't make any sense to try to comply fully with it.

On the other side, we can still comply with some basic userspace
expectations, with just a couple small changes.

This series implements proper resolution changes propagation,
and fixes the CMD_STOP so it actually works.

The intention of this series is to be able to test this driver
using already existing userspace, gstreamer in particular.
With this changes, it's possible to construct variations of
this pipeline:

  gst-launch-1.0 videotestsrc ! v4l2fwhtenc ! v4l2fwhtdec ! fakevideosink

Also, as discussed in v1 feedback [1,2], I'm including pixel format
helpers, as RFC for now. Hans, Tomasz: is this what you had in mind?

[1] https://www.spinics.net/lists/linux-media/msg141912.html
[2] https://www.spinics.net/lists/linux-media/msg142099.html

v2:
  * Add more info to commit logs
  * Propagate changes on both encoders and decoders
  * Add pixel format helpers

Ezequiel Garcia (4):
  media: Introduce helpers to fill pixel format structs
  vicodec: Use pixel format helpers
  vicodec: Propagate changes to the CAPTURE queue
  vicodec: Implement spec-compliant stop command

 .../media/platform/vicodec/codec-v4l2-fwht.c  |  42 ++--
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   3 -
 drivers/media/platform/vicodec/vicodec-core.c | 197 +++++++++---------
 drivers/media/v4l2-core/Makefile              |   2 +-
 drivers/media/v4l2-core/v4l2-common.c         |  66 ++++++
 drivers/media/v4l2-core/v4l2-fourcc.c         |  93 +++++++++
 include/media/v4l2-common.h                   |   5 +
 include/media/v4l2-fourcc.h                   |  53 +++++
 8 files changed, 332 insertions(+), 129 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-fourcc.c
 create mode 100644 include/media/v4l2-fourcc.h

-- 
2.19.1
