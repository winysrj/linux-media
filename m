Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60946 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2HUS6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 14:58:39 -0400
Received: by bkwj10 with SMTP id j10so48011bkw.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 11:58:38 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: prabhakar.lad@ti.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH] Fix libdvbv5 endianess function for embedded toolchains
Date: Tue, 21 Aug 2012 20:58:21 +0200
Message-Id: <1345575502-3779-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

the following patch fixes compilation of libdvbv5 with the Code Sourcery
ARM toolchain. It replaces the missing be16toh and be32toh with the
available ntohs and ntohl.

IMHO the bswap16/32 macro names should be replaced because the current name
suggests unconditional swap regardless of the host architecture.

Thanks,
Gregor

Gregor Jasny (1):
  libdvbv5: Fix byte swapping for embedded toolchains

 lib/include/descriptors.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.10.4

