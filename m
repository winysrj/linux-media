Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54879 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbcH3XVF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 19:21:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 0/3] Fix kernel-doc parser for typedef functions
Date: Tue, 30 Aug 2016 20:20:56 -0300
Message-Id: <cover.1472598859.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kernel-doc parser has two issues when handling typedef functions:

1) its parse is incomplete;
2) it causes warnings when a typedef is used as a function argument.

This series partially addresses (1), adding one extra syntax for the parser.
I'm pretty sure that the parser is still incomplete and that we'll get some other
places where it fails.

Jon,

My plan is to apply the last patch on my tree, together with a series of
patches that I'm writing to fix the warnings on nitpick mode.

The other two patches better fit on your tree, IMHO.

Mauro Carvalho Chehab (3):
  docs-rst: improve typedef parser
  docs-rst: kernel-doc: fix typedef output in RST format
  [media] v4l2-dv-timings.h: let kernel-doc parte the typedef argument

 include/media/v4l2-dv-timings.h |  4 ++--
 scripts/kernel-doc              | 36 ++++++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 12 deletions(-)

-- 
2.7.4


