Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58221 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab2FHJCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 05:02:32 -0400
Received: by bkcji2 with SMTP id ji2so1536439bkc.19
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2012 02:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr2wdF4tnovpnCO+ys7OMhbaKoruorSsj5hPfB26jGzQTA@mail.gmail.com>
References: <CACKLOr2jQMnBPTaTFOcfLN_9J1n39tLx-ffDcVGuZ4ZB-odYfg@mail.gmail.com>
	<20120608072601.GD30137@pengutronix.de>
	<CACKLOr1OShoEnLxs8BP6q2TyZrOH0oCnpbKZJqyAo-yXKck9Zw@mail.gmail.com>
	<20120608084802.GS30400@pengutronix.de>
	<CACKLOr2wdF4tnovpnCO+ys7OMhbaKoruorSsj5hPfB26jGzQTA@mail.gmail.com>
Date: Fri, 8 Jun 2012 11:02:31 +0200
Message-ID: <CACKLOr1G+GBMhRoWSMJ17LoKuiUe0b+BXcuzEKh4OUKNaU_M8A@mail.gmail.com>
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
From: javier Martin <javier.martin@vista-silicon.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
	linux-media@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
	Dirk Behme <dirk.behme@googlemail.com>,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I've checked this matter with a colleague and we have several reasons
to doubt that the i.MX27 and the i.MX53 can share the same driver for
their Video Processing Units (VPU):

1. The VPU in the i.MX27 is a "codadx6" with support for H.264, H.263
and MPEG4-Part2 [1]. Provided Freescale is using the same IP provider
for i.MX53 and looking at the features that the VPU in this SoC
supports (1080p resolution, VP8) we are probably dealing with a "coda
9 series" [2].

2. An important part of the functionality for controlling the
"codadx6" is implemented using software messages between the main CPU
and the VPU, this means that a different firmware loaded in the VPU
can substantially change the way it is handled. As previously stated,
i.MX27 and i.MX53 have different IP blocks and because of this, those
messages will be very different.

For these reasons we suggest that we carry on developing different
drivers for the i.MX27 and the i.MX53. Though it's true that both
drivers could share some overhead given by the use of mem2mem
framework, I don't think this is a good enough reason the merge them.

By the way, driver for the VPU in the i.MX27 will be called
"codadx6"[3], I suggest you call your driver "coda9" to avoid
confusion.


[1] http://www.chipsnmedia.com/product_search/product_view.php?part_idx=30&idx=48
[2] http://www.chipsnmedia.com/product_search/product_view.php?part_idx=20&idx=53
[3] https://github.com/jmartinc/video_visstrim/tree/mx27-codadx6/drivers/media/video/codadx6


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
