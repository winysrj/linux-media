Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58200 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932554AbcJXU6g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 16:58:36 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
        <chehabrafael@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] au0828-video: Fine-tuning for au0828_init_isoc()
Message-ID: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
Date: Mon, 24 Oct 2016 22:58:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Oct 2016 22:52:10 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use kcalloc()
  Delete three error messages for a failed memory allocation
  Move two assignments

 drivers/media/usb/au0828/au0828-video.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

-- 
2.10.1

