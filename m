Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2HOTFw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 15:05:52 -0400
Message-ID: <502BF2DD.5020601@redhat.com>
Date: Wed, 15 Aug 2012 16:05:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] left-overs from old 3.6 pull, more to come
References: <Pine.LNX.4.64.1208151618180.4024@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1208151618180.4024@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-08-2012 11:20, Guennadi Liakhovetski escreveu:
> Hi Mauro
> 
> Below are patches, that I tried to push for 3.6, but that went missing. 
> I'll also try to look through other my pending patches within the next 
> couple of hours, so, there might be one or two more pull requests from me 
> shortly.

Sorry for missing them! Not sure what happened.

> The following changes since commit f1b1b85c7f85417d73d3b315f5df1e2730477c0f:
> 
>   tw9910: Don't access the device in the g_mbus_fmt operation (2012-07-20 16:13:24 +0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.6

Hmm... it seems you're using an old version of git... Newer versions show it as:

The following changes since commit a1b3a6ce0f1510b14b18d019c4cda137585b1f69:

  [media] media: davinci: fix section mismatch warnings (2012-08-14 08:45:49 -0300)

are available in the git repository at:

  . staging/for_v3.7

for you to fetch changes up to 84cfe9e79bd5ac11c963f4841158454fefa872f6:

  [media] b2c2: fix driver's build due to the lack of pci DMA code (2012-08-15 12:14:12 -0300)


My merge scripts are now handling both commit ID's (start and end ones), in order
to be sure that I'll be picking all patches.

While it also works with the older way, I suggest you to update git, as this
can help me to double check if all patches were got, and that I'm not getting
more than actually requested.

Regards,
Mauro.
