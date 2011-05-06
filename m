Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:59223 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab1EFNsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 09:48:04 -0400
Date: Fri, 06 May 2011 15:47:59 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: Andreas Oberritter <obi@linuxtv.org>,
	Martin Vidovic <xtronom@gmail.com>
Subject: Re: [PATCH] Ngene cam device name
CC: Ralph Metzler <rjkm@metzlerbros.de>, <linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <724PeFNU87648S03.1304689679@web03.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
> > The best would be to create independent adapters for each independent CA
> > device (ca0/caio0 pair) - they are independent after all (physically and
> > in the way they're used).
> 
> Physically, it's a general purpose TS I/O interface of the nGene
> chipset. It just happens to be connected to a CI slot. On another board,
> it might be connected to a modulator or just to some kind of socket.
> 
> If the next version gets a connector for two switchable CI modules, then
> the physical independence is gone. You'd have two ca nodes but only one
> caio node. Or two caio nodes, that can't be used concurrently.
> 
> Maybe the next version gets the ability to directly connect the TS input
> from the frontend to the TS output to the CI slot to save copying around
> the data, by using some kind of pin mux. Not physically independent either.
> 
> It just looks physically independent in the one configuration
> implemented now.


When I read the cxd2099ar datasheet, I can see that in dual slot
configuration, there is still one communication channel for the TS and one for
the control.
Also, it seems linux en50221 stack provides for the slot selection. So, why
would you need two ca nodes ?

