Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F48CC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 543172177B
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfAIT5W (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 14:57:22 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41632 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfAIT5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 14:57:22 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:401])
        by kozue.soulik.info (Postfix) with ESMTPA id 8A7C0100C2B;
        Thu, 10 Jan 2019 04:58:02 +0900 (JST)
From:   Randy Li <ayaka@soulik.info>
To:     dri-devel@lists.freedesktop.org
Cc:     mchehab+samsung@kernel.org, mikhail.v.gavrilov@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, daniel@fooishbar.org, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, maarten.lankhorst@linux.intel.com,
        maxime.ripard@bootlin.com, sean@poorly.run, airlied@linux.ie,
        daniel@ffwll.ch, Randy Li <ayaka@soulik.info>
Subject: [PATCH v10 0/2] Add pixel format for 10 bits YUV video
Date:   Thu, 10 Jan 2019 03:57:08 +0800
Message-Id: <20190109195710.28501-1-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As the requirement from:
P010 fourcc format support - Was: Re: Kernel error "Unknown pixelformat
0x00000000" occurs when I start capture video

I don't know which device would support the P010, P012, P016 video pixel
format, but Rockchip would support that NV12_10LE40 and a patch for that
driver is sent before.

Randy Li (2):
  drm/fourcc: Add new P010, P016 video format
  drm/fourcc: add a 10bits fully packed variant of NV12

 drivers/gpu/drm/drm_fourcc.c  | 13 +++++++++++++
 include/uapi/drm/drm_fourcc.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

-- 
2.20.1

