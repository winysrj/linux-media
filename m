Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BEFC4151A
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 15:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCADB2082E
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 15:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfBDPnL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:43:11 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59256 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729370AbfBDPnL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 10:43:11 -0500
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5A647634C7E;
        Mon,  4 Feb 2019 17:41:54 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 0/2] Remove more SoC camera sensor drivers
Date:   Mon,  4 Feb 2019 17:42:05 +0200
Message-Id: <20190204154207.9120-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi folks,

This set removes two additional SoC camera sensor drivers that have
corresponding V4L2 sub-device drivers.

Sakari Ailus (2):
  soc_camera: Remove the mt9m001 SoC camera sensor driver
  soc_camera: Remove the rj45n1 SoC camera sensor driver

 drivers/media/i2c/soc_camera/Kconfig          |   13 -
 drivers/media/i2c/soc_camera/Makefile         |    2 -
 drivers/media/i2c/soc_camera/soc_mt9m001.c    |  757 -------------
 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c | 1415 -------------------------
 4 files changed, 2187 deletions(-)
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9m001.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c

-- 
2.11.0

