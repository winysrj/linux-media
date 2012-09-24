Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57511 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2IXLhe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:37:34 -0400
Received: by weyt9 with SMTP id t9so144083wey.19
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 04:37:33 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: mchehab@redhat.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 0/3] Fix several warnings on new fc2580 tuner driver
Date: Mon, 24 Sep 2012 13:37:15 +0200
Message-Id: <1348486638-31169-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
this small patch series fixes the warnings generated compiling the new fc2580
tuner driver on a Ubuntu system with the 2.6.32-43 32 bit kernel and GCC 4.4.3.

Compile tested only.

Best regards,
Gianluca Gennari

Gianluca Gennari (3):
  fc2580: define const as UL to silence a warning
  fc2580: silence uninitialized variable warning
  fc2580: use macro for 64 bit division

 drivers/media/tuners/fc2580.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

