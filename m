Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58196 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1ATBoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 20:44:09 -0500
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LFA00ICGSTIBU@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:06 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LFA001QLSTHK0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:06 +0000 (GMT)
Date: Thu, 20 Jan 2011 02:43:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3] Convert SR030PC30 driver to use the control framework and
 the regulator API
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com
Message-id: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

the following patch set is an update for the sr030pc30 sensor driver.
The second patch converts the driver to use the control framework and
adds two new controls as it required relatively little effort to have 
them exported.
The third patch replaces the set_power callback with regulator framework
calls, the RESET and STANDBY gpios are passed as platform data and are
now directly managed in the driver, rather than having the power handling
code repeated in each board setup file. 


The patch series contains:

[PATCH 1/3] sr030pc30: Remove empty s_stream op
[PATCH 2/3] sr030pc30: Use the control framework
[PATCH 3/3] sr030pc30: Add regulator framework support


Regards,
Sylwester



--
Sylwester Nawrocki
Samsung Poland R&D Center

