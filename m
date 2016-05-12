Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35248 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752010AbcELMPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 08:15:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl, david@unsolicited.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] videobuf2: Fix kernel memory overwriting
Date: Thu, 12 May 2016 15:14:50 +0300
Message-Id: <1463055292-25053-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

There was a bug in the first version of the set --- the pb argument to
__vb2_get_done_vb() is NULL in cases which did not get tested the last time.

The second patch in the set was reverted for that reason.

This set contains a patch originally from David and again the second
reverted patch to fix the memory corruption issue. The previous set can be
found here:

<URL:http://www.spinics.net/lists/linux-media/msg99336.html>

The patches have been tested with V4L2 streaming and file I/O API but not
with DVB.

-- 
Kind regards,
Sakari

