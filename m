Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37474 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab2CZNNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:13:53 -0400
Received: by gghe5 with SMTP id e5so3751193ggh.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:13:53 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Mar 2012 10:13:52 -0300
Message-ID: <CALF0-+Wt1KzjgggO=ESJ-cBs6Gk5PK0-nazsx52qhW3UUfqNKw@mail.gmail.com>
Subject: [PATCH 0/5] Make em28xx-input.c a separate module
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Rui Salvaterra <rsalvaterra@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Gianluca Gennari <gennarone@gmail.com>,
	=?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset isolates em28xx-input code and turns it
into a module, as suggested by Mauro [1].

Contrary to my initial expectations, the patch produces
code that's actually cleaner and a slightly less spaghetti.

I've tried to make the whole change as clear as possible
by splitting it into several patches.
This was done to ease the maintainer job and also
in the hope that someone cares to review and provide feeback.

As I don't have em28xx hardware, I did virtually no test at all so :(

 drivers/media/video/em28xx/Kconfig        |    4 +-
 drivers/media/video/em28xx/Makefile       |    5 +-
 drivers/media/video/em28xx/em28xx-cards.c |   66 +--------
 drivers/media/video/em28xx/em28xx-core.c  |    3 +
 drivers/media/video/em28xx/em28xx-i2c.c   |    3 -
 drivers/media/video/em28xx/em28xx-input.c |  250 +++++++++++++++++++----------
 drivers/media/video/em28xx/em28xx.h       |   32 +----
 7 files changed, 175 insertions(+), 188 deletions(-)

[1] http://www.spinics.net/lists/linux-media/msg45416.html

Regards,
Ezequiel.
