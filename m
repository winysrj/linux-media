Return-path: <mchehab@pedra>
Received: from mx38.mail.ru ([94.100.176.52]:53640 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0HROpu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Aug 2010 10:45:50 -0400
Received: from [95.53.176.251] (port=44062 helo=localhost.localdomain)
	by mx38.mail.ru with asmtp
	id 1Oljtk-000KyH-00
	for linux-media@vger.kernel.org; Wed, 18 Aug 2010 18:45:48 +0400
Date: Wed, 18 Aug 2010 18:53:54 +0400
From: Goga777 <goga777@bk.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: SkyStar S2 on an embedded Linux
Message-ID: <20100818185354.177c4c07@bk.ru>
In-Reply-To: <AANLkTi=T0dCRCHfr9tsQe-fVBwo+x1SehaZKA-VPmPAj@mail.gmail.com>
References: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
	<20100817211027.1ffee6ea@list.ru>
	<AANLkTi=T0dCRCHfr9tsQe-fVBwo+x1SehaZKA-VPmPAj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> > did you patch something ?
> > did you test your card with dvb-s2 channels ?
> 
> Yep! After I extracted the s2-liplianin archive, I patched the files
> using a file I've found on a Russian website. The link to the file
> (SVT-SkyStarS2-driver-install.run) can be found at the link below:
> 
> http://www.forum.free-x.de/wbb/index.php?page=Thread&postID=8170#post8170
> 
> I'm currently using it and I can scan, tune and watch S2 transponders.
> The problem is that when I copy the /lib directory to the root fs of
> target system (an embedded system with the same kernel), the modules
> don't get loaded correctly.


would you re-check please again - have you luck with 8PSK-FEC 3/4 dvb-s2 channels ?

Goga
