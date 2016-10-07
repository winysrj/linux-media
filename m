Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:23115 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938891AbcJGQ70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:59:26 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1] Enhance MPEG2 video decoder frame API
Date: Fri, 7 Oct 2016 18:59:04 +0200
Message-ID: <1475859545-654-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset refine the original MPEG2 controls introduced by
Florent Revest in [1] by adding support of various MPEG2 extensions,
including frame & field interlaced bistream.
This is a work in progress in order to start discussion around
V4L2 frame API standardisation.

[1] http://www.spinics.net/lists/linux-media/msg104824.html

Hugues Fruchet (1):
  [media] v4l2-ctrls: add mpeg2 parser metadata

 drivers/media/v4l2-core/v4l2-ctrls.c |   2 +-
 include/uapi/linux/v4l2-controls.h   | 163 +++++++++++++++++++++++++++++------
 2 files changed, 140 insertions(+), 25 deletions(-)

-- 
1.9.1

