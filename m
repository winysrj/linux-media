Return-path: <mchehab@pedra>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:38794 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab0I3UAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 16:00:10 -0400
Date: Thu, 30 Sep 2010 21:55:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] lirc: Make struct file_operations pointer const
Message-ID: <alpine.DEB.2.00.1009302153210.2434@ayla.of.borg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

struct file_operations was made const in the drivers, but not in struct
lirc_driver:

drivers/staging/lirc/lirc_it87.c:365: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_parallel.c:571: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_serial.c:1073: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_sir.c:482: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_zilog.c:1284: warning: assignment discards qualifiers from pointer target type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/media/lirc_dev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index b1f6066..71a896e 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -139,7 +139,7 @@ struct lirc_driver {
 	struct lirc_buffer *rbuf;
 	int (*set_use_inc) (void *data);
 	void (*set_use_dec) (void *data);
-	struct file_operations *fops;
+	const struct file_operations *fops;
 	struct device *dev;
 	struct module *owner;
 };
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
