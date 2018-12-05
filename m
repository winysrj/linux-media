Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5835EC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11B1F20659
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11B1F20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbeLEMJ4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:09:56 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56854 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbeLEMJ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 07:09:56 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UVzygMfGDUylNUW02gwY19; Wed, 05 Dec 2018 13:09:54 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com
Subject: [PATCH for v4.20 0/2] cedrus: move MPEG controls out of the uAPI
Date:   Wed,  5 Dec 2018 13:09:48 +0100
Message-Id: <20181205120950.36986-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLoNMZJ8DUum9DGwF60ElbLU4dk2K8DOWHTA7Q0xXB0xGDXDQGqX1hOGhVqyeQ3XM3g8M92uiyQdEMMV88ZtkxQkcHEO5MhDYB93QdM8n/hvv1/Bt1+O
 hVOkaf+3Umbytp18/GSwFuSj8wLNis7J+mOurav6RZcIBdGWdr5CPyHTUkwG5R1AsmcDcYbwyfCwFUYzq1v2dMl8UP5m92KdKb1GH0XgHFydeCkj2+nRd+Kh
 LoXbkQaY+c7SdFBkY4uRU02jRaH2HaJ0+F7BrSDxMws=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The expectation was that the MPEG-2 state controls used by the staging
cedrus driver were stable, or would only require one final change. However,
it turns out that more changes are required, and that means that it is not
such a good idea to have these controls in the public kernel API.

This patch series moves all the MPEG-2 state control data to a new
media/mpeg2-ctrls.h header. So none of this is available from the public
API.

However, v4l2-ctrls.h includes it for now so the kAPI still knows about it
allowing the cedrus driver to use it without changes.

The second patch adds a note to these two controls, mentioning that they
are likely to change.

Moving forward, this allows us to take more time in getting the MPEG-2
(and later H264/5) state controls right.

Regards,

	Hans

Hans Verkuil (2):
  mpeg2-ctrls.h: move MPEG2 state controls to non-public header
  extended-controls.rst: add note to the MPEG2 state controls

 .../media/uapi/v4l/extended-controls.rst      | 10 +++
 drivers/media/v4l2-core/v4l2-ctrls.c          |  4 +-
 include/media/mpeg2-ctrls.h                   | 86 +++++++++++++++++++
 include/media/v4l2-ctrls.h                    |  6 ++
 include/uapi/linux/v4l2-controls.h            | 68 ---------------
 include/uapi/linux/videodev2.h                |  4 -
 6 files changed, 104 insertions(+), 74 deletions(-)
 create mode 100644 include/media/mpeg2-ctrls.h

-- 
2.19.1

