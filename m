Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:25948 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbeEKPGW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:06:22 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, chen.chenchacha@foxmail.com,
        keescook@chromium.org, arvind.yadav.cs@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/3] media: staging: atomisp: 
Date: Fri, 11 May 2018 17:06:15 +0200
Message-Id: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These 3 patches fixes (at least I hope) some issues found in or around
'lm3554_probe()'.

Please review them carefully. I've only compile tested the changes and
I propose them because they sound logical to me.

The first one, return an error code instead of 0 if the call to an
initialisation function fails.
The 2nd one reorders own some label are reached in order to have a logical
flow (first error goes to last label, last error goes to first label)
The 3rd one fix the use 'media_entity_cleanup()'. If this one is correct,
some other drivers will need to be fixed the same way.  

Christophe JAILLET (3):
  media: staging: atomisp: Return an error code in case
    of error in 'lm3554_probe()'
  media: staging: atomisp: Fix an error handling path in
    'lm3554_probe()'
  media: staging: atomisp: Fix usage of 'media_entity_cleanup()'

 .../media/atomisp/i2c/atomisp-lm3554.c        | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

-- 
2.17.0
