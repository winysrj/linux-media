Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbcGULPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 07:15:34 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [PATCH v3 0/5] Refactor media IOCTL handling, add variable length arguments
Date: Thu, 21 Jul 2016 14:14:39 +0300
Message-Id: <1469099686-10938-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the third version of the media IOCTL handling rework set. What's
changed since v2:

patch 3:

- Remove function to calculate maximum argument size, replace by a char         
  array of 256 or kmalloc() if that's too small.                                

- info->arg_from_user() may fail. Check the return code.                        

- Instead of providing a no-operation of a copy function, check whether one is  
  defined. If not, don't call one.                                              

patch 4:

- Arrange the flags field next to cmd, which is an integer. This avoids         
  creating extra holes in the struct memory layout.                             

patch 5:

- Use a list of supported argument sizes instead of a minimum value.

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

