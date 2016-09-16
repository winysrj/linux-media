Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2796 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756409AbcIPLvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 07:51:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        mchehab@s-opensource.com
Subject: [PATCH v5 0/4] Refactor media IOCTL handling
Date: Fri, 16 Sep 2016 14:49:04 +0300
Message-Id: <1474026548-28829-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the 5th version of the media IOCTL rework set.

since v4:

- Don't refactor compat IOCTL handling. The assumption is that the compat
  code will stay as-is and only the ENUM_LINKS IOCTL will require compat
  handling in the future and newer IOCTLs would use u64 for pointers.

This has brought about a number of changes, I've yet cunningly kept all
the acks. I'll perform more testing before sending a pull request; please
do read the code in the meantime.

The last patch of the set adding support for variable argument sizes is
postponed until a later time.

-- 
Kind regards,
Sakari

