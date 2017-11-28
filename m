Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:46017 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754315AbdK1Uke (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 15:40:34 -0500
Received: by mail-wr0-f172.google.com with SMTP id h1so1334134wre.12
        for <linux-media@vger.kernel.org>; Tue, 28 Nov 2017 12:40:34 -0800 (PST)
From: Riccardo Schirone <sirmy15@gmail.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Cc: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCHv2 0/4] fix some checkpatch style issues in atomisp driver
Date: Tue, 28 Nov 2017 21:40:00 +0100
Message-Id: <20171128204004.9345-1-sirmy15@gmail.com>
In-Reply-To: <20171127214413.10749-1-sirmy15@gmail.com>
References: <20171127214413.10749-1-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes some coding style issues in atomisp driver
reported by checkpatch, like: missing blank lines after declarations,
comments style, comparisons and indentation.

It is based on next-20171128.

Changes since v1:
 - Add commit message to first patch as reported by Jacopo Mondi
   <jacopo@jmondi.org>

Riccardo Schirone (4):
  staging: add missing blank line after declarations in atomisp-ov5693
  staging: improve comments usage in atomisp-ov5693
  staging: improves comparisons readability in atomisp-ov5693
  staging: fix indentation in atomisp-ov5693

 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 63 +++++++++++++++-------
 1 file changed, 44 insertions(+), 19 deletions(-)

-- 
2.14.3
