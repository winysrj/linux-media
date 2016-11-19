Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44086 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752847AbcKSWYf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 17:24:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: arnd@arndb.de
Subject: [PATCH v2 0/2] smiapp fix for w/o CONFIG_PM, compiler warnings
Date: Sun, 20 Nov 2016 00:24:24 +0200
Message-Id: <1479594266-3034-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The two patches fix the PM / compiler warning issues Arnd found in the
smiapp driver.

since v1:

- Use IS_ENABLED() instead of preprocessor macros.

- Add another patch to fix compiler warnings.

-- 
Kind regards,
Sakari

