Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44313 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbaKKLJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:45 -0500
Date: Tue, 11 Nov 2014 09:09:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sebastian Reichel <sre@kernel.org>
Subject: Re: [GIT PULL FOR v3.19] Various fixes
Message-ID: <20141111090940.61626e4f@recife.lan>
In-Reply-To: <54609BD2.8070200@xs4all.nl>
References: <54609BD2.8070200@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Nov 2014 12:04:50 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Sparse fixes for saa7164, adv EDID fixes and si4713 improvements in preparation
> for adding DT support. Tested the si4713 with my USB dev board.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:
> 
>   [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.19f
> 
> for you to fetch changes up to 017f179ebd74ec3bd3f2484c3cc0fe48c306a36e:
> 
>   si4713: use managed irq request (2014-11-10 12:03:30 +0100)
> 

...

> Sebastian Reichel (4):
>       si4713: switch to devm regulator API
>       si4713: switch reset gpio to devm_gpiod API
>       si4713: use managed memory allocation
>       si4713: use managed irq request

None of the above was applied, as the first si4713 patch broke compilation.

Regards,
Mauro
