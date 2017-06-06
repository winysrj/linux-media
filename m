Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38151 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbdFFNTm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 09:19:42 -0400
Received: by mail-it0-f52.google.com with SMTP id r63so108537472itc.1
        for <linux-media@vger.kernel.org>; Tue, 06 Jun 2017 06:19:36 -0700 (PDT)
MIME-Version: 1.0
From: Steven Toth <stoth@kernellabs.com>
Date: Tue, 6 Jun 2017 09:19:35 -0400
Message-ID: <CALzAhNX3ncfu09k2ZaZ+5x28uNhy2kSCw4swatU89N+kJ=2PoQ@mail.gmail.com>
Subject: [GIT PULL] [PATCH] saa7164: Bug - Double fetch PCIe access condition
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

A single commit.

https://github.com/stoth68000/media-tree/commit/354dd3924a2e43806774953de536257548b5002c

This pull request addresses the concern raised by Pengfei Wang
<wpengfeinudt@gmail.com> via
https://bugzilla.kernel.org/show_bug.cgi?id=195559

I've tested this patch with two different SAA7164 based cards in both
analog and digital television modes for US and Europe, no regressions
were found.

$ git diff --stat master
 drivers/media/pci/saa7164/saa7164-bus.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Thanks!

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
