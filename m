Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:48896 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2KBNJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Nov 2012 09:09:51 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 0/4] Speedup vivi
Date: Fri,  2 Nov 2012 17:10:29 +0400
Message-Id: <cover.1351861552.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello up there. I was trying to use vivi to generate multiple video streams for
my test-lab environment on atom system and noticed it wastes a lot of cpu.

Please apply some optimization patches.

Thanks,
Kirill

Kirill Smelkov (4):
  [media] vivi: Optimize gen_text()
  [media] vivi: vivi_dev->line[] was not aligned
  [media] vivi: Move computations out of vivi_fillbuf linecopy loop
  [media] vivi: Optimize precalculate_line()

 drivers/media/platform/vivi.c | 94 ++++++++++++++++++++++++++++++-------------
 1 file changed, 65 insertions(+), 29 deletions(-)

-- 
1.8.0.316.g291341c

