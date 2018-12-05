Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421EAC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40B720659
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F40B720659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbeLEMJ5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:09:57 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53695 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727680AbeLEMJ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 07:09:56 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UVzygMfGDUylNUW03gwY1R; Wed, 05 Dec 2018 13:09:55 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH for v4.20 2/2] extended-controls.rst: add note to the MPEG2 state controls
Date:   Wed,  5 Dec 2018 13:09:50 +0100
Message-Id: <20181205120950.36986-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205120950.36986-1-hverkuil-cisco@xs4all.nl>
References: <20181205120950.36986-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfItqBOBBncnip+nHfCTTeIsV3NOTxrO4LlQXKDbOOBcRkenmsevis6zr/zp/Q6U/e22Nzx7cQd3Q9uNGOQWnicOHMpQq0t2tLSzHmYtmLZ+iy3Qx+NuA
 8matAGU3XCdboU1maWujF8PShwTShFRk83Zn/YQqcdCoyGdmgHV1FchlBnDKlohQAxNWPRYEy3iEucBJp+vSH1ZOdg8g0+XpFquQID/CLCMd2WBkDT9hq3Vd
 t4TJFf+dw2ETYvOf+169sM2Vn4bnrhoHqjPnZfystpH2EqZRkuAqOboDztV/3qfwmAmRwTtfO3dBevUbv3qf2Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Add a note mentioning that these two controls are not part of the
public API while they still stabilizing.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 65a1d873196b..027358b91082 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1505,6 +1505,11 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
     configuring a stateless hardware decoding pipeline for MPEG-2.
     The bitstream parameters are defined according to :ref:`mpeg2part2`.
 
+    .. note::
+
+       This compound control is not yet part of the public kernel API and
+       it is expected to change.
+
 .. c:type:: v4l2_ctrl_mpeg2_slice_params
 
 .. cssclass:: longtable
@@ -1625,6 +1630,11 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
     Specifies quantization matrices (as extracted from the bitstream) for the
     associated MPEG-2 slice data.
 
+    .. note::
+
+       This compound control is not yet part of the public kernel API and
+       it is expected to change.
+
 .. c:type:: v4l2_ctrl_mpeg2_quantization
 
 .. cssclass:: longtable
-- 
2.19.1

