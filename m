Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52824 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751626AbdBMQQb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 11:16:31 -0500
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 69732600AA
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 18:16:27 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] smiapp cleanups, clock control changes
Date: Mon, 13 Feb 2017 18:16:22 +0200
Message-Id: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

With this set, the smiapp driver can support clocks not coming from the
clock framework (e.g. ACPI). The smiapp.h header under include/media/i2c/
is also removed as it is no longer needed.

-- 
Kind regards,
Sakari
