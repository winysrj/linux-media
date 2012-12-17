Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:49725 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab2LQBVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:21:36 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so4253557lag.19
        for <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 17:21:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355707068-25751-1-git-send-email-mkrufky@linuxtv.org>
References: <1355707068-25751-1-git-send-email-mkrufky@linuxtv.org>
Date: Sun, 16 Dec 2012 20:21:34 -0500
Message-ID: <CAOcJUbz5Jj7qPnH+NQ4vd=6BBWPXUwwXxx-H7DqJsUF9Vj7wLA@mail.gmail.com>
Subject: [PULL] tda18271: add missing entries for qam_7 to tda18271_update_std_map()
 and tda18271_dump_std_map()
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please pardon the previous email...

Mauro,

Please merge:

The following changes since commit c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848:

  [media] dma-mapping: fix dma_common_get_sgtable() conditional
compilation (2012-11-27 09:42:31 -0200)

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners tda18271-qam7

for you to fetch changes up to 6554906af8c145b4fa8d4ea1b9c98c20322dd132:

  tda18271: add missing entries for qam_7 to tda18271_update_std_map()
and tda18271_dump_std_map() (2012-12-04 14:14:26 -0500)

----------------------------------------------------------------
Frank Sch�fer (1):
      tda18271: add missing entries for qam_7 to
tda18271_update_std_map() and tda18271_dump_std_map()

 drivers/media/tuners/tda18271-fe.c |    2 ++
 1 file changed, 2 insertions(+)

Cheers,

Mike
