Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56882 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752330AbdBNMV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 07:21:58 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH v3 0/2] v4l: Add camera voice coil lens control class, current control
Date: Tue, 14 Feb 2017 14:20:21 +0200
Message-Id: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

I wanted to refresh my voice coil lens patchset before we have more voice 
coil lens controller drivers. The VOCUS_ABSOLUTE control really is not a
best control ID to control a voice coil driver's current. 

There may be additional controls in the class: the hardware I'm familiar
with provides other controls (PWM vs. linear mode, resonance frequency and
ringing compensation formula to name a few) but I'm not fully certain 
they're something that even should be told to the user --- let alone
giving the user write access to them. 

My expectation is still that there will be more controls in the class. The
PWM / linear mode might be one candidate: PWM saves power but it may cause
other issues. These other issues might be something to ignore, depending
on the use case. That will be anyway left for the future. 

since v2:

- Don't remove the newline after control class definitions.

- Move all ad5820 related changes to the second patch. Some were
  accidentally left to the patch adding the new control class.

-- 
Kind regards,
Sakari
