Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51862 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2ABLoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 06:44:10 -0500
Received: by werm1 with SMTP id m1so7382133wer.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 03:44:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201021206.06397.laurent.pinchart@ideasonboard.com>
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com>
	<201112252219.11412.laurent.pinchart@ideasonboard.com>
	<CACKLOr3cZvM-oH+s7tcfnnDAsrqSP6TVV9UVhJ6o4FJz8RxmiA@mail.gmail.com>
	<201201021206.06397.laurent.pinchart@ideasonboard.com>
Date: Mon, 2 Jan 2012 12:44:08 +0100
Message-ID: <CACKLOr3gc9o7JYzG+rV9Mp9C7xtgf0Q5W7vgxQ5H8wQDvO-ong@mail.gmail.com>
Subject: Re: MEM2MEM devices: how to handle sequence number?
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de, Pawel Osciak <p.osciak@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just one more question about this.

The v4l2 encoder, which is the last element in my processing chain, is
an H.264 encoder that has to know about previous frames to encode.
For these kind of devices it is very useful to know whether a frame
has been lost to introduce a skip frame and improve the encoding
process.

But, with the current approach we don't have any way to communicate
this to the device.

One option would be that the user specified a sequence number when
issuing VIDIOC_QBUF at the output queue so that the device could
detect any discontinuity and introduce a skip frame. But this would
break your rule that sequence number introduced at the output queue
has to be ignored by the driver.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
