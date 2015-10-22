Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:36683 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbbJVES7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2015 00:18:59 -0400
Received: by ykba4 with SMTP id a4so65361747ykb.3
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2015 21:18:58 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Oct 2015 12:18:58 +0800
Message-ID: <CABUpJt-mTeKkOnhk-ADv-5TJqhx-tRwPoKOQ2a7GJTM34Jz2Eg@mail.gmail.com>
Subject: [PATCH] tv tuner max2165 driver: extend frequency range
From: Walter Cheuk <wwycheuk@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the frequency range to cover Hong Kong's digital TV
broadcasting, which should be the whole UHF; RTHK TV uses 802MHz and
is not covered currently. Tested on my TV tuner card "MyGica X8558
Pro".

Signed-off-by: Walter Cheuk <wwycheuk@gmail.com>

---

--- media/drivers/media/tuners/max2165.c.orig 2015-10-22
12:01:24.867254181 +0800
+++ media/drivers/media/tuners/max2165.c 2015-10-22 12:02:05.706640982 +0800
@@ -385,7 +385,7 @@ static const struct dvb_tuner_ops max216
  .info = {
  .name           = "Maxim MAX2165",
  .frequency_min  = 470000000,
- .frequency_max  = 780000000,
+ .frequency_max  = 868000000,
  .frequency_step =     50000,
  },
