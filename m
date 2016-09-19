Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35290 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752215AbcISWDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:10 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 00/18] More smiapp cleanups, fixes
Date: Tue, 20 Sep 2016 01:02:33 +0300
Message-Id: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set further cleans up the smiapp driver and prepares for later
changes.

since v2:

- Fix badly formatted debug message on wrong frame format model type

- Add a debug message on faulty frame descriptor (image data lines are
  among embedded data lines)

- Fix error handling in registered() callback, add  unregistered()
  callback

- smiapp_create_subdev() will return immediately if its ssd argument is
  NULL. No need for caller to check this.

-- 
Kind regards,
Sakari

