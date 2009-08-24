Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZHXDJk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 23:09:40 -0400
Date: Mon, 24 Aug 2009 00:09:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
 capture driver
Message-ID: <20090824000934.68b82d9c@pedra.chehab.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401548C2BFE@dlee06.ent.ti.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
	<A69FA2915331DC488A831521EAE36FE40145300FC7@dlee06.ent.ti.com>
	<200908180849.14003.hverkuil@xs4all.nl>
	<200908180851.06222.hverkuil@xs4all.nl>
	<A69FA2915331DC488A831521EAE36FE401548C1E27@dlee06.ent.ti.com>
	<20090818142817.26de0893@pedra.chehab.org>
	<A69FA2915331DC488A831521EAE36FE401548C23A5@dlee06.ent.ti.com>
	<20090820013306.696e5dd9@pedra.chehab.org>
	<A69FA2915331DC488A831521EAE36FE401548C2BFE@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Aug 2009 16:27:40 -0500
"Karicheri, Muralidharan" <m-karicheri2@ti.com> escreveu:

> Kevin & Mauro,
> 
> Do I need to wait or this can be resolved by either of you for my work to proceed?

Murali,

If I fix your patch in order to apply it on my tree, backporting it to the old
arch header files, we'll have merge troubles upstream, when Kevin merge his
changes. It will also mean that he'll need to apply a diff patch on his tree,
in order to convert the patch to the new headers, and that git bisect may
break. I might merge his tree here, but this means that, if he needs to rebase
his tree (and sometimes people need to rebase their linux-next trees), I'll
have troubles here, and I'll loose my work.

So, the better solution is if he could apply this specific patch, merging his
tree upstream before your patches.

Cheers,
Mauro
