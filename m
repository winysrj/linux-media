Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:57380 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729704AbeKLK0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 05:26:17 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: [PATCH v2 0/11] media: make Marvell camera work on DT-based OLPC XO-1.75
Date: Mon, 12 Nov 2018 01:35:09 +0100
Message-Id: <20181112003520.577592-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this patch set somewhat modernizes the Marvel MMP2 CCIC driver. Notably,
it ports it from the platform data (which seems unused as the board
support code never made it) to devicetree.

At the core of the rework is the move to asynchronous sensor discovery
and clock management with the standard clock framework. There are also
some straightforward fixes for bitrotten parts.

There's probably still room for improvement, but as it is, it seems to
work well on OLPC XO-1.75 and doesn't break OLPC XO-1 (I've tested on
both platforms).

Changes since v1:
- "marvell-ccic: drop ctlr_reset()" patch was replaced with a
  straightforward revert of the commit that added ctlr_reset() along with=
 an
  explanation in commit message.
- Added collected Acks
- Other changes are noted in individial patches

Thanks,
Lubo
