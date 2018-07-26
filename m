Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:46002 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729370AbeGZNPm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 09:15:42 -0400
Received: by mail-qt0-f180.google.com with SMTP id y5-v6so1193683qti.12
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 04:59:12 -0700 (PDT)
MIME-Version: 1.0
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 26 Jul 2018 07:59:00 -0400
Message-ID: <CAOcJUbwCMVn1eD1K8zyJ8dz+B+-BAyXXx1uZq8DzirDg4s_3uw@mail.gmail.com>
Subject: 
To: linux-media <linux-media@vger.kernel.org>
Cc: Brad Love <brad@nextdimension.cc>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        mchehab+samsung@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

The following three patches from Brad Love are urgently needed for
merge ASAP.  One just removes a duplicated PID, so it's not as
important but should be merged ASAP nonetheless.  The other two fix an
OOPS along with broken dual transport streaming operation.  Please
merge ASAP.

The following changes since commit 7ba2eb72f843fb79de1857a39f9a7e8006f8133b:

  media: dib0700: add code comment (2018-07-25 14:55:59 -0400)

are available in the Git repository at:

  ssh://linuxtv.org:/home/mkrufky/git/dvb.git

for you to fetch changes up to f7869d3cd1705c1d7f883d364a1fe52085d219c4:

  em28xx: Remove duplicate PID (2018-07-26 07:42:52 -0400)

----------------------------------------------------------------
Brad Love (3):
      em28xx: Fix dual transport stream operation
      em28xx: Fix DualHD disconnect oops
      em28xx: Remove duplicate PID

 drivers/media/usb/em28xx/em28xx-cards.c | 6 +++---
 drivers/media/usb/em28xx/em28xx-dvb.c   | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)
