Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35561 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaHEPas (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 11:30:48 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9U006OKB396270@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Aug 2014 16:30:45 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
References: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH 00/11] CODA Cleanup & fixes
Date: Tue, 05 Aug 2014 17:30:43 +0200
Message-id: <0c3001cfb0c2$3952deb0$abf89c10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Friday, July 25, 2014 5:08 PM
> To: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab; Kamil Debski; Fabio Estevam; Hans Verkuil;
> Nicolas Dufresne; kernel@pengutronix.de; Philipp Zabel
> Subject: [PATCH 00/11] CODA Cleanup & fixes
> 
> Hi,
> 
> the following series applies on top of the previous "Split CODA driver
> into multiple files" series. It contains various accumulated fixes,
> including dequeueing of buffers in stop_streaming and after
> start_streaming failure, a crash fix for the timestamp list handling,
> better error reporting, and the interrupt request by name in
> preparation for the second JPEG interrupt on CODA960.

I have trouble applying this patch set. Could you make sure that
it cleanly applies onto Mauro's branch:
http://git.linuxtv.org/cgit.cgi/mchehab/media-next.git/?

I applied the previous series from 23.07.2014, but applying this series
fails.

You can check my branch with work the series from 23.07.2014 applied here:
http://git.linuxtv.org/cgit.cgi/kdebski/media_tree_2.git/log/?h=for-v3.17

> 
> regards
> Philipp

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


