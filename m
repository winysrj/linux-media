Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:50421 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbcCGQdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 11:33:38 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: videobuf2-dma-sg and multiple planes semantics
Date: Mon, 07 Mar 2016 17:33:26 +0100
Message-ID: <87y49uuu21.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been converting pxa_camera driver from videobuf to videobuf2, and I have a
question about multiple plane semantics.

I have a case where I have 3 planes for a yuv422 capture :
 - 1 Y plane (total_size / 2 bytes)
 - 1 U plane (total_size / 4 bytes)
 - 1 V plane (total_size / 4 bytes)

I would have expected vb2_dma_sg_plane_desc(vb, i) to return me 3 different
sg_tables, one for each plane. I would have been then able to feed them to 3
dmaengine channels (this is the case for pxa27x platform), so that the 3 planes
are filled in concurrently.

My understanding is that videobuf2-dma-sg has only 1 sg_table, which seems to be
enforced by vb2_dma_sg_cookie(), so the question is : is it on purpose, and how
do the multiple planes are handled within videobuf2-dma-sg ?

Cheers.

--
Robert
