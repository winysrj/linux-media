Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:59075 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034084AbcJRRTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 13:19:52 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH] kernel-cmd and tabs
Date: Tue, 18 Oct 2016 19:19:27 +0200
Message-Id: <1476811168-2651-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

this patch adress the problems you reported with the kernel-cmd directive [1].
The problem was, that my nested parse didn't handled tabs well (sorry for being
slow-witted this morning ;-).

The patch is based on your git.linuxtv.org/mchehab/experimental.git lkml-books
branch.

[1] https://www.mail-archive.com/linux-doc@vger.kernel.org/msg06828.html

Markus Heiser (1):
  doc-rst: reST-directive kernel-cmd parse with tabs

 Documentation/sphinx/kernel_cmd.py | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

-- 
2.7.4

