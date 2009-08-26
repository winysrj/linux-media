Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbZHZRXs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 13:23:48 -0400
Date: Wed, 26 Aug 2009 14:23:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	DaVinci <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: davinci vs. v4l2: lots of conflicts in merge for linux-next
Message-ID: <20090826142343.7e71d4b2@pedra.chehab.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40154E2C0E7@dlee06.ent.ti.com>
References: <636c5030908260200t1d2182a8oabf6b61d31b1849b@mail.gmail.com>
	<A69FA2915331DC488A831521EAE36FE40154E2C0E7@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Aug 2009 11:00:22 -0500
"Karicheri, Muralidharan" <m-karicheri2@ti.com> escreveu:

> Kevin,
> 
> Ok, I see you have merged vpif capture architecture part to master branch
> of davinci. 
> 
> So what you are suggesting is to remove all vpif/vpfe patches from arch/arm/davinci of v4l linux-next tree (So I guess this is what Mauro should do on linux-next). So architecture part of all future video patches are to be re-created and re-submitted based on davinci-next and will be merged only to davinci tree and Mauro will merge the v4l part.

I'll drop those patches from my tree.

> Kevin & Mauro,
> 
> So only concern I have is that these patches may not compile (either architecture part or v4l part) until the counter part becomes available on the tree. Is this fine? 

The strategy we use for solving those troubles is to move the Kbuild patches
that adds the compilation for the driver to be merged at the end of the series.
If, without this patch, the kernel will keep compiling, everything is fine.

Cheers,
Mauro
