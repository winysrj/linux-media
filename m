Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:32935 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZGMLXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 07:23:44 -0400
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KMP0073IWZ8Y6@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jul 2009 20:23:32 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KMP00I0OWZ8WT@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jul 2009 20:23:32 +0900 (KST)
Date: Mon, 13 Jul 2009 20:23:32 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 0/2] radio-si470x: separate usb and i2c interface
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <4A5B1934.6080503@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all

I send the radio-si470x patches worked on http://linuxtv.org/hg/v4l-dvb.

I have a board with Silicon Labs si4709 chip using the i2c interface,
but the radio-si470x is only support usb interface currently. I posted
about separating usb and i2c interface in radio-si470x the past.
http://www.mail-archive.com/linux-media@vger.kernel.org/msg02483.html

Tobias informed me the base code for seperating at 
http://linuxtv.org/hg/~tlorenz/v4l-dvb of Tobias repository in above
mail, i based on it, but it cannot find now at Tobias repository.

The patch 1/2 is for separating common and usb code, and
the patch 2/2 is for supporting si470x i2c interface.

Please review, thank you.
