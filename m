Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46766 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752149AbdCMN21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 09:28:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: elena.reshetova@intel.com
Subject: [PATCH 0/2] V4L2 driver refcount_t conversion
Date: Mon, 13 Mar 2017 15:24:54 +0200
Message-Id: <1489411496-31240-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

These two patches convert a few V4L2 driver from using atomic_t for
refcounts to the newly added refcount_t.

The previous version of the patches were posted by Elena to the list and
the review comments given to those patches have been addressed. In
particular,

- One of the patches was dropped (atomic_t not used as refcount),

- Merged four last VB2 patches as the in-between state would not compile /
  would compile with warnings and

- Indentation was fixed in the first patch.

-- 
Kind regards,
Sakari
