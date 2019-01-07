Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F397EC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5032147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfAGLKz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:10:55 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52068 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbfAGLKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:10:55 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 382C2634C7F;
        Mon,  7 Jan 2019 13:09:44 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, bingbu.cao@intel.com
Subject: [PATCH 0/2] Ipu3-cio2 and dw9714 driver e-mail and reviewer update
Date:   Mon,  7 Jan 2019 13:10:51 +0200
Message-Id: <20190107111053.5708-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

This set removes Jian Xu from the driver's reviewers as well as removes
his e-mail address from the module author.

Sakari Ailus (2):
  MAINTAINERS: Update reviewers for ipu3-cio2
  ipu3-cio2, dw9714: Remove Jian Xu's e-mail

 MAINTAINERS                              | 1 -
 drivers/media/i2c/dw9714.c               | 2 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

-- 
2.11.0

