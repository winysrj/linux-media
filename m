Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:57819 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752620AbdLIAMt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 19:12:49 -0500
To: Hans Verkuil <hverkuil@xs4all.nl>
From: "Jasmin J." <jasmin@anw.at>
Subject: What to do with input_enable_softrepeat in av7110_ir.c
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <8b989e65-a514-ad29-0210-23a7973bbafd@anw.at>
Date: Sat, 9 Dec 2017 01:12:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans!

I try to fix the compilation for Kernel 3.13 (the kernel I use on my VDR).

In commit 5aeaa3e668de0782d1502f3d5751e2266a251d7c the timer handling in
the driver has been changed and now it uses "input_enable_softrepeat". This
function has been added with Kernel 4.4.

I tried to define "input_enable_softrepeat" in "v4l/compat.h", but it requires
"input_repeat_key", which is a static function in "input.c".

I see this solutions:
1) Revert commit 5aeaa3e668de0782d1502f3d5751e2266a251d7c with a new patch for
   Kernels older than 4.4.
2) Disable the  CONFIG_DVB_AV7110_IR, but this driver is available since
   2008. So there might be a lot of people unhappy.
3) Hans looks into this and has another clever idea how to solve that.

I prefer 1) for a quick solution.

BR,
   Jasmin
