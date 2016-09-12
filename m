Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36604 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbcILXDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 19:03:10 -0400
Received: by mail-lf0-f50.google.com with SMTP id g62so97918953lfe.3
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2016 16:03:09 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, hans.verkuil@cisco.com, Julia.Lawall@lip6.fr
Cc: andrey_utkin@fastmail.com, maintainers@bluecherrydvr.com,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH 0/2] [media] tw5864 constify some structures
Date: Tue, 13 Sep 2016 02:02:36 +0300
Message-Id: <20160912230238.2302-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tw5864 is a recently submitted driver and it is currently present only
in media tree.

Recent patches submitted by Julia Lawall urged me to make similar
changes in this driver.

Andrey Utkin (2):
  [media] tw5864: constify vb2_ops structure
  [media] tw5864: constify struct video_device template

 drivers/media/pci/tw5864/tw5864-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.9.2

