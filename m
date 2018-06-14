Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46554 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752767AbeFNM3m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 08:29:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org
Subject: [PATCH v3 0/2] Support rotation property for smia sensors
Date: Thu, 14 Jun 2018 15:29:37 +0300
Message-Id: <20180614122939.21257-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This is an earlier patch "smiapp: Support the "upside-down" property"
split into two -- the DT binding change and a driver change.

The only change is in DT bindings --- an added reference to
video-interfaces.txt in rotation property documentation.

Sakari Ailus (2):
  dt-bindings: smia: Add "rotation" property
  smiapp: Support the "rotation" property

 .../devicetree/bindings/media/i2c/nokia,smia.txt         |  3 +++
 drivers/media/i2c/smiapp/smiapp-core.c                   | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

-- 
2.11.0
