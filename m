Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:56433 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752729AbdBMNbD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:31:03 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/8] V4L2 fwnode support
Date: Mon, 13 Feb 2017 15:28:08 +0200
Message-Id: <1486992496-21078-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

This patchset adds support for fwnode to V4L2. Besides OF, also ACPI based
systems can be supported this way. By using V4L2 fwnode, the individual
drivers do not need to be aware of the underlying firmware implementation.
The patchset also removes specific V4L2 OF support and converts the
affected drivers to use V4L2 fwnode.

The patchset depends on another patchset here:

<URL:http://www.spinics.net/lists/linux-acpi/msg71809.html>

-- 
Kind regards,
Sakari
