Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9B3C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 072682184C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfAXIdN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:33:13 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49715 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725986AbfAXIdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:33:13 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id maRggVrjXNR5ymaRjgoqE9; Thu, 24 Jan 2019 09:33:11 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] doc improvements, v4l2-pci-skeleton.c fix
Message-ID: <1476a89f-eb80-8445-4e21-60e39d6686d0@xs4all.nl>
Date:   Thu, 24 Jan 2019 09:33:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGVNyL69LywjmBn0W03NpIpvpkVs5OeUZhhadxO9JevtsXqPiJW1gyKJeslu4PrHsDS8fMFpnCm9KnT4gPjturKyoZJS2aThej3+zwwuDbJZZ1yyyxYn
 i1svKR+Opo2Rv1l7sTDcvdjyll2qGfZYqRZhEi+VvBpRwAFg2URzOvJ0W4WLFjamG2TvHbMZQkub2A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 337e90ed028643c7acdfd0d31e3224d05ca03d66:

  media: imx-csi: Input connections to CSI should be optional (2019-01-21 16:46:02 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1h

for you to fetch changes up to ffe2189c9e75d0696426fad15d79c464003a26cd:

  Documentation/media: rename "Codec Interface" (2019-01-24 09:31:42 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (4):
      v4l2-pci-skeleton.c: fix outdated irq code
      dev-effect.rst: remove unused Effect Interface chapter
      dev-teletext.rst: remove obsolete teletext interface
      Documentation/media: rename "Codec Interface"

 Documentation/media/uapi/mediactl/request-api.rst               |  4 ++--
 Documentation/media/uapi/v4l/dev-effect.rst                     | 28 -------------------------
 Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} | 41 ++++++++++++++++++-------------------
 Documentation/media/uapi/v4l/dev-teletext.rst                   | 41 -------------------------------------
 Documentation/media/uapi/v4l/devices.rst                        |  4 +---
 Documentation/media/uapi/v4l/pixfmt-compressed.rst              |  2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst                    |  2 +-
 samples/v4l/v4l2-pci-skeleton.c                                 |  8 ++++----
 8 files changed, 29 insertions(+), 101 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/dev-effect.rst
 rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (50%)
 delete mode 100644 Documentation/media/uapi/v4l/dev-teletext.rst
