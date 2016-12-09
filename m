Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57734 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753631AbcLIOxy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:54 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2] Media pipeline and graph walk cleanups and fixes
Date: Fri,  9 Dec 2016 16:53:33 +0200
Message-Id: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This is the second version of the patchset that contains a few cleanups
and fixes for graph traversal and pipeline starting and stopping.
                                                                                
The set prepares for further routing changes without still making any of        
them. I'll post further patches on routing in the near future.                  
                                                                                
since v1:

- Rebase on media-tree master branch, i.e. this no longer depends on the
  routing patches.

- Use single quotes instead of double quotes. One additional patch was
  added (patch 5) to switch to single quotes in existing debug messages.

- Add three cleanup patches to various drivers to use a local mdev
  variable for the media device pointer rather than digging it up in a
  deep data structure.

-- 
Kind regards,
Sakari

