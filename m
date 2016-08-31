Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53038 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756559AbcHaHnm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 03:43:42 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id EC52D202BC
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2016 10:43:00 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] smiapp cleanups, retry probe if getting clock fails
Date: Wed, 31 Aug 2016 10:42:00 +0300
Message-Id: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

These patches contain cleanups for the smiapp driver and return
-EPROBE_DEFER if getting the clock fails.

-- 
Kind regards,
Sakari

