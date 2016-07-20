Return-path: <linux-media-owner@vger.kernel.org>
Received: from smarthost03d.mail.zen.net.uk ([212.23.1.23]:40234 "EHLO
	smarthost03d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673AbcGTRG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 13:06:58 -0400
Received: from [82.68.240.77] (helo=ghost)
	by smarthost03d.mail.zen.net.uk with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <martin@luminoussheep.net>)
	id 1bPuxT-0006zG-Qx
	for linux-media@vger.kernel.org; Wed, 20 Jul 2016 17:06:55 +0000
Message-ID: <0dac334d135310327654ee0eba8a052d.squirrel@luminoussheep.net>
In-Reply-To: <e3148010250e01b8f1fde94c584ab36e.squirrel@luminoussheep.net>
References: <e3148010250e01b8f1fde94c584ab36e.squirrel@luminoussheep.net>
Date: Wed, 20 Jul 2016 18:07:06 +0100
Subject: Re: em288xx and lna - how to enable?
From: "Martin" <martin@luminoussheep.net>
To: "Martin" <martin@luminoussheep.net>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi,
>
> I see that my card 292e has LNA support:
> https://patchwork.linuxtv.org/patch/23763/
>
> but searching I can't find how to enable this the force option
> force_lna_activation=1 that the t500 uses isn't recognised
>
> Please could someone tell me if this is configurable an if so how to
> configure it?

Turns out I was looking in the wrong place.

I found it after more searching - it's part of the API and can be enabled
with the dvbv5-zap --lna=1


Regards,
M


