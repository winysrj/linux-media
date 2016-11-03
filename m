Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58373 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756281AbcKCO5R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 10:57:17 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] Add pixelaspect and VIC codes to the DV timings
 struct.
Message-ID: <9955e4f5-b612-7596-7cd3-edf97c4d1909@xs4all.nl>
Date: Thu, 3 Nov 2016 15:57:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a rebased version of this v2 patch series:

http://www.spinics.net/lists/linux-media/msg105729.html

Minus the last patch (8/8) since nobody is using that function yet.

Regards,

	Hans

The following changes since commit bd676c0c04ec94bd830b9192e2c33f2c4532278d:

   [media] v4l2-flash-led-class: remove a now unused var (2016-10-24 
18:51:29 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.10b

for you to fetch changes up to 27529c670742336a118c40859713dc775cced1d7:

   adv7604: add vic detect (2016-11-03 15:43:10 +0100)

----------------------------------------------------------------
Hans Verkuil (7):
       videodev2.h: checkpatch cleanup
       videodev2.h: add VICs and picture aspect ratio
       vidioc-g-dv-timings.rst: document the new dv_timings flags
       v4l2-dv-timings: add VICs and picture aspect ratio
       v4l2-dv-timings: add helpers to find vic and pixelaspect ratio
       cobalt: add cropcap support
       adv7604: add vic detect

  Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst | 11 ++++++
  Documentation/media/videodev2.h.rst.exceptions       |  3 ++
  drivers/media/i2c/adv7604.c                          | 18 ++++++++--
  drivers/media/pci/cobalt/cobalt-v4l2.c               | 21 +++++++++++
  drivers/media/v4l2-core/Kconfig                      |  1 +
  drivers/media/v4l2-core/v4l2-dv-timings.c            | 58 
++++++++++++++++++++++++++++--
  include/media/v4l2-dv-timings.h                      | 18 ++++++++++
  include/uapi/linux/v4l2-dv-timings.h                 | 97 
+++++++++++++++++++++++++++++++++------------------
  include/uapi/linux/videodev2.h                       | 77 
++++++++++++++++++++++++++++------------
  9 files changed, 244 insertions(+), 60 deletions(-)
