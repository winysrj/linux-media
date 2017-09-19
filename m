Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60504 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750895AbdISSo4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 14:44:56 -0400
To: linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Sims <jonathan.625266@earthlink.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] HD PVR USB: Adjustments for two function
 implementations
Message-ID: <82d14066-5816-111c-9d21-f6a439e559c1@users.sourceforge.net>
Date: Tue, 19 Sep 2017 20:44:24 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 19 Sep 2017 20:21:23 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete three error messages for a failed memory allocation
  Improve a size determination in hdpvr_alloc_buffers()
  Return an error code only as a constant in hdpvr_alloc_buffers()

 drivers/media/usb/hdpvr/hdpvr-core.c  |  8 ++------
 drivers/media/usb/hdpvr/hdpvr-video.c | 11 ++++-------
 2 files changed, 6 insertions(+), 13 deletions(-)

-- 
2.14.1
