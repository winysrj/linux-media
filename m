Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1295 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaJVIMA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 04:12:00 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s9M8Bvsn063085
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 10:11:59 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.200.78] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id B70DE2A0432
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 10:11:45 +0200 (CEST)
Message-ID: <544766CC.5010904@xs4all.nl>
Date: Wed, 22 Oct 2014 10:11:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.18] wl128x: fix fmdbg compiler warning
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fmdrv_common.c: In function 'fm_download_firmware':
fmdrv_common.c:1259:2: warning: format '%d' expects argument of type 'int', but argument 3 has type 'size_t' [-Wformat=]
   fmdbg("Firmware(%s) length : %d bytes\n", fw_name, fw_entry->size);
   ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
  drivers/media/radio/wl128x/fmdrv_common.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 6f28f6e..704397f 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1256,7 +1256,7 @@ static int fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
  		fmerr("Unable to read firmware(%s) content\n", fw_name);
  		return ret;
  	}
-	fmdbg("Firmware(%s) length : %d bytes\n", fw_name, fw_entry->size);
+	fmdbg("Firmware(%s) length : %zu bytes\n", fw_name, fw_entry->size);
  
  	fw_data = (void *)fw_entry->data;
  	fw_len = fw_entry->size;
-- 
2.1.1

