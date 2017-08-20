Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33321 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753097AbdHTOgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 10:36:51 -0400
Received: by mail-wr0-f196.google.com with SMTP id 30so1342597wrk.0
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 07:36:50 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: jasmin@anw.at, mchehab@kernel.org
Subject: [PATCH 0/3] media_build: fixes wrt the ddbridge code bump
Date: Sun, 20 Aug 2017 16:36:45 +0200
Message-Id: <20170820143648.27669-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Hans,

these are the patches I've carried around in my media_build fork wrt
ddbridge testing, which obviously should go into upstream, now that
the patches got merged. Things worked pretty well at least up to
(down to) Kernel 3.13 on Ubuntu Trusty, guess some more things need
to be added for even older kernels, but your daily build will probably
tell :) Verified myself against 4.4 (Ubuntu Xenial).

Daniel Scheller (3):
  [media_build] fix pr_fmt patch wrt the ddbridge code bump
  [media_build] patch pci_alloc_irq_vectors() for ddbridge aswell
  [media_build] add compat for __GFP_RETRY_MAYFAIL

 backports/pr_fmt.patch                     |  6 +++---
 backports/v4.7_pci_alloc_irq_vectors.patch | 13 +++++++++++++
 v4l/compat.h                               |  4 ++++
 3 files changed, 20 insertions(+), 3 deletions(-)

-- 
2.13.0
