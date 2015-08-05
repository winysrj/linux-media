Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35878 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbHEHX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2015 03:23:26 -0400
Received: by oigu206 with SMTP id u206so5000023oig.3
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2015 00:23:25 -0700 (PDT)
MIME-Version: 1.0
From: Eddi De Pieri <eddi@depieri.net>
Date: Wed, 5 Aug 2015 09:23:05 +0200
Message-ID: <CAKdnbx4UB6Ut6=e=ndoJ2i4KGQv0-9KYBotxJACvLKeywN0fmQ@mail.gmail.com>
Subject: missing DIB9000 if MEDIA_SUBDRV_AUTOSELECT in Kconfig
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please can you confirm that is correct the missing of

"select DVB_DIB9000 if MEDIA_SUBDRV_AUTOSELECT" in
"drivers/media/usb/dvb-usb/Kconfig"?

config DVB_USB_DIB0700
        tristate "DiBcom DiB0700 USB DVB devices (see help for
supported devices)"
        depends on DVB_USB
        select DVB_DIB7000P if MEDIA_SUBDRV_AUTOSELECT
        select DVB_DIB7000M if MEDIA_SUBDRV_AUTOSELECT
        select DVB_DIB8000 if MEDIA_SUBDRV_AUTOSELECT
+        select DVB_DIB9000 if MEDIA_SUBDRV_AUTOSELECT
        select DVB_DIB3000MC if MEDIA_SUBDRV_AUTOSELECT
        select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
        select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT


Regards,

Eddi
