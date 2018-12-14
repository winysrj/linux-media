Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1334BC43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 21:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58F002086D
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 21:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbeLNVyG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 16:54:06 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47630 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730887AbeLNVyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 16:54:05 -0500
Received: from vihersipuli.localdomain (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::84:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C42D0634C7E;
        Fri, 14 Dec 2018 23:53:43 +0200 (EET)
Received: from sailus by vihersipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@iki.fi>)
        id 1gXvOx-0003WU-Og; Fri, 14 Dec 2018 23:53:43 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Subject: [PATCH v1.1 1/1] Documentation: staging/ipu3-imgu: Add license information
Date:   Fri, 14 Dec 2018 23:53:43 +0200
Message-Id: <20181214215343.13502-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181214122754.32714-2-sakari.ailus@linux.intel.com>
References: <20181214122754.32714-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The driver documentation is under GPL v2 and the uAPI documentation under
GNU FDL 1.1+ (without invariant sections) or GPL v2.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1

- Add GPL v2 for the uAPI docs as well

 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      | 25 +++++++++++++++++++++-
 Documentation/media/v4l-drivers/ipu3.rst           |  2 ++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
index dc871006b41a..659e58aa9c93 100644
--- a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
@@ -1,4 +1,27 @@
-.. -*- coding: utf-8; mode: rst -*-
+.. This file is dual-licensed: you can use it either under the terms
+.. of the GPL 2.0 or the GFDL 1.1+ license, at your option. Note that this
+.. dual licensing only applies to this file, and not this project as a
+.. whole.
+..
+.. a) This file is free software; you can redistribute it and/or
+..    modify it under the terms of the GNU General Public License version
+..    2.0 as published by the Free Software Foundation.
+..
+..    This file is distributed in the hope that it will be useful,
+..    but WITHOUT ANY WARRANTY; without even the implied warranty of
+..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+..    GNU General Public License version 2.0 for more details.
+..
+.. Or, alternatively,
+..
+.. b) Permission is granted to copy, distribute and/or modify this
+..    document under the terms of the GNU Free Documentation License,
+..    Version 1.1 or any later version published by the Free Software
+..    Foundation, with no Invariant Sections, no Front-Cover Texts
+..    and no Back-Cover Texts. A copy of the license is included at
+..    Documentation/media/uapi/fdl-appendix.rst.
+..
+.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _v4l2-meta-fmt-params:
 .. _v4l2-meta-fmt-stat-3a:
diff --git a/Documentation/media/v4l-drivers/ipu3.rst b/Documentation/media/v4l-drivers/ipu3.rst
index f89b51dafadd..eb4ad488b3dd 100644
--- a/Documentation/media/v4l-drivers/ipu3.rst
+++ b/Documentation/media/v4l-drivers/ipu3.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 ===============================================================
-- 
2.11.0

