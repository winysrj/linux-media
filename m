Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:57954 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3G1UCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jul 2013 16:02:21 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 0/2] tea575x: Move from sound to media
Date: Sun, 28 Jul 2013 22:01:42 +0200
Message-Id: <1375041704-17928-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,
TEA575x is neither a sound device nor an i2c device. Let's finally move it 
from sound/i2c/other to drivers/media/radio.

Tested with snd-es1968, snd-fm801 and radio-sf16fmr2.

-- 
Ondrej Zary
