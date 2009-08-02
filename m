Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37960 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZHBHoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 03:44:54 -0400
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate02.web.de (Postfix) with ESMTP id 034A910F961E1
	for <linux-media@vger.kernel.org>; Sun,  2 Aug 2009 09:43:18 +0200 (CEST)
Received: from [217.228.188.248] (helo=[172.16.99.2])
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MXViv-0003yu-00
	for linux-media@vger.kernel.org; Sun, 02 Aug 2009 09:43:17 +0200
Message-ID: <4A754393.4090502@magic.ms>
Date: Sun, 02 Aug 2009 09:43:15 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-usb: fix tuning with Cinergy T2
References: <4A61FD76.8010409@magic.ms> <4A733BAB.6080305@magic.ms>
In-Reply-To: <4A733BAB.6080305@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize param.flags.

Signed-off-by: Eberhard Mattes <eberhard.mattes@web.de>
---
Not setting param.flags was the real cause of the inability of the Cinergy T2
driver to tune under certain circumstances. Moving stuff from the stack to the
heap did not really solve the problem. As there are several other drivers which
pass buffers on the stack to the USB layer, I leave fixing that to others.
This patch is against 2.6.30.


--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c	2009-06-10 05:05:27.000000000 +0200
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c	2009-08-02 09:28:55.000000000 +0200
@@ -275,6 +275,7 @@ static int cinergyt2_fe_set_frontend(str
  	param.tps = cpu_to_le16(compute_tps(fep));
  	param.freq = cpu_to_le32(fep->frequency / 1000);
  	param.bandwidth = 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
+	param.flags = 0;

  	err = dvb_usb_generic_rw(state->d,
  			(char *)&param, sizeof(param),

