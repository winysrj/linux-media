Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:38257 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751402AbeFVH7C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 03:59:02 -0400
Date: Fri, 22 Jun 2018 09:51:53 +0200
From: Helmut Grohne <h.grohne@intenta.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-media@vger.kernel.org>
Subject: V4L2_CID_USER_MAX217X_BASE == V4L2_CID_USER_IMX_BASE
Message-ID: <20180622075151.g24iiqfcg5pwbr73@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I found it strange that the macros V4L2_CID_USER_MAX217X_BASE and
V4L2_CID_USER_IMX_BASE have equal value even though each of them state
that they reserved a range. Those reservations look conflicting to me.

The macro V4L2_CID_USER_MAX217X_BASE came first, and
V4L2_CID_USER_IMX_BASE was introduced in e130291212df ("media: Add i.MX
media core driver") with the conflicting assignment (not a merge error).
The authors of that patch mostly make up the recipient list.

Is such a conflict fixable at all given that it resides in a uapi
header?

Helmut
