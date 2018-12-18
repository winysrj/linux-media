Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB8DC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 18:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0A3321873
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545156019;
	bh=65oUv1Q9O9GCn+7cXSZc11WmAUrR7QwB964m9tQVbLc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=uuVkJSUpBtnTP3zm96K/r+XdeSdslpBmYDUuoGc1zcL+G5MP+RtoXrL32G1I+id3D
	 iaznhzya7jhJ7qDgVYI1HXYwd/oUvvtE0kcS5SZO1IPt6bCJJdQuY1+BL1ZgKu8hJT
	 w+Ox5FMfJ9weqf1Sgi7pQwsnt6vlAQ9jTe/x2Rko=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbeLRR7m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 12:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbeLRR7m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 12:59:42 -0500
Received: from localhost.localdomain (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2258721871;
        Tue, 18 Dec 2018 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545155981;
        bh=65oUv1Q9O9GCn+7cXSZc11WmAUrR7QwB964m9tQVbLc=;
        h=From:To:Cc:Subject:Date:From;
        b=wN5Tjj/pryfy/QLZ4YOqBvgGj7+yTWevtJ/6ivxAcHn04XeaT9xZMh28mRXURTwsn
         zSBACIhGxZmUErfiVEmq7UIcOPRObGCrhvEPidcgjNaqDVHvNYQu/mKg4Ulx5EZOk/
         bmccQ0PJBdRH84eFsYJ6Ba3wBQK/z6rqL7HrczJU=
From:   shuah@kernel.org
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v9 0/4] Media Device Allocator API
Date:   Tue, 18 Dec 2018 10:59:35 -0700
Message-Id: <cover.1545154777.git.shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Shuah Khan <shuah@kernel.org>

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

- Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
  arecord. When analog is streaming, digital and audio user-space
  applications detect that the tuner is busy and exit. When digital
  is streaming, analog and audio applications detect that the tuner is
  busy and exit. When arecord is owns the tuner, digital and analog
  detect that the tuner is busy and exit.
- Tested media device allocator API with bind/unbind testing on
  snd-usb-audio and au0828 drivers to make sure /dev/mediaX is released
  only when the last driver is unbound.
- This patch series is tested on 4.20-rc6
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

Shuah Khan (4):
  media: Media Device Allocator API
  media: change au0828 to use Media Device Allocator API
  media: media.h: Enable ALSA MEDIA_INTF_T* interface types
  sound/usb: Use Media Controller API to share media resources

 Documentation/media/kapi/mc-core.rst   |  41 ++++
 drivers/media/Makefile                 |   4 +
 drivers/media/media-dev-allocator.c    | 132 ++++++++++
 drivers/media/usb/au0828/au0828-core.c |  12 +-
 drivers/media/usb/au0828/au0828.h      |   1 +
 include/media/media-dev-allocator.h    |  53 ++++
 include/uapi/linux/media.h             |  25 +-
 sound/usb/Kconfig                      |   4 +
 sound/usb/Makefile                     |   2 +
 sound/usb/card.c                       |  14 ++
 sound/usb/card.h                       |   3 +
 sound/usb/media.c                      | 321 +++++++++++++++++++++++++
 sound/usb/media.h                      |  74 ++++++
 sound/usb/mixer.h                      |   3 +
 sound/usb/pcm.c                        |  29 ++-
 sound/usb/quirks-table.h               |   1 +
 sound/usb/stream.c                     |   2 +
 sound/usb/usbaudio.h                   |   6 +
 18 files changed, 705 insertions(+), 22 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.17.1

