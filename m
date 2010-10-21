Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab0JUOMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 10:12:37 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9LECbL6013094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:12:37 -0400
Received: from pedra (vpn-225-164.phx2.redhat.com [10.3.225.164])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9LE9S5D022469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 10:12:36 -0400
Date: Thu, 21 Oct 2010 12:07:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] cx231xx: Fix compilation breakage if DVB is not
 selected
Message-ID: <20101021120745.44578b22@pedra>
In-Reply-To: <cover.1287669886.git.mchehab@redhat.com>
References: <cover.1287669886.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In file included from drivers/media/video/cx231xx/cx231xx-audio.c:40:
drivers/media/video/cx231xx/cx231xx.h:559: error: field ‘frontends’ has incomplete type
make[4]: ** [drivers/media/video/cx231xx/cx231xx-audio.o] Erro 1
make[3]: ** [drivers/media/video/cx231xx] Erro 2
make[2]: ** [drivers/media/video] Erro 2
make[1]: ** [drivers/media] Erro 2
make: ** [drivers] Erro 2

Reported-by: Marcio Araujo Alves <froooozen@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 9c98886..d067df9 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -35,10 +35,7 @@
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/ir-core.h>
-#if defined(CONFIG_VIDEO_CX231XX_DVB) || \
-	defined(CONFIG_VIDEO_CX231XX_DVB_MODULE)
 #include <media/videobuf-dvb.h>
-#endif
 
 #include "cx231xx-reg.h"
 #include "cx231xx-pcb-cfg.h"
-- 
1.7.1


