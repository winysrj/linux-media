Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:44572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0IHNmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 09:42:09 -0400
Message-ID: <4C8792B2.2010809@infradead.org>
Date: Wed, 08 Sep 2010 10:42:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, jarod@redhat.com
Subject: Re: [PATCH 1/5] rc-code: merge and rename ir-core
References: <20100907214943.30935.29895.stgit@localhost.localdomain> <20100907215143.30935.71857.stgit@localhost.localdomain>
In-Reply-To: <20100907215143.30935.71857.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 07-09-2010 18:51, David Härdeman escreveu:
> This patch merges the files which makes up ir-core and renames the
> resulting module to rc-core. IMHO this makes it much easier to hack
> on the core module since all code is in one file.
> 
> This also allows some simplification of ir-core-priv.h as fewer internal
> functions need to be exposed.

I'm not sure about this patch. Big files tend to be harder to maintain,
as it takes more time to find the right functions inside it. Also, IMO, 
it makes sense to keep the raw-event code on a separate file.

Anyway, if we apply this patch right now, it will cause merge conflicts with
the input tree, due to the get/setkeycodebig patches, and with some other
patches that are pending merge/review. The better is to apply such patch
just after the release of 2.6.37-rc1, after having all those conflicts
solved.

Cheers,
Mauro
