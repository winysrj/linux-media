Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:39151 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab1FCOWh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 10:22:37 -0400
Received: from [94.248.227.103]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSVGj-0006Ow-Nx
	for linux-media@vger.kernel.org; Fri, 03 Jun 2011 16:22:35 +0200
Message-ID: <4DE8EE28.60002@mailbox.hu>
Date: Fri, 03 Jun 2011 16:22:32 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: XC4000: added card_type
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local>	<BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>	<4DE8D5AC.7060002@mailbox.hu> <BANLkTi=c+OQvh9Mj4njF4dJtSQdR=cAMaA@mail.gmail.com> <4DE8DEC6.6080008@mailbox.hu> <4DE8E8FF.8050203@redhat.com>
In-Reply-To: <4DE8E8FF.8050203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/03/2011 04:00 PM, Mauro Carvalho Chehab wrote:

> While the xc4000 is not merged upstream, we may have such hack, but
> before merging, this issue should be solved.
> 
> However, it seems better to just do the right thing since the beginning:
> 
> just add a patch for cx88 adding the xc4000 boards there and filling
> the config stuff inside cx88 driver.

I do intend to remove the card_type code later, and only send cx88
patches once the interface is cleaned up. It is only included
for now to have a working code without conflicting patches, and I
do not know exactly what the config structure should eventually
contain, that is, some of the current board-specific 'if' statements
may actually turn out to be unnecessary and can be made the same for
all cards.
