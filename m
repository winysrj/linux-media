Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20019 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbaE2OlD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 10:41:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3 0/3] smiapp test pattern support
Date: Thu, 29 May 2014 17:40:45 +0300
Message-Id: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches add four standard controls for test pattern raw bayer colour
component values and test pattern support for the smiapp driver.
Additionally, definitions are provided to control the smiapp driver's test
pattern menu, the items of which are driver specific.

Also the location of the header file has been fixed in the 2nd patch. 

The new controls are located in the image source class (vs. the image
processing class where the test pattern control is). I do prefer consistency
but when it's in conflict with correctness, the latter often wins. :-)

Kind regards,
Sakari

