Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55430 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZCTFSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 01:18:54 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 20 Mar 2009 10:48:44 +0530
Subject: [PATCH 0/3] V4L2 driver for OMAP2/3 with new CIDs.
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02FAF6EC42@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,
I will be posting series of three patches for the V4L2 driver on the OMAP2/3 DSS.

Patch 1 -
This is the second revision of the patch.  
Documentation added for the following new CIDs and bit fields added in V4L2 framework.

V4L2_CID_BG_COLOR: Added new CID for setting of the back ground color on the output device.
V4L2_CID_ROTATION: Added new CID for setting up of the rotation on the device.
Both of the above ioctls are discussed in detail.  

V4L2_FBUF_FLAG_SRC_CHROMAKEY: Added the flags bit field to the flags field of the v4l2_framebuffer structure for supporting the source chroma keying.  It's exactly opposite of the chroma keying supported with the flag V4L2_FBUF_FLAG_CHROMAKEY.

V4L2_FBUF_CAP_SRC_CHROMAKEY:  Added the capability bit field for the capability field of the v4l2_framebuffer structure.

Documentation change related to the new bit field for the source chroma keying is new from the previous version.

Patch 2 - 
Added New Control IDs for OMAP class of Devices as discussed above.  This is the third revision of the patch of adding the new control IDs and bit fields.

V4L2_FBUF_CAP_SRC_CHROMAKEY and V4L2_FBUF_FLAG_SRC_CHROMAKEY are newly added compared to previous revision of patch.

New Ioctl for programming the color space conversion matrix is dropped from this patch as the accompanying driver with this patch is not still having implementation for the same.  Related documentation is also removed. 

I will submit a separate patch for that with the necessary changes in driver to support the programming of the color space conversion. Some changes are required in DSS2 library also for doing the same.

Patch 3 -
This is a review patch since the DSS2 library is still to be accepted in community 
This is the third revision of the patch. 
This patch contains the V4L2 driver on the OMAP3 DSS2 using all of the above newly implemented CIDS and bit fields.  Following are the changes in the driver compared to the previous version.

1.  Added the chroma keying support.
2.  Added alpha blending support.
3.  Minor community comment fixed.
4.  Ported to work with Tomi's latest DSS2 library with minor modification in DSS2 library.  Path to Tomi's DSS2 library is http://www.bat.org/~tomba/git/linux-omap-dss.git/ commit id bc6dc4c7fabb8ba3bfe637a6c5dc271595a1bef6

All the comments and inputs are welcomed.

Thanks and Regards
Hardik Shah

 

