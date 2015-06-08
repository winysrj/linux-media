Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:53515 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbFHNfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 09:35:48 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
	by ni.piap.pl (Postfix) with ESMTP id 63085440102
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2015 15:30:17 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Subject: A few SOLO6x10 patches.
Date: Mon, 08 Jun 2015 15:30:17 +0200
Message-ID: <m3a8waxr86.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm attaching a few patches to SOLO6x10 video frame grabber driver.
Nothing out of ordinary, an audio bug fix (nobody using SOLO with
audio?), an rmmod-related panic and the register access "optimization".
Feel free to pick up what you want.

The remaining issue is incorrect SDRAM size reported in certain cases.
I still have to investigate it a bit.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
