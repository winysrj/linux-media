Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926BDC67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 15:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59BD82086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544630058;
	bh=VlvrLspD8k/Ifs2EcMmBg1tiuP/synGvJZLeW5KsMws=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=uOAYc1hBriurZMhpqJAmMF/z9Xx3QUbzQmMx3JbDpredoiyCNca5+gKZxCFJkiAV4
	 MyydUP+/dhipNERuhicbvLLUVXUHcDkTJNGNwAeiqgdL7y+bp/tNM88Eusd/ZmjFlg
	 1atZ5cirTVBEDha9ypgN83hotofuWAgDPnlcKU5s=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59BD82086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbeLLPyM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 10:54:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:36234 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeLLPyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 10:54:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WbfwLgK7xlauiTjRYJNb2JutczK1M1HeK6JBTckc+kY=; b=kzEaSTbL17KCoEBHVUnwHQX46g
        27WxCDueSIsoCJ0DbvZ84fKSfzir6V2dXBRaL3MNWy0WUbGqQf91f1RfXa6OY5slveJn3djrGqPtS
        ZwtHBtv1b6XFMNGSKwG+IRE20vtnYAqTro84VCHpzc1XhnAuAK6K9bRA1rMKva76moDBPZyFcG2yC
        mHssNbUK6xETrTMeqwME2rHSTgLSwphjWhALaSFqVwd4yISokms381Y+2luQHkv2d8bjtuyrHv3Ah
        fC/6Ph4lg2J8jjFYLa9AvdVwtNcEB2Q7toZDTt5FkJizJ0+PToyhNEddVsczDkmBbBv0jm2Aywp7Y
        lIVFaURw==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gX6pt-0005iC-K9; Wed, 12 Dec 2018 15:54:10 +0000
Date:   Wed, 12 Dec 2018 13:54:03 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.20-rc7] media fixes
Message-ID: <20181212135403.3ce9132a@coco.lan>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-5


For 
  - one regression at vsp1 driver;
  - some last time changes for the upcoming request API logic and for
    stateless codec support. As the stateless codec "cedrus" driver
    is at staging, don't apply the MPEG controls as part of the main
    V4L2 API, as those may not be ready for production yet.

Regards,
Mauro


The following changes since commit a7c3a0d5f8d8cd5cdb32c06d4d68f5b4e4d2104b:

  media: mediactl docs: Fix licensing message (2018-11-27 13:52:46 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-5

for you to fetch changes up to 078ab3ea2c3bb69cb989d52346fefa1246055e5b:

  media: Add a Kconfig option for the Request API (2018-12-05 13:07:43 -0500)

----------------------------------------------------------------
media fixes for v4.20-rc7

----------------------------------------------------------------
Dan Carpenter (1):
      media: cedrus: Fix a NULL vs IS_ERR() check

Hans Verkuil (8):
      media: vb2: don't call __vb2_queue_cancel if vb2_start_streaming failed
      media: vb2: skip request checks for VIDIOC_PREPARE_BUF
      media: vb2: keep a reference to the request until dqbuf
      media: vb2: don't unbind/put the object when going to state QUEUED
      media: vivid: drop v4l2_ctrl_request_complete() from start_streaming
      media: vicodec: set state resolution from raw format
      media: mpeg2-ctrls.h: move MPEG2 state controls to non-public header
      media: extended-controls.rst: add note to the MPEG2 state controls

Laurent Pinchart (1):
      media: vsp1: Fix LIF buffer thresholds

Sakari Ailus (1):
      media: Add a Kconfig option for the Request API

 Documentation/media/uapi/v4l/extended-controls.rst | 10 +++
 drivers/media/Kconfig                              | 13 ++++
 drivers/media/common/videobuf2/videobuf2-core.c    | 44 ++++++++---
 drivers/media/common/videobuf2/videobuf2-v4l2.c    | 13 +++-
 drivers/media/media-device.c                       |  4 +
 drivers/media/platform/vicodec/vicodec-core.c      | 13 +++-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 -
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 -
 drivers/media/platform/vivid/vivid-vbi-out.c       |  2 -
 drivers/media/platform/vivid/vivid-vid-cap.c       |  2 -
 drivers/media/platform/vivid/vivid-vid-out.c       |  2 -
 drivers/media/platform/vsp1/vsp1_lif.c             |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  4 +-
 drivers/staging/media/sunxi/cedrus/Kconfig         |  1 +
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     |  4 +-
 include/media/mpeg2-ctrls.h                        | 86 ++++++++++++++++++++++
 include/media/v4l2-ctrls.h                         |  6 ++
 include/media/videobuf2-core.h                     |  2 +
 include/uapi/linux/v4l2-controls.h                 | 68 -----------------
 include/uapi/linux/videodev2.h                     |  4 -
 20 files changed, 181 insertions(+), 103 deletions(-)
 create mode 100644 include/media/mpeg2-ctrls.h

