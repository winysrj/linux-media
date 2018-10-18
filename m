Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55288 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbeJSAK3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 20:10:29 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/2] vicodec: a couple fixes towards spec compliancy
Date: Thu, 18 Oct 2018 13:08:39 -0300
Message-Id: <20181018160841.17674-1-ezequiel@collabora.com>
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

Ezequiel Garcia (2):
  vicodec: Have decoder propagate changes to the CAPTURE queue
  vicodec: Implement spec-compliant stop command

 drivers/media/platform/vicodec/vicodec-core.c | 95 ++++++++++++-------
 1 file changed, 59 insertions(+), 36 deletions(-)

-- 
2.19.1
