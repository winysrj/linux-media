Return-path: <mchehab@pedra>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55462
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130Ab0IPUIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 16:08:05 -0400
Date: Thu, 16 Sep 2010 13:08:23 -0700 (PDT)
Message-Id: <20100916.130823.67906066.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: arnd@arndb.de, codalist@TELEMANN.coda.cs.cmu.edu,
	autofs@linux.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, hch@infradead.org,
	mikulas@artax.karlin.mff.cuni.cz, Trond.Myklebust@netapp.com,
	vandrove@vc.cvut.cz, al@alarsen.net, jack@suse.cz,
	dushistov@mail.ru, mingo@elte.hu, netdev@vger.kernel.org,
	samuel@sortiz.org, acme@ghostprotocols.net,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	andrew.hendry@gmail.com
Subject: Re: Remaining BKL users, what to do
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100916160759.4411786c@lxorguk.ukuu.org.uk>
References: <201009161632.59210.arnd@arndb.de>
	<20100916160759.4411786c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 16 Sep 2010 16:07:59 +0100

>> net/appletalk:
>> net/ipx/af_ipx.c:
>> net/irda/af_irda.c:
>> 	Can probably be saved from retirement in drivers/staging if the
>> 	maintainers still care.
> 
> IPX and Appletalk both have active users. They also look fairly fixable
> as the lock_kernel just maps to a stack private mutex, or in several
> cases can simply be dropped - its just a push down legacy.

I'll take a stab at IPX and Appletalk.
