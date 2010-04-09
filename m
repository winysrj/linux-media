Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:55970 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0DIHMw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 03:12:52 -0400
Date: Fri, 9 Apr 2010 09:12:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] V4L/DVB: Use custom I2C probing function mechanism
Message-ID: <20100409091249.4cc5dd6e@hyperion.delvare>
In-Reply-To: <4BBEA864.9090702@redhat.com>
References: <20100404161454.0f99cc06@hyperion.delvare>
	<4BBA2B58.4000007@redhat.com>
	<20100405230616.443792ac@hyperion.delvare>
	<4BBAC7F6.5030807@redhat.com>
	<20100406182511.62894659@hyperion.delvare>
	<4BBEA864.9090702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, 09 Apr 2010 01:09:08 -0300, Mauro Carvalho Chehab wrote:
> Jean Delvare wrote:
> > There are no other probing functions yet, this is the first one. I have
> > added the mechanism to i2c-core for these very IR chips.
> > 
> > Putting all probe functions together would mean moving them to
> > i2c-core. This wasn't my original intent, but after all, it makes some
> > sense. Would you be happy with the following?
> 
> It seems fine for me. As you're touching on i2c core and on other drivers
> on this series, I think that the better is if you could apply it on your
> tree.

Yes, this is the plan. However, before I can add them to my tree, patch
named:
  [PATCH] FusionHDTV: Use quick reads for I2C IR device probing
which I posted to the linux-media mailing list some weeks ago must go
upstream. Otherwise these 2 patches do not apply cleanly.

> For both patches 1 and 2:
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Thanks.

-- 
Jean Delvare
