Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out-2.itc.rwth-aachen.de ([134.130.5.47]:49052 "EHLO
        mail-out-2.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932186AbeAIXnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 18:43:37 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        "Michael Krufky" <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 0/2] Remove duplicate driver for MyGica T230C
Date: Wed, 10 Jan 2018 00:33:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <2bff3e5b-1dac-49ad-af6d-6707f4476fe9@rwthex-w2-a.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


In 2017-02, two drivers for the T230C where submitted, but until now
only the one based on the older dvb-usb/cxusb.c driver has been part
of the mainline kernel. As a dvb-usb-v2 driver is preferable, remove
the other driver.

The cxusb.c patch also contained an unrelated change for the T230,
i.e. a correction of the RC model. As this change apparently is
correct, restore it. This has not been tested due to lack of hardware.


Evgeny Plehov (1):
  Revert "[media] dvb-usb-cxusb: Geniatech T230C support"

Stefan Brüns (1):
  [media] cxusb: restore RC_MAP for MyGica T230

 drivers/media/usb/dvb-usb/cxusb.c | 137 --------------------------------------
 1 file changed, 137 deletions(-)

-- 
2.15.1
