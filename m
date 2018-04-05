Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:49503 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbeDEKBc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:01:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 0/2] v4l-utils fixes
Date: Thu,  5 Apr 2018 13:00:38 +0300
Message-Id: <1522922440-8622-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

The two patches add instructions for building static binaries as well as
fix a few warnings in libdvb5.

Sakari Ailus (2):
  Add instructions for building static binaries
  libdvb5: Fix unused local variable warnings

 INSTALL                      | 16 ++++++++++++++++
 lib/libdvbv5/dvb-dev-local.c |  5 +++--
 2 files changed, 19 insertions(+), 2 deletions(-)

-- 
2.7.4
