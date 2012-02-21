Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46698 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274Ab2BUJOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 04:14:16 -0500
Received: by lagu2 with SMTP id u2so7374240lag.19
        for <linux-media@vger.kernel.org>; Tue, 21 Feb 2012 01:14:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202210936420.18412@axis700.grange>
References: <1329219332-27620-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1202201413300.2836@axis700.grange>
	<CACKLOr1KT2A1Zd_xsVXPGW8X6e57v6xTZTm46wdfNfwwf9-MYQ@mail.gmail.com>
	<Pine.LNX.4.64.1202210936420.18412@axis700.grange>
Date: Tue, 21 Feb 2012 10:14:15 +0100
Message-ID: <CACKLOr2uOab=yS6iE2A871=dEfWH5jFDcoL7FQ2=nKOyJkHN-A@mail.gmail.com>
Subject: Re: [PATCH] media: i.MX27 camera: Add resizing support.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 February 2012 09:39, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Javier
>
> One more thing occurred to me: I don't see anywhere in your patch checking
> for supported pixel (fourcc) formats. I don't think the PRP can resize
> arbitrary formats? Most likely these would be limited to some YUV, and,
> possibly, some RGB formats?

The PrP can resize every format which is supported as input by the eMMa.

Currently, the driver supports 2 input formats: RGB565 and YUV422
(YUYV)  (see mx27_emma_prp_table[]).

Since the commit of resizing registers is done in the stream_start
callback this makes sure that resizing won't be applied to unknown
formats.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
