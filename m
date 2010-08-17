Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56418 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab0HQVDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 17:03:51 -0400
Received: by qwh6 with SMTP id 6so6495021qwh.19
        for <linux-media@vger.kernel.org>; Tue, 17 Aug 2010 14:03:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100817211027.1ffee6ea@list.ru>
References: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
	<20100817211027.1ffee6ea@list.ru>
Date: Wed, 18 Aug 2010 01:33:49 +0430
Message-ID: <AANLkTi=T0dCRCHfr9tsQe-fVBwo+x1SehaZKA-VPmPAj@mail.gmail.com>
Subject: Re: SkyStar S2 on an embedded Linux
From: Nima Mohammadi <nima.irt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, Aug 17, 2010 at 9:40 PM, Goga777 <goga777@list.ru> wrote:
> did you patch something ?
> did you test your card with dvb-s2 channels ?

Yep! After I extracted the s2-liplianin archive, I patched the files
using a file I've found on a Russian website. The link to the file
(SVT-SkyStarS2-driver-install.run) can be found at the link below:

http://www.forum.free-x.de/wbb/index.php?page=Thread&postID=8170#post8170

I'm currently using it and I can scan, tune and watch S2 transponders.
The problem is that when I copy the /lib directory to the root fs of
target system (an embedded system with the same kernel), the modules
don't get loaded correctly.

-- Nima Mohammadi
