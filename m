Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34601 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753125AbcHUSXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 14:23:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] Two additional patches for Documentation/conf.py
Date: Sun, 21 Aug 2016 15:23:02 -0300
Message-Id: <cover.1471803675.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch in this series use the type of notice box to color the box,
providing a functionality that it is also used on the HTML theme we use.

The second patch is a fix for a non-fatal error when building LaTeX on
interactive mode.

Mauro Carvalho Chehab (2):
  docs-rst: Use better colors for note/warning/attention boxes
  docs-rst: Fix an warning when in interactive mode

 Documentation/conf.py | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

-- 
2.7.4


