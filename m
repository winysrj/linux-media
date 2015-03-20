Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:18219 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbCTGym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 02:54:42 -0400
Received: from pla-VB.cisco.com ([10.65.67.170])
	by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t2K6seNh028536
	for <linux-media@vger.kernel.org>; Fri, 20 Mar 2015 06:54:40 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Support for CVT and GTF timings in vivid
Date: Fri, 20 Mar 2015 12:11:44 +0530
Message-Id: <1426833706-7839-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches add support for setting CVT and GTF timings in vivid.

Currently vivid supports V4L2_DV_BT_STD_DMT and V4L2_DV_BT_STD_CEA861
digital video standards which are all discrete monitor timings. So,
there is no support for standards outside of that set. Hans has been
thinking about extending vivid capability to support wider set of 
timings. I have been working with Hans on adding support for CVT/GTF
timings in vivid. Please find the patches for the same.

[PATCH 1/2] vivid: add CVT,GTF standards to vivid dv timings caps
[PATCH 2/2] vivid: add support to set CVT, GTF timings

Please review and share your comments, suggestions.

Regards,
Prashant
