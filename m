Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19239 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753037AbdBNMFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 07:05:15 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: v4l: Add camera voice coil lens control class, current control
Date: Tue, 14 Feb 2017 14:03:00 +0200
Message-Id: <1487073782-27366-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

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

-- 
Kind regards,
Sakari
