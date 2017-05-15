Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35952 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965046AbdEOTmn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 15:42:43 -0400
Received: by mail-wm0-f65.google.com with SMTP id u65so30694432wmu.3
        for <linux-media@vger.kernel.org>; Mon, 15 May 2017 12:42:43 -0700 (PDT)
From: Ricardo Silva <rjpdasilva@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Ricardo Silva <rjpdasilva@gmail.com>
Subject: [PATCH 0/5] staging: media: lirc: Fix several checkpatch issues
Date: Mon, 15 May 2017 20:40:11 +0100
Message-Id: <20170515194016.10246-1-rjpdasilva@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is intended to fix several checkpatch issues (from
CHECK level) found on lirc_zilog.c:

The 1st patch focus on whitespace related fixes.
The 2nd patch fixes NULL comparisons style.
The 3rd patch is for using __func__ in logging functions that are to
trace the function's name, instead of writing down the actual function
name.
The 4th patch changes use of sizeof(struct s) to sizeof(*s_ptr) instead.
Finally, the 5th patch fixes unbalanced braces around if/else
statements.

All checks were fixed, except for the following (and why):

 * CHECK: "Do not include the paragraph about writing to the Free
   Software Foundation...", in the file's header.
   Didn't want to mess with the license notice, unless given explicit
   permission.

 * CHECK: "struct mutex definition without comment", for the ir_lock
   mutex from struct IR. I understand the mutex is there to serialize
   access to the i2c bus but felt hesitant about adding such comment,
   due to lack of deeper knowledge about the driver.

 * CHECK: "Please don't use multiple blank lines". Two instances of
   these were left because acting as logical code blocks separators
   (separating vars declarations from functions, etc.). They seem
   intended for readability purposes.

 * CHECK: "Alignment should match open parenthesis", unchanged because
   makes the code more readable.

 * CHECK: "usleep_range is preferred over udelay".
   Wouldn't know which range to use, due to lack of deeper knowledge
   about the module.

 * CHECK: "ENOSYS means 'invalid syscall nr' and nothing else", in some
   of the module's ioctl function return paths. I believe correct return
   value here would be -ENOTTY, but had some doubts about doing the
   change, as this could break userspace. Will gladly do the change if
   it's OK.

Please advise if it's ok to go ahead and fix these remaining checks.

Ricardo Silva (5):
  staging: media: lirc: Fix whitespace style checks
  staging: media: lirc: Fix NULL comparisons style
  staging: media: lirc: Use __func__ for logging function name
  staging: media: lirc: Use sizeof(*p) instead of sizeof(struct P)
  staging: media: lirc: Fix unbalanced braces around if/else

 drivers/staging/media/lirc/lirc_zilog.c | 110 ++++++++++++++++----------------
 1 file changed, 56 insertions(+), 54 deletions(-)

-- 
2.12.2
