Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:37381 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdK0VpR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 16:45:17 -0500
Received: by mail-wr0-f173.google.com with SMTP id k61so27891630wrc.4
        for <linux-media@vger.kernel.org>; Mon, 27 Nov 2017 13:45:17 -0800 (PST)
From: Riccardo Schirone <sirmy15@gmail.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Cc: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCH 0/4] fix some checkpatch style issues in atomisp driver
Date: Mon, 27 Nov 2017 22:44:09 +0100
Message-Id: <20171127214413.10749-1-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes some coding style issues reported by checkpatch.

It is based on next-20171127.

Riccardo Schirone (4):
  staging: add missing blank line after declarations in atomisp-ov5693
  staging: improve comments usage in atomisp-ov5693
  staging: improves comparisons readability in atomisp-ov5693
  staging: fix indentation in atomisp-ov5693

 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 63 +++++++++++++++-------
 1 file changed, 44 insertions(+), 19 deletions(-)

-- 
2.14.3
