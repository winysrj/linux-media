Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33642 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0IEVuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 17:50:20 -0400
Received: by iwn5 with SMTP id 5so3587880iwn.19
        for <linux-media@vger.kernel.org>; Sun, 05 Sep 2010 14:50:19 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Sep 2010 00:50:19 +0300
Message-ID: <AANLkTi=2nkH8+nS2_G_GEDONxZbXfFtsPW6Wy-TWEj9O@mail.gmail.com>
Subject: Cannot get Hauppauge HVR-1200 to work
From: "Alexander (Sasha) Sirotkin" <sasha.sirotkin@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

I cannot get Hauppauge HVR-1200 to work. It is recognized correctly
and the driver, including firmware, is being loaded. However, there
are some errors:

[   36.320282] DVB: registering new adapter (saa7133[0])
[   36.320290] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[   36.668044] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[   36.668060] saa7134 0000:01:05.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[   37.119606] tda10048_firmware_upload: firmware read 24878 bytes.
[   37.119615] tda10048_firmware_upload: firmware uploading
[   41.252047] tda10048_firmware_upload: firmware uploaded
[   42.389045] tda18271_write_regs: ERROR: i2c_transfer returned: -5
[   42.389056] tda18271_init: error -5 on line 805
[   42.389067] tda18271_tune: error -5 on line 867
[   42.389073] tda18271_set_analog_params: error -5 on line 1004
[  353.877042] tda18271_write_regs: ERROR: i2c_transfer returned: -5
[  353.877054] tda18271_init: error -5 on line 805
[  353.877060] tda18271_tune: error -5 on line 867
[  353.877065] tda18271_set_analog_params: error -5 on line 1004

The problem, of course, is not the error message per se, but the fact
that I cannot tune to any station:

w_scan -c IL
...
ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!


Any suggestions ?
