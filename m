Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZCWWiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 18:38:54 -0400
Date: Mon, 23 Mar 2009 19:38:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Uri Shkolnik <uris@siano-ms.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for
 workarounds
Message-ID: <20090323193853.4fc0531c@pedra.chehab.org>
In-Reply-To: <20090322153534.0c64de1e@mjolnir.ossman.eu>
References: <20090314074201.5c4a1ce1@pedra.chehab.org>
	<20090322153534.0c64de1e@mjolnir.ossman.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 22 Mar 2009 15:35:34 +0100
Pierre Ossman <drzeus@drzeus.cx> wrote:

> On Sat, 14 Mar 2009 07:42:01 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > Hi Pierre,
> > 
> > Uri sent me this patchset, as part of the changes for supporting some devices
> > from Siano.
> > 
> > The changeset looks fine, although I have no experiences with MMC. Are you
> > applying it on your tree, or do you prefer if I apply here?
> > 
> > If you're applying on yours, this is my ack:
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> 
> This should probably go in your tree with the patch for the Siano SDIO
> driver. 

Ok, I'll add it on my -git at the proper time.

> The problem is that that driver isn't ready yet. I was going
> to do a final cleanup once the USB separations patches were done, but
> those never materialised.

So, if I understood you well, you want me first to apply the USB patches first,
or is it something that is still pending from Siano side?


Cheers,
Mauro
