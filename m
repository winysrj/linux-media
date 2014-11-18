Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46488 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750788AbaKRFkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:40:37 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl
Subject: [REVIEW PATCH v2 0/5] Add V4L2_SEL_TGT_NATIVE_SIZE target
Date: Tue, 18 Nov 2014 07:40:15 +0200
Message-Id: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This small set cleans up sub-device format documentation --- the                
documentation noted the source format is used to configure scaling, which       
was contradicting what was said right after on the selections on                
sub-devices. This part was written before the selections interface.             
                                                                                
The two latter patches create a V4L2_SEL_TGT_NATIVE_SIZE target which is        
used in the smiapp driver. The CROP_BOUNDS target is still supported as         
compatibility means.                                                            

since v2:

- Document that left and top are zero for the native size target.

- Add a patch to zero left and top in the smiapp driver.

- Add a patch to document native size setting input and output capability
  flags.

-- 
Kind regards,
Sakari

