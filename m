Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:24982 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993Ab2EQQ3l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:29:41 -0400
Received: from [192.168.239.74] (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGTcd0006120
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:29:39 +0300
Message-ID: <4FB52770.9000400@maxwell.research.nokia.com>
Date: Thu, 17 May 2012 19:29:36 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH 00/10] SMIA(++) driver improvements, fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset contains a few improvements and fixes to the SMIA++
driver. Perhaps most importantly, it's no longer necessary to use board
code to use the driver: alternatively a clock name can be provided
instead of a function to configure the external clock. The platform data
function to configure the clock will be removed later on when platforms
such as the OMAP 3 allow controlling the clock through the clock framework.

Support for 8-bit raw bayer formats is added, too. There are changes in
quirk handling and 8-bit only reads (based on a quirk flag) for badly
behaving sensors.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
