Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:34247 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1EDI1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 04:27:49 -0400
Received: from cmsout01.mbox.net (cmsout01-lo [127.0.0.1])
	by cmsout01.mbox.net (Postfix) with ESMTP id 4F81D2AC892
	for <linux-media@vger.kernel.org>; Wed,  4 May 2011 08:27:41 +0000 (GMT)
Date: Wed, 04 May 2011 10:27:38 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Ngene cam device name
Mime-Version: 1.0
Message-ID: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
> Also, there's still no mapping between ca and caio devices. Imagine a
> built-in descrambler ca0 and two CI slots ca1 and ca2.
> 
> ca0 won't get a caio device, at least for now.
> ca1 and ca2 might or might not have a caio device.
> 
> If there is caio0, how am I supposed to know that it's related to ca1 or
> ca2 (or ca0, if someone implements a caio device to bypass the software
> demux to use a built-in descrambler)? You must not assume that there are
> either none or two (or three) caio interfaces. You need to be able to
> detect (or set up) the connection between the interfaces. Otherwise this
> "API" will be a mess.
> 
> Regards,
> Andreas


To my understanding, in such a described case, 

- ca0 would be reached from /dev/dvb/adapter0/ca0
- ca[12], depending on if they are connected to the same physical adapter
(PCI, USB, ...), would be reached from /dev/dvb/adapter1/ca[12] or
/dev/dvb/adapter1/ca1 and /dev/dvb/adapter2/ca2 and there respective caio
devices.

- If the 3 ca devices are on the same adapter, then the driver writer should
take care of the order of the mapping so that ca1 always map caio1 and
ca2/caio2, ...; and if this is not feasable, then the driver writer should
span the ca/caio devices on different /dev/dvb/adapter folders.

