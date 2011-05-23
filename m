Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:59459 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756892Ab1EWTFV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 15:05:21 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Make code more readable by not using the return value of the WARN() macro. Set ret variable in an undefined case.
Date: Mon, 23 May 2011 21:04:08 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201105231307.53836.hselasky@c2i.net> <Pine.LNX.4.64.1105232019560.30305@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105232019560.30305@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105232104.08895.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 23 May 2011 20:22:02 Guennadi Liakhovetski wrote:
> Please, inline patches. Otherwise, this is what one gets, when replying.
> 
> On Mon, 23 May 2011, Hans Petter Selasky wrote:
> > --HPS
> 
> In any case, just throwing in my 2 cents - no idea how not using the
> return value of WARN() makes code more readable. On the contrary, using it
> is a standard practice. This patch doesn't seem like an improvement to me.

There is no strong reason for the WARN() part, you may ignore that, but the 
ret = 0, part is still valid. Should I generate a new patch or can you handle 
this?

--HPS
