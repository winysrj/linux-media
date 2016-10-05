Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:18104 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbcJEHXs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:23:48 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 8F00120077
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 10:23:16 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC 0/5] V4L2 fwnode support
Date: Wed,  5 Oct 2016 10:21:44 +0300
Message-Id: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This patchset adds support for fwnode to V4L2. Besides OF, also ACPI based
systems can be supported this way. By using V4L2 fwnode, the individual
drivers do not need to be aware of the underlying firmware implementation.

The patchset depends on another patchset here:

<URL:http://www.spinics.net/lists/linux-acpi/msg69547.html>

And a fix for the V4L2 flash led class:

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=v4l2-acpi&id=6abbf66418804aa5b82cc3231eab73c9759dcd69>

I'm sending this as RFC primarily because the other set is at RFC stage.

The intent is to eventually replace the plain OF support by the generic
fwnode support in drivers.

-- 
Kind regards,
Sakari

