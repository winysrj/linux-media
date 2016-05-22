Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34985 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbcEVQMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 12:12:18 -0400
Received: by mail-wm0-f65.google.com with SMTP id f75so2549700wmf.2
        for <linux-media@vger.kernel.org>; Sun, 22 May 2016 09:12:18 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Subject: rtl28xxu: improve DVB-frontend and tuner auto-selection
Date: Sun, 22 May 2016 18:12:05 +0200
Message-Id: <1463933527-11690-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

my "Astrometa AMDVB-T2 v2" is not working on Arch Linux because their
kernel config does not select CONFIG_DVB_MN88473. This is because the
maintainers simply rely on MEDIA_SUBDRV_AUTOSELECT to choose the
required drivers.

This patchset depends on Antti Palosaari's patch
"mn88472: move out of staging to media" because we will now
automatically enable CONFIG_DVB_MN88472 when CONFIG_DVB_USB_RTL28XXU
is enabled.


