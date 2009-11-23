Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:32961 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZKWRMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:12:00 -0500
Received: from homiemail-a20.g.dreamhost.com (caiajhbdcaid.dreamhost.com [208.97.132.83])
	by hapkido.dreamhost.com (Postfix) with ESMTP id F2BEF17B6CA
	for <linux-media@vger.kernel.org>; Mon, 23 Nov 2009 09:12:10 -0800 (PST)
Received: from localhost.localdomain (unknown [190.54.55.123])
	by homiemail-a20.g.dreamhost.com (Postfix) with ESMTPA id 6155C7EC06A
	for <linux-media@vger.kernel.org>; Mon, 23 Nov 2009 09:11:07 -0800 (PST)
Date: Mon, 23 Nov 2009 14:10:42 -0300
From: Gustavo =?UTF-8?B?Q2hhw61u?= Dumit <g@0xff.cl>
To: linux-media@vger.kernel.org
Subject: VFlip problem in gspca_pac7311
Message-ID: <20091123141042.47feac9e@0xff.cl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I'm testing a Pixart Imaging device (0x93a:0x2622)
Everything works fine, but vertical orientation. Image looks rotated.
So I wrote a little hack to prevent it.

diff --git a/drivers/media/video/gspca/pac7311.c
b/drivers/media/video/gspca/pac 7311.c
index 0527144..f7904ec 100644
--- a/drivers/media/video/gspca/pac7311.c
+++ b/drivers/media/video/gspca/pac7311.c
@@ -690,27 +690,28 @@ static int sd_start(struct gspca_dev *gspca_dev)
        }
        setgain(gspca_dev);
        setexposure(gspca_dev);
-       sethvflip(gspca_dev);
+       if (gspca_dev->dev->descriptor.idProduct != 0x2622)
+               sethvflip(gspca_dev);

Any one has the same problem ?
Thanks!

-- 
Gustavo Chaín Dumit
http://0xff.cl
