Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54951 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750811AbdFSNtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 09:49:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: [PATCH 0/2] Fix G/S_SELECTION & CROPCAP/G/S_CROP buftype handling
Date: Mon, 19 Jun 2017 15:49:08 +0200
Message-Id: <20170619134910.10138-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is a lot of confusion about the correct buffer type to use
when calling the new selection and old crop APIs. Specifically whether
the _MPLANE variant of a buf type should be used or not if the device
is multi-planar. The spec said na, but that was unexpected to applications
and drivers actually did different things as well.

This patch series allows both to be used and updates the documentation
accordingly.

In the end, these APIs don't care whether it is a single or multiplanar
device, that information is irrelevant to these ioctls. So allowing
both is not unreasonable, especially given the mess we created.

The first patch is unchanged from the original RFC here:

https://patchwork.linuxtv.org/patch/41210/

The second patch was updated from this original RFC:

- the note was moved after the struct containing the 'type' field.
- kernel 4.12 was replaced with 4.14 (I'm assuming this will be too
  late for 4.13).
- The phrase 'The Samsung Exynos drivers' was replaced by 'Some drivers'.

Regards,

	Hans

Hans Verkuil (2):
  v4l2-ioctl/exynos: fix G/S_SELECTION's type handling
  media/uapi/v4l: clarify cropcap/crop/selection behavior

 Documentation/media/uapi/v4l/vidioc-cropcap.rst    | 23 ++++++----
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     | 22 +++++----
 .../media/uapi/v4l/vidioc-g-selection.rst          | 22 +++++----
 drivers/media/platform/exynos-gsc/gsc-core.c       |  4 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  8 ++--
 drivers/media/platform/exynos4-is/fimc-capture.c   |  4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               | 53 +++++++++++++++++++---
 8 files changed, 95 insertions(+), 45 deletions(-)

-- 
2.11.0
