Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36158 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753089AbdHRNjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 09:39:05 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] vsp1: partition algorithm improvements
Message-ID: <07633676-7473-fe6d-64e3-52b60e5be883@xs4all.nl>
Date: Fri, 18 Aug 2017 15:39:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note from Laurent: the series merges cleanly with Dave's drm-next branch
(git://people.freedesktop.org/~airlied/linux) that contains a large series of
VSP patches. There should thus be no merge conflict (at least none that git
won't solve automatically) when merging upstream.

Regards,

	Hans

The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vsp1

for you to fetch changes up to 8ced9b7523eb503a3271bbfbc41451455fea7d0c:

  v4l: vsp1: Allow entities to participate in the partition algorithm (2017-08-18 15:05:26 +0200)

----------------------------------------------------------------
Kieran Bingham (7):
      v4l: vsp1: Release buffers in start_streaming error path
      v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
      v4l: vsp1: Calculate partition sizes at stream start
      v4l: vsp1: Remove redundant context variables
      v4l: vsp1: Move partition rectangles to struct and operate directly
      v4l: vsp1: Provide UDS register updates
      v4l: vsp1: Allow entities to participate in the partition algorithm

 drivers/media/platform/vsp1/vsp1_entity.h |   7 +++
 drivers/media/platform/vsp1/vsp1_pipe.c   |  22 ++++++++
 drivers/media/platform/vsp1/vsp1_pipe.h   |  46 +++++++++++++++--
 drivers/media/platform/vsp1/vsp1_regs.h   |  14 ++++++
 drivers/media/platform/vsp1/vsp1_rpf.c    |  27 +++++-----
 drivers/media/platform/vsp1/vsp1_sru.c    |  26 ++++++++++
 drivers/media/platform/vsp1/vsp1_uds.c    |  57 ++++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_video.c  | 182 +++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/media/platform/vsp1/vsp1_wpf.c    |  24 ++++++---
 9 files changed, 289 insertions(+), 116 deletions(-)
