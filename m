Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.abbadie.fr ([37.187.122.32]:54503 "EHLO mail.abbadie.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938778AbcJSUrc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 16:47:32 -0400
From: Jean-Baptiste Abbadie <jb@abbadie.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Cc: Jean-Baptiste Abbadie <jb@abbadie.fr>
Subject: [PATCH 0/3]  media: radio-bcm2048: multiple small cleanups
Date: Wed, 19 Oct 2016 22:47:11 +0200
Message-Id: <20161019204714.11645-1-jb@abbadie.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a series of minor patches to fix checkpatch.pl issues.

Regards,
Jean-Baptiste

Jean-Baptiste Abbadie (3):
  Staging: media: radio-bcm2048: Fix symbolic permissions
  Staging: media: radio-bcm2048: Fix indentation
  Staging: media: radio-bcm2048: Remove FSF address from GPL notice

 drivers/staging/media/bcm2048/radio-bcm2048.c | 66 +++++++++++++--------------
 1 file changed, 31 insertions(+), 35 deletions(-)

-- 
2.10.0

