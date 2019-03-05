Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97088C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C44D20848
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfCEN4F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:56:05 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49470 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727271AbfCEN4F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 08:56:05 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 78A72634C7B;
        Tue,  5 Mar 2019 15:55:04 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     akinobu.mita@gmail.com, robert.jarzmik@free.fr, hverkuil@xs4all.nl,
        bparrot@ti.com
Subject: [PATCH 0/4] V4L2 fwnode framework and driver fixes
Date:   Tue,  5 Mar 2019 15:55:58 +0200
Message-Id: <20190305135602.24199-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi folks,

Here are a few fixes for the parsing fwnodes in the V4L2 framework as well
as drivers using it.

Sakari Ailus (4):
  v4l2-fwnode: Defaults may not override endpoint configuration in
    firmware
  v4l2-fwnode: The first default data lane is 0 on C-PHY
  pxa-camera: Match with device node, not the port node
  ti-vpe: Parse local endpoint for properties, not the remote one

 drivers/media/platform/pxa_camera.c   |  2 +-
 drivers/media/platform/ti-vpe/cal.c   | 11 ++---------
 drivers/media/v4l2-core/v4l2-fwnode.c | 12 ++++++++++--
 3 files changed, 13 insertions(+), 12 deletions(-)

-- 
2.11.0

