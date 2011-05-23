Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:56407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab1EWSWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 14:22:09 -0400
Date: Mon, 23 May 2011 20:22:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Petter Selasky <hselasky@c2i.net>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Make code more readable by not using the return value
 of the WARN() macro. Set ret variable in an undefined case.
In-Reply-To: <201105231307.53836.hselasky@c2i.net>
Message-ID: <Pine.LNX.4.64.1105232019560.30305@axis700.grange>
References: <201105231307.53836.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Please, inline patches. Otherwise, this is what one gets, when replying.

On Mon, 23 May 2011, Hans Petter Selasky wrote:

> --HPS
> 


In any case, just throwing in my 2 cents - no idea how not using the 
return value of WARN() makes code more readable. On the contrary, using it 
is a standard practice. This patch doesn't seem like an improvement to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
