Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:59394 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbcGSIgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 04:36:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] cec: add RC_CORE dependency
Date: Tue, 19 Jul 2016 10:35:53 +0200
Message-ID: <5861145.2bCA7xogPm@wuerfel>
In-Reply-To: <578DE51E.8080604@xs4all.nl>
References: <20160719081040.2685845-1-arnd@arndb.de> <20160719081040.2685845-2-arnd@arndb.de> <578DE51E.8080604@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, July 19, 2016 10:30:22 AM CEST Hans Verkuil wrote:
> On 07/19/16 10:10, Arnd Bergmann wrote:
> > We cannot build the cec driver when the RC core is a module
> > and cec is built-in:
> > 
> > drivers/staging/built-in.o: In function `cec_allocate_adapter':
> > :(.text+0x134): undefined reference to `rc_allocate_device'
> > drivers/staging/built-in.o: In function `cec_register_adapter':
> > :(.text+0x304): undefined reference to `rc_register_device'
> > 
> > This adds an explicit dependency to avoid this case. We still
> > allow building when CONFIG_RC_CORE is disabled completely,
> > as the driver has checks for this case itself.
> 
> This makes no sense: the rc_allocate_device and rc_register_device
> are under:
> 
> #if IS_REACHABLE(CONFIG_RC_CORE)
> 
> So it shouldn't be enabled at all, should it?

My mistake, I forgot to remove my patch from the backlog after
you added 5bb2399a4fe4 ("[media] cec: fix Kconfig dependency
problems"), and I saw that it's still marked as "new" in
patchwork with no reply.

I'll drop the patch from my local series and won't submit it again,
sorry for the mixup.

	Arnd
