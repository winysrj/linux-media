Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20424 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752475AbdEEItZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 04:49:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: pavel@ucw.cz, sebastian.reichel@collabora.co.uk
Subject: [RFC v2 0/3] Document bindings for camera modules and associated flash devices
Date: Fri,  5 May 2017 11:48:27 +0300
Message-Id: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC patchset documents properties commonly required by camera modules
and associated camera flash devices.

The camera module is essentially a package consisting of an image sensor, 
a lens, possibly a voice coil to move the lens and a number of other
things that at least the drivers need not to know of. All the devices in a
camera module are declared separately in the system and as such the fact
that they come in a single package isn't generally very useful to driver
software. 

I'm sending the set as RFC as there's no driver implementation, and a 
dependency to the V4L2 async changes:

<URL:http://www.spinics.net/lists/linux-media/msg114915.html>

since RFC v1:

- Remove sentences elaborating applicability of the bindings.

- Say a LED driver is a piece of hardware.

- Otherwise reformulate the descriptions according to the comments.

Sakari Ailus (3):
  dt: bindings: Add a binding for flash devices associated to a sensor
  dt: bindings: Add lens-focus binding for image sensors
  dt: bindings: Add a binding for referencing EEPROM from camera sensors

 .../devicetree/bindings/media/video-interfaces.txt       | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

-- 
2.7.4
