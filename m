Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60839 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759135AbcIPK5S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:57:18 -0400
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id DF70A18021F
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 12:57:11 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/8] dv-timings: add VICs and picture aspect ratio
Date: Fri, 16 Sep 2016 12:57:03 +0200
Message-Id: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_bt_timings struct is missing information about the picture aspect
ratio and the CEA-861 and HDMI VIC (Video Identification Code).

This patch series adds support for this.

Changes since v1:

- Split the first patch into a cleanup patch and a patch adding the
  actual new flags.
- Document the new flags.
- Add the v4l2_dv_timings_cea861_aspect_ratio function (this patch is
  not yet intended for upstreaming since no driver calls it).

Regards,

	Hans

Hans Verkuil (8):
  videodev2.h: checkpatch cleanup
  videodev2.h: add VICs and picture aspect ratio
  vidioc-g-dv-timings.rst: document the new dv_timings flags
  v4l2-dv-timings: add VICs and picture aspect ratio
  v4l2-dv-timings: add helpers to find vic and pixelaspect ratio
  cobalt: add cropcap support
  adv7604: add vic detect
  v4l2-dv-timings: add v4l2_dv_timings_cea861_aspect_ratio

 .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 23 +++++
 Documentation/media/videodev2.h.rst.exceptions     |  3 +
 drivers/media/i2c/adv7604.c                        | 18 +++-
 drivers/media/pci/cobalt/cobalt-v4l2.c             | 21 +++++
 drivers/media/v4l2-core/Kconfig                    |  1 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          | 76 ++++++++++++++++-
 include/media/v4l2-dv-timings.h                    | 26 ++++++
 include/uapi/linux/v4l2-dv-timings.h               | 97 ++++++++++++++--------
 include/uapi/linux/videodev2.h                     | 75 ++++++++++++-----
 9 files changed, 281 insertions(+), 59 deletions(-)

-- 
2.8.1

