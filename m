Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D243C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 501DD218D3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548361967;
	bh=bepO7BCIsiNzv741MrCe8Mnu11JyA/lw4/zL++3auRM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=dm0qE6bw7rZ54yHlhkXwR6+xBGichOiDIV0bwe5/EddVLDRhMTEbzUPOaE/mtVZWr
	 S++3kbGV0qmi7ovtKAftoFdahEHNaDtYrq4Cwft4XyVKy7EgZngbCWqN3Mzgne9FAT
	 E3meaHV55KNe/e/8rtU2bxYX4F2yx+PKf+DuUg+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfAXUcq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 15:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfAXUcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 15:32:46 -0500
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51D012184C;
        Thu, 24 Jan 2019 20:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548361965;
        bh=bepO7BCIsiNzv741MrCe8Mnu11JyA/lw4/zL++3auRM=;
        h=From:To:Cc:Subject:Date:From;
        b=lYYv0gnYM6njVxpEF46cCPb/1t3zl64kgXBu0WxoyG+q4Dr7FHTpbNoRcMHVWNdnN
         h8tjUdJTWaM5YYXkvXASHVlRjc2oljyeEkOyUN+3B03Iw1O2Ww9LGD5tSWhCKGg91f
         Rw0TTzPmNX1E9VrtH4SafA3G6fXyuveG9duVD3Cc=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v10 0/4] Media Device Allocator API
Date:   Thu, 24 Jan 2019 13:32:37 -0700
Message-Id: <cover.1548360791.git.shuah@kernel.org>
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

- This patch series is tested on 5.0-rc3 and addresses comments on
  v9 series from Hans Verkuil.
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

Shuah Khan (4):
  media: Media Device Allocator API
  media: change au0828 to use Media Device Allocator API
  media: media.h: Enable ALSA MEDIA_INTF_T* interface types
  sound/usb: Use Media Controller API to share media resources

 Documentation/media/kapi/mc-core.rst   |  41 ++++
 drivers/media/Makefile                 |   4 +
 drivers/media/media-dev-allocator.c    | 144 +++++++++++
 drivers/media/usb/au0828/au0828-core.c |  12 +-
 drivers/media/usb/au0828/au0828.h      |   1 +
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
 18 files changed, 723 insertions(+), 22 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.17.1

