Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:49338 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750879AbcHSJRs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 05:17:48 -0400
Subject: [PATCH 0/2] uvc_v4l2: Fine-tuning for uvc_ioctl_ctrl_map()
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <95aa5fcd-8610-debc-70b0-30b2ed3302d2@users.sourceforge.net>
Date: Fri, 19 Aug 2016 11:17:32 +0200
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 19 Aug 2016 11:11:01 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use memdup_user() rather than duplicating its implementation
  One function call less after error detection

 drivers/media/usb/uvc/uvc_v4l2.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

-- 
2.9.3

