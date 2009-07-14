Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:47955 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZGNFLX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 01:11:23 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KMR00HZFAEY4U@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 14:11:22 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KMR004LLAEYBF@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 14:11:22 +0900 (KST)
Date: Tue, 14 Jul 2009 14:11:22 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 0/4] radio-si470x: separate usb and i2c interface
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com, klimov.linux@gmail.com
Message-id: <4A5C137A.2010104@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all

I send the radio-si470x patches worked on http://linuxtv.org/hg/v4l-dvb.
The patches is updated to version 2.

I have a board with Silicon Labs si4709 chip using the i2c interface,
but the radio-si470x is only support usb interface currently. I posted
about separating usb and i2c interface in radio-si470x the past.
http://www.mail-archive.com/linux-media@vger.kernel.org/msg02483.html

Tobias informed me the base code for seperating at 
http://linuxtv.org/hg/~tlorenz/v4l-dvb of Tobias repository in above
mail, i based on it, but it cannot find now at Tobias repository.

The patch 1/4 is for separating common and usb code.
The patch 2/4 is about using dev_* macro instead of printk.
The patch 3/4 is about adding disconnect check function for i2c interface.
The patch 4/4 is for supporting si470x i2c interface.

Please review, thank you.
