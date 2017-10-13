Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:33315 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdJMUdX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 16:33:23 -0400
Subject: Re: [PATCH] build: Remove IDA from lirc_dev
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, david@hardeman.nu
References: <1507926209-9654-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <6709a343-26fa-64c7-f7ac-ed3a99ebc6ef@anw.at>
Date: Fri, 13 Oct 2017 22:33:16 +0200
MIME-Version: 1.0
In-Reply-To: <1507926209-9654-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

With this patch, the media-tree can be compiled back to Kernel 2.6.37.
For 2.6.32 some patches do not apply. I will fix that later.

@David:
Please can you review my changes if I reverted the patch correctly.
"git revert" didn't work, because of the changes in lirc_dev.c.

BR,
   Jasmin
