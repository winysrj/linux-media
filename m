Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52747 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754758Ab0GLHIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 03:08:42 -0400
Date: Mon, 12 Jul 2010 09:08:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add interlace support to sh_mobile_ceu_camera.c
In-Reply-To: <uvdtrmtin.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.1007120900430.7130@axis700.grange>
References: <uvdtrmtin.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san

I've got a question to you, regarding your interlaced support 
implementation for the CEU: do I understand it right, that the kind of 
support you actually have implemented is, that if an interlaced format is 
now requested from the CEU, it will interpret incoming data as interlaced 
and deinterlace it internally? If this is really the case, then, I think, 
it is a wrong way to implement this functionality. If a user requests 
interlaced data, it means, (s)he wants it interlaced in memory. Whereas 
deinterlacing should happen transparently - if the user requested 
progressive data and your source provides interlaced, you can decide to 
deinterlace it internally. Or am I misunderstanding your implementation?

Regardless of theoretical correctness - does your patch still work? Have 
you been able back then to get CEU to deinterlace data, and when have you 
last tested it?

Thanks
Guennadi
---
Guennadi Liakhovetski
