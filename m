Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38202 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2ABKW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 05:22:56 -0500
Received: by werm1 with SMTP id m1so7355907wer.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 02:22:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112252219.11412.laurent.pinchart@ideasonboard.com>
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com>
	<201112231254.08377.laurent.pinchart@ideasonboard.com>
	<4EF4A45E.1070501@gmail.com>
	<201112252219.11412.laurent.pinchart@ideasonboard.com>
Date: Mon, 2 Jan 2012 11:22:54 +0100
Message-ID: <CACKLOr3cZvM-oH+s7tcfnnDAsrqSP6TVV9UVhJ6o4FJz8RxmiA@mail.gmail.com>
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

Hi,
i've just arrived the office after holidays and it seems you have
agreed some solution to the sequence number issue.

As I understand, for a case where there is 1:1 correspondence between
input and output (which is my case) I should do the following:

- keep an internal frame counter associated with the output queue.
- return the frame number when the user calls VIDIOC_QBUF on the output.
- pass the output frame number to the capture queue in a 1:1 basis

So in my chain of three processed nodes each node has its own internal
frame counter and frame loss should be checked at the video source.

Is that OK?

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
