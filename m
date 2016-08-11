Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36703 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbcHKUaK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 16:30:10 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
Subject: [PATCH v4 0/5] Refactor media IOCTL handling, add variable length arguments
Date: Thu, 11 Aug 2016 23:29:13 +0300
Message-Id: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This is the fourth version of the media IOCTL handling rework set. What's
changed since v3:

patch 1:

- Use BUILD_BUG_ON() and ARRAY_SIZE() to ensure the ioctl array and the
  equivalent compat array are always in sync. (This caused quite a few
  conflicts with the rest of the patches.)

patch 5:                                                                        

- Don't use unlikely().

- Fix commit message --- the patch was changed to use supported IOCTL sizes
  but the commit message was not updated.
                                                                                
---                                                                             
                                                                                
The patches themselves have been reworked so I don't detail the changes         
in this set. What's noteworthy however is that the set adds support for         
variable length IOCTL arguments.                                                
                                                                                
(The motivation for these patches is having found myself pondering whether      
to have nine or thirteen reserved fields for the request IOCTL. I decided       
to address the problem instead. If this is found workable on the media          
controller we could follow the same model on V4L2.)                             

-- 
Kind regards,
Sakari

