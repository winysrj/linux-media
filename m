Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36773 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753790AbdCIWuf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 17:50:35 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH v1 0/7] staging: gc2235: Multiple checkpatch issues
Date: Fri, 10 Mar 2017 04:20:22 +0530
Message-Id: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v1:
  -change the subject of all the patches of the patch-series


simran singhal (7):
  staging: gc2235: Remove unnecessary typecast of c90 int constant
  staging: gc2235: Add blank line after a declaration
  staging: gc2235: Replace NULL with "!"
  staging: gc2235: Remove blank line before '}' and after '{' braces
  staging: gc2235: Remove multiple assignments
  staging: gc2235: Use x instead of x != NULL
  staging: gc2235: Do not use multiple blank lines

 drivers/staging/media/atomisp/i2c/gc2235.c | 32 ++++++++++++++++--------------
 1 file changed, 17 insertions(+), 15 deletions(-)

-- 
2.7.4
