Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:45040 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754457AbeDBWY3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 18:24:29 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
Cc: Nasser Afshin <Afshin.Nasser@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] media: i2c: tvp5150: resolve checkpatch errors
Date: Tue,  3 Apr 2018 02:53:16 +0430
Message-Id: <20180402222322.30385-1-Afshin.Nasser@gmail.com>
In-Reply-To: <d5e8dbe4-b68b-ac4e-0076-a3ee995f8327@embeddedor.com>
References: <d5e8dbe4-b68b-ac4e-0076-a3ee995f8327@embeddedor.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series tries to resolve some checkpatch.pl errors and warnings.

Nasser Afshin (4):
  media: i2c: tvp5150: Add a space after commas
  media: i2c: tvp5150: Use the correct comment style
  media: i2c: tvp5150: Fix open brace placement codding style
  media: i2c: tvp5150: Use parentheses for sizeof

Changes in v2:
- Explicitly mention the warning/error
- Separate open brace placement style error from comment style warning.

 drivers/media/i2c/tvp5150.c | 159 +++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 77 deletions(-)

-- 
2.15.0
