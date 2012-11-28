Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51827 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2K1PXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 10:23:11 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so7796373lag.19
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 07:23:09 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 28 Nov 2012 10:23:09 -0500
Message-ID: <CAOcJUbzLTOASaHDAgCdFiYtOKoUM4oTEOP3EpbD9EE_zdT2O6w@mail.gmail.com>
Subject: [PULL] au0828: update model matrix | git://linuxtv.org/mkrufky/hauppauge
 voyager-72281
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848:

  [media] dma-mapping: fix dma_common_get_sgtable() conditional
compilation (2012-11-27 09:42:31 -0200)

are available in the git repository at:

  git://linuxtv.org/mkrufky/hauppauge voyager-72281

for you to fetch changes up to 72567f3cfafe31c1612efe52e2893e960cc8dd00:

  au0828: update model matrix entries for 72261, 72271 & 72281
(2012-11-28 09:46:24 -0500)

----------------------------------------------------------------
Michael Krufky (2):
      au0828: add missing model 72281, usb id 2040:7270 to the model matrix
      au0828: update model matrix entries for 72261, 72271 & 72281

 drivers/media/usb/au0828/au0828-cards.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
