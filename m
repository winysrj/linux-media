Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:44075 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0IJKM0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 06:12:26 -0400
Message-ID: <4C8A0488.9020206@iki.fi>
Date: Fri, 10 Sep 2010 13:12:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 2.6.37] new AF9015 devices
References: <4C894DB8.8080908@iki.fi> <201009100254.07762.s.L-H@gmx.de>
In-Reply-To: <201009100254.07762.s.L-H@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On 09/10/2010 03:54 AM, Stefan Lippers-Hollmann wrote:
> Another test and some further debugging of the IR core usedby the af9015
> branch of this git tree led me to partial success. DVB-T functionality
> continues to be fine and I've now found the proper values for this remote,
> however once a key gets pressed, it is never released (unless another key
> gets pressed which is then struck or unless I ctrl-c it (only works on
> terminals). Likewise I'm not sure yet how to distinguish between the
> "Cinergy T Dual" and my "Cinergy T RC MKII":


> Given that keys, once pressed, remain to be stuck, using both lirc's
> dev/input and without any dæmon trying to catch keypresses, I have not
> reached a functional configuration.

That`s known issue. Chip configures USB HID polling interval wrongly and 
due to that HID starts repeating usually. There is USB-ID mapped quirks 
in HID driver to avoid that, but only for few ADF9015 IDs...

I know how to fix that totally. I have been waiting new IR core merge 
before switch remote from broken HID + polling to memory read based one. 
But maybe I can do it just now and convert it later to IR core.

Antti


-- 
http://palosaari.fi/
