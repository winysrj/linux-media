Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:49504 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965242AbeALWfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 17:35:24 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: media: tc358743: clk_disable_unprepare(refclk) missed
Date: Sat, 13 Jan 2018 01:35:03 +0300
Message-Id: <1515796503-21642-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

tc358743_probe_of() enables refclk and disables it on its error paths.
But there is no clk_disable_unprepare(refclk) in tc358743_remove()
and on error paths in tc358743_probe(). Is it a problem?

If we should fix it, is adding struct clk *refclk; to tc358743_state
the reasonable way to keep clk easily available?

Found by Linux Driver Verification project (linuxtesting.org).

--
Alexey Khoroshilov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
