Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbZJNP3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 11:29:20 -0400
Date: Wed, 14 Oct 2009 12:28:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-media@vger.kernel.org
Cc: vdr@helmutauer.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Status of v4l repositories / merging new one
Message-ID: <20091014122804.46b962a6@pedra.chehab.org>
In-Reply-To: <4AD38F87.6020306@helmutauer.de>
References: <4AD38F87.6020306@helmutauer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 12 Oct 2009 22:20:23 +0200
Helmut Auer <vdr@helmutauer.de> escreveu:

> Hello List
> 
> AFAIK there are different v4l repositories supporting differnet hardware, e.g v4l-dvb(missing
> skystar HD), liplianin (missing knc1) etc.
> To add another one, we have a repository supporting the pci-e dual dvb-s low pointer profile
> mediapointer card :)
> But for my distribution I'd like to have one repository, supporting all cards
> Whats to do to get all these repositories merged ?
> Are there any plans about doing that ?

The base development tree is v4l-dvb. It is up to the driver authors to submit
me pull requests for their work, in order to have their drivers merged.

They do it when they feel comfortable that the driver is ready for submission.

With the creation of drivers/staging, a few weeks ago, even drivers that are
not yet mature enough for their usage can be added. So, all that is currently
needed is the driver author interests for having their work merged.

PS.: please post at linux-media@vger.kernel.org. The linux-dvb ML is obsolete and will
be discontinued soon.

Cheers,
Mauro
