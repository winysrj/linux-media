Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:50904 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3GYNKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:10:30 -0400
Received: by mail-bk0-f54.google.com with SMTP id it19so677918bkc.13
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 06:10:28 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 0/4] v4l-utils: Some fixes for Coverity issues
Date: Thu, 25 Jul 2013 15:09:30 +0200
Message-Id: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

the following patches fix issues that the Coverity static analyzer found
in v4l-utils.

Please review.

Thanks,
Gregor

Gregor Jasny (4):
  xc3082: Fix use after free in free_firmware()
  libdvbv5: Fix reallocation in parse_lcn
  rds-ctl: Always terminate strings properly
  libdvbv5: Fix copy and paste error in parse_service()

 lib/libdvbv5/descriptors.c            |  6 +++---
 utils/rds-ctl/rds-ctl.cpp             | 14 +++++++-------
 utils/xc3028-firmware/firmware-tool.c |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.8.3.2

