Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1IUNTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 09:19:37 -0400
Message-ID: <4E79E464.4050700@infradead.org>
Date: Wed, 21 Sep 2011 10:19:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.2] [media] saa7164: Adding support for HVR2200
 card id 0x8953
References: <CALzAhNUObL0WB2wfsVEKdNP_qddHtQyygz730AfNfPFNbJfbJg@mail.gmail.com>
In-Reply-To: <CALzAhNUObL0WB2wfsVEKdNP_qddHtQyygz730AfNfPFNbJfbJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-09-2011 18:35, Steven Toth escreveu:
> Hi Mauro,
> 
> Please pull 92aa36f8f9d19b7c47ad3daca15aa0932254246b from
> git://git.kernellabs.com/stoth/saa7164-dev.git

I need to know from what branch I need to pull. As this is auto-generated
when a git request-pull is used, I suspect that you're preparing the pull
request by hand or by some script you wrote.

The better way is to just run:

	git request-pull $ORIGIN $URL

where $ORIGIN is the reference branch/object for the pull (for example, remotes/media/staging/v3.2)
and $URL is the http/git/ssh URL for your tree.


This time, I've verified it manually, but please use git request-pull next
time, as it makes my life easier, and will allow patchwork to get your
pull request.
> 
> Another SAA7164 HVR220 card profile.
> 
> http://git.kernellabs.com/?p=stoth/saa7164-dev.git;a=commit;h=92aa36f8f9d19b7c47ad3daca15aa0932254246b

Applied, thanks!
> 
> drivers/media/video/saa7164/saa7164-cards.c |   62 +++++++++++++++++++++++++++
> drivers/media/video/saa7164/saa7164-dvb.c   |    1 +
> drivers/media/video/saa7164/saa7164.h       |    1 +
> 
> Thanks,
> 

Thanks,
Mauro.
