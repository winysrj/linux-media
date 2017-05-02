Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:58498 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbdEBK0u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 06:26:50 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [RFC 0/3] Document bindings for camera modules and associated flash devices
Date: Tue,  2 May 2017 13:25:46 +0300
Message-Id: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

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

-- 
Regards,
Sakari
