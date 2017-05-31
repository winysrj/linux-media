Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:61857 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdEaOTQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 10:19:16 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id C0931209CA
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 17:18:43 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] Prepare for cache coherency changes in videobuf2
Date: Wed, 31 May 2017 17:17:24 +0300
Message-Id: <1496240247-25936-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

I split off these three patches from another set ("vb2: Handle user cache
hints, allow drivers to choose cache coherency"):

<URL:http://www.spinics.net/lists/linux-media/msg115401.html>

The reason is that the rest of the set requires further work in order to
be mergeable. For now, just three patches. The functional change will be
moving the cache operations where they should have been all along.

-- 
Kind regards,
Sakari
