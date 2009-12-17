Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45553 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269AbZLQGjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 01:39:49 -0500
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KUS002CKAIALY@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Dec 2009 15:39:47 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KUS00LX0AIAFG@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Dec 2009 15:39:46 +0900 (KST)
Date: Thu, 17 Dec 2009 15:39:47 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Question about the signal of struct v4l2_tuner to set value
To: linux-media@vger.kernel.org
Message-id: <4B29D233.30901@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all.

I wonder about the usage of the signal variable of struct v4l2_tuner. I
have found only to use it to get the signal strength on drivers.

The si470x radio device can set the seek threshold value of
RSSI(Received Signal Strength Indicator) when the device scans the
channels, so if the current RSSI value is low than the seek threshold
value, the device decides the frequency is nonvalidate channel.

So, i need v4l2 interface to set the best seek threshold value and i
want to use the signal of struct v4l2_tuner for it. Can the signal
variable be used to set the value?
