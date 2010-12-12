Return-path: <mchehab@gaivota>
Received: from mail-iw0-f170.google.com ([209.85.214.170]:64900 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0LLBq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Dec 2010 20:46:57 -0500
Received: by iwn6 with SMTP id 6so7305259iwn.1
        for <linux-media@vger.kernel.org>; Sat, 11 Dec 2010 17:46:56 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 12 Dec 2010 02:40:38 +0100
Message-ID: <AANLkTik6EnV_OcP7sHm3P4NJRFFqdx1J+69ZqhVOY4jM@mail.gmail.com>
Subject: Firmware request
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello list!

I am getting some firmware request on a MythTV system dmesg:

[  944.754753] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...
[  944.754766] cx23885 0000:02:00.0: firmware: requesting dvb-fe-ds3000.fw
[  944.775896] ds3000_firmware_ondemand: Waiting for firmware upload(2)...

I have a Tevii S470 DVB-S2 tuner, is this normal? I have the firmware
on /lib/firmware:

ls -l /lib/firmware/ | grep ds3000
-rw-r--r-- 1 root root  8192 dic  6 14:54 dvb-fe-ds3000.fw

I am getting also some player problems, I don't know if it is for the
firmware request.

Thanks for all your help and best regards.

-- 
Josu Lazkano
