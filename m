Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:52278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1EWSXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 14:23:50 -0400
Date: Mon, 23 May 2011 20:23:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Petter Selasky <hselasky@c2i.net>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Inlined functions should be static.
In-Reply-To: <201105231607.13668.hselasky@c2i.net>
Message-ID: <Pine.LNX.4.64.1105232022460.30305@axis700.grange>
References: <201105231607.13668.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 23 May 2011, Hans Petter Selasky wrote:

> --HPS
> 

(again, inlining would save me copy-pasting)

> -inline u32 stb0899_do_div(u64 n, u32 d)
> +static inline u32 stb0899_do_div(u64 n, u32 d)

while at it you could as well remove the unneeded in a C file "inline" 
attribute.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
