Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755775AbcLNNSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 08:18:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [v4l-utils PATCH 0/3] Add support for LNBfs with more than 2 LO
Date: Wed, 14 Dec 2016 11:18:32 -0200
Message-Id: <20161214131835.11259-1-mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When dvb-sat was written, it assumed that the LNBf entries would have
only 2 local oscilators, as this is what other tools did.

However, there are some widely LNBf models used in Brazil more local
oscilators, meant to be used on multipoint arrangements.

Add support for them.

Please notice that this change breaks the libdvbv5 API. Not sure how
to handle this incompatibility. That's basically why I'm not commiting
it directly.

Suggestions?

Mauro Carvalho Chehab (3):
  dvb-sat: embeed most stuff internally at struct LNBf
  dvb-sat: change the LNBf logic to make it more generic
  dvb-sat: add support for several BrasilSat LNBf models

 lib/include/libdvbv5/dvb-sat.h |  39 ++---
 lib/libdvbv5/dvb-fe.c          |   5 +-
 lib/libdvbv5/dvb-sat.c         | 340 +++++++++++++++++++++++++++--------------
 3 files changed, 244 insertions(+), 140 deletions(-)

-- 
2.9.3

