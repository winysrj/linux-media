Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2461CC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 17:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E29C12086C
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550856551;
	bh=yFm/pd2luKILO2zqvPTWVwKlBZ0DduSJc4p/5VnnLAw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=et4zU2nmKCmro9MOn34FNnDREhtsWCIaJADekK2vp787z1lCBQ8N1nLBRF0uGTe9w
	 YbKPgK05DnQhKKq+1H2Bn3o3gey5WFkbJDsqhiuvZUFHPp2g0DHN/+IzGKf8e+rFFN
	 vldSQk3gB5Y9zWQWNeu+VQy1iWsHqFxtzEERWo9M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfBVR3K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfBVR3K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 12:29:10 -0500
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4690A2075C;
        Fri, 22 Feb 2019 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550856548;
        bh=yFm/pd2luKILO2zqvPTWVwKlBZ0DduSJc4p/5VnnLAw=;
        h=From:To:Cc:Subject:Date:From;
        b=Nhh4vnud4hQ0CyQYzo0TFaB0wolJIpseSYuWc4FYqqz+a1XzePRQo7QG+bulpsJeq
         zhe0MhE0TwbZmPu2nI4KlffoOP+nzCgTgzbXXw/JlAfoyFqrUBlA/eJwil1uoUhJBe
         o6jSm2/u9NqlKbzL7gqPf0V1qRTaUb+bCYHXw/Sc=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v11 0/5] Media Device Allocator API
Date:   Fri, 22 Feb 2019 10:28:58 -0700
Message-Id: <cover.1550804023.git.shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Media Device Allocator API to allows multiple drivers share a media device.
This API solves a very common use-case for media devices where one physical
device (an USB stick) provides both audio and video. When such media device
exposes a standard USB Audio class, a proprietary Video class, two or more
independent drivers will share a single physical USB bridge. In such cases,
it is necessary to coordinate access to the shared resource.

Using this API, drivers can allocate a media device with the shared struct
device as the key. Once the media device is allocated by a driver, other
drivers can get a reference to it. The media device is released when all
the references are released.

- This patch series in rested on 5.0-rc7 and addresses comments on
  v10 series from Hans Verkuil. Fixed problems found in resource
  sharing logic in au0828 adding a patch 5 to this series.
- I am sharing the test plan used for testing resource sharing which
  could serve as a regression test plan. Test results can be found at:

https://docs.google.com/document/d/1XMs3HYgLiHby6xVIvIxv75KSXAAN3F4uUpw2uLuD9c4/edit?usp=sharing

- v10 was tested on 5.0-rc3 and addresses comments on v9 series from
  Hans Verkuil.
- v9 was tested on 4.20-rc6.
- Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
  arecord. When analog is streaming, digital and audio user-space
  applications detect that the tuner is busy and exit. When digital
  is streaming, analog and audio applications detect that the tuner is
  busy and exit. When arecord is owns the tuner, digital and analog
  detect that the tuner is busy and exit.
- Tested media device allocator API with bind/unbind testing on
  snd-usb-audio and au0828 drivers to make sure /dev/mediaX is released
  only when the last driver is unbound.
- Addressed review comments from Hans on the RFC v8 (rebased on 4.19)
- Updated change log to describe the use-case more clearly.
- No changes to 0001,0002 code since the v7 referenced below.
- 0003 is a new patch to enable ALSA defines that have been
  disabled for kernel between 4.9 and 4.19.
- Minor merge conflict resolution in 0004.
- Added SPDX to new files.

Changes since v10:
- Patch 1: Fixed SPDX tag and removed redundant IS_ENABLED(CONFIG_USB)
           around media_device_usb_allocate() - Sakari Ailus's review
           comment.
- Patch 2 and 3: No changes
- Patch 4: Fixed SPDX tag - Sakari Ailus's review comment.
- Carried Reviewed-by tag from Takashi Iwai for the sound from v9.
- Patch 5: This is a new patch added to fix resource sharing
	   inconsistencies and problem found during testing using Han's
	   tests.
Changes since v9:
- Patch 1: Fix mutex assert warning from find_module() calls. This
  code was written before the change to find_module() that requires
  callers to hold module_mutex. I missed this during my testing on
  4.20-rc6. Hans Verkuil reported the problem.
- Patch 4: sound/usb: Initializes all the entities it can before
  registering the device based on comments from Hans Verkuil
- Carried Reviewed-by tag from Takashi Iwai for the sound from v9.
- No changes to Patches 2 and 3.

References:
https://lkml.org/lkml/2018/11/2/169
https://www.mail-archive.com/linux-media@vger.kernel.org/msg105854.html

Shuah Khan (5):
  media: Media Device Allocator API
  media: change au0828 to use Media Device Allocator API
  media: media.h: Enable ALSA MEDIA_INTF_T* interface types
  sound/usb: Use Media Controller API to share media resources
  au0828: fix enable and disable source audio and video inconsistencies

 Documentation/media/kapi/mc-core.rst   |  41 ++++
 drivers/media/Makefile                 |   4 +
 drivers/media/media-dev-allocator.c    | 142 +++++++++++
 drivers/media/usb/au0828/au0828-core.c | 190 ++++++++++----
 drivers/media/usb/au0828/au0828.h      |   6 +-
 include/media/media-dev-allocator.h    |  53 ++++
 include/uapi/linux/media.h             |  25 +-
 sound/usb/Kconfig                      |   4 +
 sound/usb/Makefile                     |   2 +
 sound/usb/card.c                       |  14 ++
 sound/usb/card.h                       |   3 +
 sound/usb/media.c                      | 327 +++++++++++++++++++++++++
 sound/usb/media.h                      |  74 ++++++
 sound/usb/mixer.h                      |   3 +
 sound/usb/pcm.c                        |  29 ++-
 sound/usb/quirks-table.h               |   1 +
 sound/usb/stream.c                     |   2 +
 sound/usb/usbaudio.h                   |   6 +
 18 files changed, 865 insertions(+), 61 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.17.1

