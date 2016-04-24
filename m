Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34198 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbcDXVKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:25 -0400
Received: by mail-wm0-f65.google.com with SMTP id n3so20028242wmn.1
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:24 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 11/24] dt: bindings: v4l: Add bus-type video interface property
Date: Mon, 25 Apr 2016 00:08:11 +0300
Message-Id: <1461532104-24032-12-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

In the vast majority of cases the bus type is known to the driver(s) since
a receiver or transmitter can only support a single one. There are cases
however where different options are possible.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 9cd2a36..f5b61bd 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -76,6 +76,10 @@ Optional endpoint properties
   mode horizontal and vertical synchronization signals are provided to the
   slave device (data source) by the master device (data sink). In the master
   mode the data source device is also the source of the synchronization signals.
+- bus-type: data bus type. Possible values are:
+  0 - CSI2
+  1 - parallel / Bt656
+  2 - CCP2
 - bus-width: number of data lines actively used, valid for the parallel busses.
 - data-shift: on the parallel data busses, if bus-width is used to specify the
   number of data lines, data-shift can be used to specify which data lines are
-- 
1.9.1

