Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57016 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbALAh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 19:37:56 -0500
Received: by mail-lb0-f175.google.com with SMTP id z11so15349418lbi.6
        for <linux-media@vger.kernel.org>; Sun, 11 Jan 2015 16:37:54 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 11 Jan 2015 19:37:54 -0500
Message-ID: <CAOcJUbwz24NK8xUFL3qwpkbQykkt-SjghyucnAQMQr6v5XraKw@mail.gmail.com>
Subject: [PULL] git://git.linuxtv.org/mkrufky/dvb lgdt3305 - add support for
 fixed tp clock mode
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for
removal (2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/dvb lgdt3305

for you to fetch changes up to 85796f7c9a2c59ebf5e8a94384fa827aa3ce3e98:

  lgdt3305: add support for fixed tp clock mode (2014-12-21 16:54:55 -0500)

----------------------------------------------------------------
Michael Ira Krufky (2):
      lgdt3305: we only need to pass state into lgdt3305_mpeg_mode_polarity()
      lgdt3305: add support for fixed tp clock mode

 drivers/media/dvb-frontends/lgdt3305.c | 17 ++++++++---------
 drivers/media/dvb-frontends/lgdt3305.h |  6 ++++++
 2 files changed, 14 insertions(+), 9 deletions(-)
