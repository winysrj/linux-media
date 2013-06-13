Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:33628 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab3FMVm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 17:42:57 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] tea575x: Move from sound to media
Date: Thu, 13 Jun 2013 23:42:27 +0200
Cc: alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306132342.28143.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
TEA575x is neither a sound device nor an i2c device. Let's finally move it 
from sound/i2c/other to drivers/media/radio.

Tested with snd-es1968, snd-fm801 and radio-sf16fmr2.

I guess the Kconfig dependencies are not correct.

-- 
Ondrej Zary
