Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab0JWPR6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 11:17:58 -0400
Message-ID: <4CC2FC9C.3060007@redhat.com>
Date: Sat, 23 Oct 2010 13:17:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?ISO-8859-1?Q?Hern=E1n_?= =?ISO-8859-1?Q?Ordiales?=
	<h.ordiales@gmail.com>, "Igor M. Liplianin" <liplianin@me.by>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: V4L/DVB/IR patches pending merge
References: <4CC25F60.7050106@redhat.com> <20101023083521.20d91542@bike.lwn.net>
In-Reply-To: <20101023083521.20d91542@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-10-2010 12:35, Jonathan Corbet escreveu:
> On Sat, 23 Oct 2010 02:06:56 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> in the case of the first patch, I'm not sure if you acked or nacked it. I suspect that you ack ;)
>> You didn't comment the second one (or maybe I just missed your email). Are both ok for you?
> 
> Yes, I'm sorry, I was perhaps a bit too grumpy that day.  The patch is
> a clear improvement over the hacky "just make it work" stuff I did
> previously.  Feel free to add my Acked-by to both.

Added, thanks!

Btw, I agree with you that the choose between smsbus and i2c at the driver is a hack that should be
addressed at the long term. Yet, removing OLPC-specific stuff from ov7670 is a good improvement, as the
driver become more generic.

Cheers,
Mauro
