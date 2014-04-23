Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51484 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbaDWTdh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 15:33:37 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id B1D47202A2
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 22:33:33 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] Smiapp quirk call order and best scaling ratio fixes
Date: Wed, 23 Apr 2014 22:33:56 +0300
Message-Id: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The most important patch is the third one: wrong scaling ratio was selected
in many (or most?) cases due to the wrong signedness of the variable. The
other two have less effect on the functionality.

-- 
Kind regards,
Sakari

