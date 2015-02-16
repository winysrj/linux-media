Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56130 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbbBPMUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 07:20:38 -0500
Date: Mon, 16 Feb 2015 12:18:29 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Recent commit introduces compiler Error in some platforms
Message-ID: <20150216121829.GA23673@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

As can be seen in Han's build log:
http://hverkuil.home.xs4all.nl/logs/Saturday.log

The recent commit bc0c5aa35ac88342831933ca7758ead62d9bae2b introduces a
compiler error in some platforms.

/home/hans/work/build/media_build/v4l/ir-hix5hd2.c: In function 'hix5hd2_ir_config':
/home/hans/work/build/media_build/v4l/ir-hix5hd2.c:95:2: error: implicit declaration of function 'writel_relaxed' [-Werror=implicit-function-declaration]
  writel_relaxed(0x01, priv->base + IR_ENABLE);
  ^

Better than reverting, what would be a good solution for this problem?
I am happy to implment it once I know what is the right direction.

>From what I see that commit mentions that the function is now available from
include/asm-generic/io.h, but this isn't included.

Thanks,
Luis
