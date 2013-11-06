Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53268 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab3KFTZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 14:25:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Michael Piko <michael@piko.com.au>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] Leadtek WinFast DTV Dongle Dual [0413:6a05]
Date: Wed,  6 Nov 2013 21:25:05 +0200
Message-Id: <1383765906-14210-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds new USB ID for Leadtek WinFast DTV Dongle Dual [0413:6a05]
and nothing more.

I have not send that patch earlier as there was no test reports.
Now there seems to be some reports on Wiki:
http://linuxtv.org/wiki/index.php/LinuxTVWiki:Sandbox
http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV_Dual_Dongle

Antti Palosaari (1):
  af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual

 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
1.8.4.2

