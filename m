Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1A7C282DA
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95DA021479
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfBBMK3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 07:10:29 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50633 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbfBBMKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2019 07:10:24 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7i-0008D9-5a; Sat, 02 Feb 2019 13:10:14 +0100
Received: from mfe by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7e-0002Ol-34; Sat, 02 Feb 2019 13:10:10 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     robh+dt@kernel.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 0/5] TV norms limit and TVP5150 implementation
Date:   Sat,  2 Feb 2019 13:09:59 +0100
Message-Id: <20190202121004.9014-1-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

in short this series adds the support to limit the tv norms on an
analog-connector.

I recognized that all drivers dealing with connectors implemented
their own parsing routine due to the lack of a generic one. A generic
parsing routine needs a connector container which contain common
data and connector specific data. This series implements the connector
container struct and the generic parsing routine. At the moment only
analog-connectors are fully supported but adding the others should
be simple.

Finally the TVP5150 driver is converted to the generic connector and
make use of the new 'tv norms limiting' feature.

I'm not sure if the series applies cleanly without [1].

Regards,
Marco

[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg143925.html

Marco Felsch (5):
  dt-bindings: connector: analog: add tv norms property
  media: v4l2-fwnode: add v4l2_fwnode_connector
  media: v4l2-fwnode: add initial connector parsing support
  media: tvp5150: make use of generic connector parsing
  media: tvp5150: add support to limit tv norms on connector

 .../display/connector/analog-tv-connector.txt |   4 +
 drivers/media/i2c/tvp5150.c                   | 116 +++++++++---------
 drivers/media/v4l2-core/v4l2-fwnode.c         | 113 +++++++++++++++++
 include/dt-bindings/media/tvnorms.h           |  42 +++++++
 include/media/v4l2-connector.h                |  34 +++++
 include/media/v4l2-fwnode.h                   |  49 ++++++++
 6 files changed, 302 insertions(+), 56 deletions(-)
 create mode 100644 include/dt-bindings/media/tvnorms.h
 create mode 100644 include/media/v4l2-connector.h

-- 
2.20.1

