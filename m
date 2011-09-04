Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47433 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab1IDXqK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 19:46:10 -0400
Message-ID: <4E640DBB.8010504@iki.fi>
Date: Mon, 05 Sep 2011 02:46:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko]
 undefined!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka,
Current linux-media make gives error. Any idea what's wrong?


Kernel: arch/x86/boot/bzImage is ready  (#1)
   Building modules, stage 2.
   MODPOST 1907 modules
ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko] 
undefined!
WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


regards
Antti
-- 
http://palosaari.fi/
