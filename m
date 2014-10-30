Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34981 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbaJ3UMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:12:55 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Subject: [PATCH v4 00/14] cx231xx: Use muxed i2c adapters instead of custom switching
Date: Thu, 30 Oct 2014 21:12:21 +0100
Message-Id: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This time the series got only small updates from Antti's review.

Additionally I added a patch to no longer directly modify
the content of the port3 switch bit in PWR_CTL_EN (from function cx231xx_set_power_mode).

Now there are two places where I wonder what happens:
1. cx231xx_set_Colibri_For_LowIF writes a fixed number into all 8bit parts of PWR_CTL_EN
   What is this for?
2. I guess, cx231xx_demod_reset should reset the digital demod. For this it should toggle the bits 0 and 1 of PWR_CTL_EN. 
   But instead it touches but 8 and 9.
   Does someone know what this is?

3. Is remembering the last status of the port3 bit working good enough?
   Currently it is only used for the is_tuner hack function.

Regards
Matthias

