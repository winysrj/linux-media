Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35795 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbdIVHpH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 03:45:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH v2 0/2] Improve generic DT binding documentation for media devices
Date: Fri, 22 Sep 2017 10:42:12 +0300
Message-Id: <1506066134-25997-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This set improves the DT binding documentation for media devices where
device specific documentation is lacking and also documents that explicit
documentation of all properties supported by the device is required.

- Port and endpoint numbering
- lane numbering for the data-lanes property

Sakari Ailus (2):
  dt: bindings: media: Document practices for DT bindings, ports,
    endpoints
  dt: bindings: media: Document data lane numbering without lane
    reordering

 .../devicetree/bindings/media/video-interfaces.txt   | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

-- 
2.7.4
