Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63140 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031048Ab2CVRAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 13:00:24 -0400
Received: by qcqw6 with SMTP id w6so1439957qcq.19
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2012 10:00:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Mar 2012 13:00:21 -0400
Message-ID: <CAHAyoxxRQUecyVf-M52htoDYdF7b+xTJy27ctBm68Xgw20_XMw@mail.gmail.com>
Subject: [GIT PULL] git://linuxtv.org/mkrufky/hauppauge.git windham-ids
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge this small patch for a USB ID addition

The following changes since commit f92c97c8bd77992ff8bd6ef29a23dc82dca799cb:
  Mauro Carvalho Chehab (1):
        [media] update CARDLIST.em28xx

are available in the git repository at:

  git://linuxtv.org/mkrufky/hauppauge.git windham-ids

Michael Krufky (1):
      smsusb: add autodetection support for USB ID 2040:c0a0

 drivers/media/dvb/siano/smsusb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

commit 78d6887d1ace284e4c6421b776b7b99a1652599d
Author: Michael Krufky <mkrufky@linuxtv.org>
Date:   Thu Mar 22 12:55:05 2012 -0400

    smsusb: add autodetection support for USB ID 2040:c0a0

    Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/smsusb.c
index b1fe513..63c004a 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -542,6 +542,8 @@ static const struct usb_device_id
smsusb_id_table[] __devinitconst = {
                .driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
        { USB_DEVICE(0x2040, 0xc090),
                .driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+       { USB_DEVICE(0x2040, 0xc0a0),
+               .driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
        { } /* Terminating entry */
        };

Cheers,

Mike
