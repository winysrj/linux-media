Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:4738 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbbDHNIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 09:08:40 -0400
Received: from pla-VB.cisco.com ([10.142.61.66])
	by bgl-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id t38CwblV029145
	for <linux-media@vger.kernel.org>; Wed, 8 Apr 2015 12:58:37 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: support for interlaced format in detect cvt/gtf 
Date: Wed,  8 Apr 2015 18:27:56 +0530
Message-Id: <1428497877-6593-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While I was working with Hans on adding cvt/gtf modeline calculations
in v4l2 utils, we thought that it would be nice to extend the detect
cvt/gtf functionality in v4l2-dv-timings to handle interlaced format.

Please find the patch for the same.

Regards,
Prashant
