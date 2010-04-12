Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0DLRHu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 13:07:50 -0400
Message-ID: <4BC3535C.3010400@redhat.com>
Date: Mon, 12 Apr 2010 14:07:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: tm6000 sometime frooze, sometimes crashed isoc transfer
References: <4BC34DE7.1050406@arcor.de>
In-Reply-To: <4BC34DE7.1050406@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-04-2010 13:44, Stefan Ringel escreveu:
> Hi Mauro,
> 
> I have a little problem with the analog setting and isoc transfer (see
> log). Can I setting altsetting and where it must set?
> 

Feel free to do whatever needed to fix it. If you take a look on the history
of em28xx-video, you'll find several strategies I tried to make it work. The
first ones work better than currently, but the biggest issue is that parts
of the frames got lost. So, I played a lot trying to fix, and the current
code is just one of the trials (btw, it is the worst code, but I tried to start
from scratch, to see if re-implementing it would be better, and then I got out
of time to complete the new design). Hmm... In fact, later I received a code
that works on linux, but with a proprietary license, and I tried to get author's ack
to add his code (that also includes the alsa part), but he never gave it to me. I
suspect that the code were just a port of the original driver, authored by the
chipset manufacturer. So, I went into a dead end, since using the code would likely
violate someone's IP, and after looking at the code, I might contaminate the GPL
source code.

Cheers,
Mauro.
