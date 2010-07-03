Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60791 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab0GCCcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jul 2010 22:32:17 -0400
Received: by ewy23 with SMTP id 23so1186981ewy.19
        for <linux-media@vger.kernel.org>; Fri, 02 Jul 2010 19:32:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimQqT99icH6wGhyizm-Zymg_wNrLhxS4yqGo1Wu@mail.gmail.com>
References: <AANLkTimQqT99icH6wGhyizm-Zymg_wNrLhxS4yqGo1Wu@mail.gmail.com>
Date: Sat, 3 Jul 2010 03:32:15 +0100
Message-ID: <AANLkTilBXOV-7d4mOtbwfZdiAy9qiWZiVB-aHR7x0OPm@mail.gmail.com>
Subject: Fwd: Firmware for HVR-1110
From: JD <jdg8tb@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm confused as to what firmware in needed for the HVR-1110.

Scouring the web, everywhere claims that the dvb-fe-tda10046 is
required; however, dmesg logs show that this fails to be uploaded, and
instead it is looking for dvb-fe-tda-10048:

If I use tda-10048 then this seems to successfully loaded, but I am
unable to find any channels with a scan;  the dvb nodes within /dev/
are created and modules loaded, but dvbscan fails to tune.

------
dmesg
--------
$ dmesg |grep firmware
tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
saa7134 0000:03:04.0: firmware: requesting dvb-fe-tda10048-1.0.fw
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
tda10048_firmware_upload: firmware uploaded

Any tips?
Thanks.
