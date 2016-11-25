Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:47036 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754448AbcKYMpD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 07:45:03 -0500
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] HSV fixes for 4.10
Message-ID: <2ac9c2aa-f418-c15f-900c-09763c3654f9@xs4all.nl>
Date: Fri, 25 Nov 2016 13:44:57 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two fixes to make vivid work correctly with HSV.

Regards,

	Hans

The following changes since commit d3d83ee20afda16ad0133ba00f63c11a8d842a35:

  [media] DaVinci-VPFE-Capture: fix error handling (2016-11-25 07:57:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git hsv

for you to fetch changes up to d59b74b430d90fc1421c74e225ab76d80568124e:

  vivid: Set color_enc on HSV formats (2016-11-25 13:15:59 +0100)

----------------------------------------------------------------
Ricardo Ribalda Delgado (2):
      v4l2-tpg: Init hv_enc field with a valid value
      vivid: Set color_enc on HSV formats

 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 1 +
 drivers/media/platform/vivid/vivid-vid-common.c | 2 ++
 2 files changed, 3 insertions(+)
