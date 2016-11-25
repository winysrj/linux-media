Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53890 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753808AbcKYN4W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 08:56:22 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se
Subject: [PATCH 0/5] Media pipeline and graph walk cleanups and fixes
Date: Fri, 25 Nov 2016 15:55:41 +0200
Message-Id: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This patchset contains a few cleanups and fixes for graph traversal and
pipeline starting and stopping.

The set prepares for further routing changes without still making any of
them. I'll post further patches on routing in the near future.

Niklas: these go on top of your two patches in your series. Some of the
later patches in the series will conflict with the graph walk / pipeline
interface rename. I think it'd be ideal to have a single pull request to
contain them all when it's been all reviewed. What do you think?

-- 
Kind regards,
Sakari

