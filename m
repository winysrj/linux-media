Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:10272 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0HYIse (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 04:48:34 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L7P00C3E9SESLD0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:14 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L7P007X99SEIA@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:14 +0900 (KST)
Date: Wed, 25 Aug 2010 17:48:14 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 0/3] Fix bug of radio-si470x
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <4C74D8CE.5060207@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch set is to fix bug of si470x common part and i2c driver.

Thanks.

Joonyoung Shim (3):
       radio-si470x: Fix setting of de-emphasis
       radio-si470x: Remove ifdef for RDS
       radio-si470x: Fix error handling of si470x i2c driver

  drivers/media/radio/si470x/radio-si470x-common.c |    8 +-------
  drivers/media/radio/si470x/radio-si470x-i2c.c    |    2 +-
  2 files changed, 2 insertions(+), 8 deletions(-)
