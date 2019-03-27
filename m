Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A6FC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E60E92087E
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553653531;
	bh=l/JgY3CLDamLHsNGYOVCEB6W36iPZyWSB0NwehBU+/U=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Hr8n5QJF/9EpHq8kTI0A4FtylqoxMKRUBARi3smimgOsQlNRUIap2MDENmA/jO32g
	 iK5pgRfkI8WlOb4IgmRafs3SQP5LdueyF4yobZItjkEBxEezUSEtgliHwGnRcjFLOP
	 C7DQou/t3N8dAKnXOTDvD1jru/o280jA2/3c8sT0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbfC0CY4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 22:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731571AbfC0CY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 22:24:56 -0400
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8CC22082F;
        Wed, 27 Mar 2019 02:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553653495;
        bh=l/JgY3CLDamLHsNGYOVCEB6W36iPZyWSB0NwehBU+/U=;
        h=From:To:Cc:Subject:Date:From;
        b=S7s+pHl8CjJX6erB73PKDiMks5eDke0NL6n+5YCEQ/URLRYE0lyMfauXV9qZe8peH
         jDtAXxP+M9Vm5IWxeqtFtH5/oGvkdpkqCn2SUNUWbgnYH6GcK0Id9sZOszPQe460dW
         91rpwi+WnVY1Paq0pSJ5zeGu8lav5YKRhs3oAGeU=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v12 0/5] Media Device Allocator API
Date:   Tue, 26 Mar 2019 20:24:47 -0600
Message-Id: <cover.1553634246.git.shuah@kernel.org>
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

- This patch series in tested on 5.1-rc2 and addresses the compile errors,
  warns, and sparse errors reported by Hans Verkuil and Dan Carpenter.
 
Changes since v11:
- Patch 1: Add CONFIG_MODULES dependency in media_dev_allocator files.
  to fix compile errors when CONFIG_MODULES is disabled.
- Patch 2, 3: No changes.
- Patch 4: Fix sparse error reported by Dan Carpenter.
- Patch 5: Fix warns found by Hans Verkuil.

- v11 was tested on 5.0-rc7 and addresses comments on v10 series from
  Hans Verkuil. Fixed problems found in resource sharing logic in au0828
  adding a patch 5 to this series. The test plan used for testing resource
  sharing could serve as a regression test plan and the test results can be
  found at:

https://docs.google.com/document/d/1XMs3HYgLiHby6xVIvIxv75KSXAAN3F4uUpw2uLuD9c4/edit?usp=sharing

- v10 was tested on 5.0-rc3 and addresses comments on v9 series from
  Hans Verkuil.

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
 drivers/media/Makefile                 |   6 +
 drivers/media/media-dev-allocator.c    | 142 +++++++++++
 drivers/media/usb/au0828/au0828-core.c | 194 +++++++++++----
 drivers/media/usb/au0828/au0828.h      |   6 +-
 include/media/media-dev-allocator.h    |  54 ++++
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
 18 files changed, 872 insertions(+), 61 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.17.1

