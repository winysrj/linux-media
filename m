Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37610 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdLLSrB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 13:47:01 -0500
Received: by mail-wm0-f68.google.com with SMTP id f140so633358wmd.2
        for <linux-media@vger.kernel.org>; Tue, 12 Dec 2017 10:47:00 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 0/3] staging/cxd2099: cosmetics, checkpatch fixup
Date: Tue, 12 Dec 2017 19:46:54 +0100
Message-Id: <20171212184657.19730-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

These three small patches make the driver checkpatch-strict clean and
improves a few strings. No functional changes.

Essentially drivers/staging/media/cxd2099/ is now clean, esp.:

$ scripts/checkpatch.pl --strict --file drivers/staging/media/cxd2099/cxd2099.c
  total: 0 errors, 0 warnings, 0 checks, 705 lines checked

$ scripts/checkpatch.pl --strict --file drivers/staging/media/cxd2099/cxd2099.h
  total: 0 errors, 0 warnings, 0 checks, 45 lines checked

The three patches are the outcome of some bigger refactoring WIP.

Daniel Scheller (3):
  [media] staging/cxd2099: fix remaining checkpatch-strict issues
  [media] staging/cxd2099: fix debug message severity
  [media] staging/cxd2099: cosmetics: improve strings

 drivers/staging/media/cxd2099/cxd2099.c | 30 +++++++++++-------------------
 drivers/staging/media/cxd2099/cxd2099.h | 14 +++-----------
 2 files changed, 14 insertions(+), 30 deletions(-)

-- 
2.13.6
