Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F51CC43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F7F4206BA
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfCKPZv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:25:51 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:39306 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726926AbfCKPZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 11:25:51 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3MoEhSeVA4HFn3MoHhFJtf; Mon, 11 Mar 2019 16:25:49 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.2] Various fixes/enhancements part 2
Message-ID: <4132455b-41ca-3c3e-f809-fd2b3f872eeb@xs4all.nl>
Date:   Mon, 11 Mar 2019 16:25:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPXrxr/vPaq6UKbvwB15hIdeHmuMi4fl9q/xjSTPYn8y27HJYn/7JerrMeaPqunulnpd2ovaHaXKF07mPkbGFNAdu+cqej1jqCC4v+Co6AzGFzMsnvfk
 pCzGn4UZOESrnricPS6BpafRpxJYGa0Xbd2OJN6XYDRfq0ZlJz7J0Cpbu1B6o1+8Vu6u+n4x23aRqw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-04 06:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.2b

for you to fetch changes up to e1585164f65ae0d034252bb8e4bffd906bb3d889:

  gspca: do not resubmit URBs when streaming has stopped (2019-03-11 15:59:41 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Arnd Bergmann (3):
      media: saa7146: avoid high stack usage with clang
      media: go7007: avoid clang frame overflow warning with KASAN
      media: vicodec: avoid clang frame size warning

Dan Carpenter (2):
      media: ivtv: update *pos correctly in ivtv_read_pos()
      media: cx18: update *pos correctly in cx18_read_pos()

Hans Verkuil (1):
      gspca: do not resubmit URBs when streaming has stopped

Jernej Skrabec (3):
      dt-bindings: media: cedrus: Add H6 compatible
      media: cedrus: Add a quirk for not setting DMA offset
      media: cedrus: Add support for H6

Ken Sloat (1):
      media: atmel-isc: Add support for BT656 with CRC decoding

Shuah Khan (2):
      media: replace WARN_ON in __media_pipeline_start()
      au0828: minor fix to a misleading comment in _close()

 Documentation/devicetree/bindings/media/cedrus.txt |  1 +
 drivers/media/media-entity.c                       |  5 ++++-
 drivers/media/pci/cx18/cx18-fileops.c              |  2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |  2 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |  5 ++---
 drivers/media/pci/saa7146/hexium_orion.c           |  5 ++---
 drivers/media/platform/atmel/atmel-isc-regs.h      |  2 ++
 drivers/media/platform/atmel/atmel-isc.c           |  7 ++++++-
 drivers/media/platform/vicodec/codec-fwht.c        | 29 ++++++++++++++++++-----------
 drivers/media/usb/au0828/au0828-video.c            |  4 ++--
 drivers/media/usb/go7007/go7007-fw.c               |  4 ++--
 drivers/media/usb/gspca/gspca.c                    |  8 ++++++--
 drivers/staging/media/sunxi/cedrus/cedrus.c        |  9 +++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h        |  3 +++
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     |  3 ++-
 15 files changed, 61 insertions(+), 28 deletions(-)
