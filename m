Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaDNJA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:56 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id E5C832003E
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:52 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 00/12] smiapp and smiapp-pll quirk improvements, fixes
Date: Mon, 14 Apr 2014 11:58:25 +0300
Message-Id: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,                                                                       

This is the second version of the smiapp and smiapp-pll quirk improvement
patchset. The first version can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg75538.html>

Changes since v1:

- Fix a compiler warning in smiapp-pll.c added by the patch changing limits
  to 64 bits.

- Add a patch that contains macros to access register address, width and
  flags (smiapp: Define macros for obtaining properties of register
  definitions).

- Add a patch to remove the old register quirks (smiapp: Remove unused quirk
  register functionality).

- Make register diversion quirk more generic. Access can be now avoided
  altogether; up to the quirk implementation. Quirk functions can perform
  further register accesses. Additional functions are provided for quirk
  functions to avoid checking for further quirks (no quirks for quirks).

- Add a patch to rename smia prefix still used somehwere as smiapp for
  consistency.

This patchset contains PLL quirk improvements to take quirks in some            
implementations into account, as well as make the quirk mechanisms more         
flexible. The driver core is mostly unaffected by these changes.                
                                                                                
The PLL tree calculation itself is concerned less with the factual              
frequencies but focuses on producing multipliers and dividers that are valid    
for the hardware. Quirk flags are primarily used to convert input and output    
parameters.                                                                     
                                                                                
The limit values are also made 64 bits; 64-bit values are needed in more        
generic case when floating point numbers are converted to fixed point.          
                                                                                
There are some miscellaneous fixes as well.                                     


-- 
Kind regards,
Sakari

