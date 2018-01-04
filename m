Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:54444 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbeADKcj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 05:32:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] media: dvb: fix DVB_MMAP dependency
Date: Thu,  4 Jan 2018 11:31:31 +0100
Message-Id: <20180104103215.15591-2-arnd@arndb.de>
In-Reply-To: <20180104103215.15591-1-arnd@arndb.de>
References: <20180104103215.15591-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enabling CONFIG_DVB_MMAP without CONFIG_VIDEOBUF2_VMALLOC results
in a link error:

drivers/media/dvb-core/dvb_vb2.o: In function `_stop_streaming':
dvb_vb2.c:(.text+0x894): undefined reference to `vb2_buffer_done'
drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_init':
dvb_vb2.c:(.text+0xbec): undefined reference to `vb2_vmalloc_memops'
dvb_vb2.c:(.text+0xc4c): undefined reference to `vb2_core_queue_init'
drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_release':
dvb_vb2.c:(.text+0xe14): undefined reference to `vb2_core_queue_release'
drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_stream_on':
dvb_vb2.c:(.text+0xeb8): undefined reference to `vb2_core_streamon'
drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_stream_off':
dvb_vb2.c:(.text+0xfe8): undefined reference to `vb2_core_streamoff'
drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_fill_buffer':
dvb_vb2.c:(.text+0x13ec): undefined reference to `vb2_plane_vaddr'
dvb_vb2.c:(.text+0x149c): undefined reference to `vb2_buffer_done'

This adds a 'select' statement for it, plus a dependency that
ensures that videobuf2 in turn works, as it in turn depends on
VIDEO_V4L2 to link, and that must not be a module if videobuf2
is built-in.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3f69b948d102..d1be86ebfd9a 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -147,6 +147,8 @@ config DVB_CORE
 config DVB_MMAP
 	bool "Enable DVB memory-mapped API (EXPERIMENTAL)"
 	depends on DVB_CORE
+	depends on VIDEO_V4L2=y || VIDEO_V4L2=DVB_CORE
+	select VIDEOBUF2_VMALLOC
 	default n
 	help
 	  This option enables DVB experimental memory-mapped API, with
-- 
2.9.0
