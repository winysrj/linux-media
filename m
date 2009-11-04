Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZKDHWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 02:22:04 -0500
Date: Wed, 4 Nov 2009 05:21:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Trying to compile for kernel version 2.6.28
Message-ID: <20091104052129.2e2dad47@pedra.chehab.org>
In-Reply-To: <4AF0500B.3070401@hoogenraad.net>
References: <4AF0500B.3070401@hoogenraad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

Em Tue, 03 Nov 2009 16:45:15 +0100
Jan Hoogenraad <jan-conceptronic@hoogenraad.net> escreveu:

> At this moment, I cannot figure out how to compile v4l with kernel 
> version 2.6.28.
> I see, however, that the daily build reports:
> linux-2.6.28-i686: OK

Yes, and that's correct. It does compile from scratch with 2.6.28.

If you look at v4l/versions.txt, this is already marked to compile only with
kernels 2.6.31 or newer. It should be noticed, however, that the building system
won't touch at your .config if you just do an hg update (or hg pull -u).

You'll need to ask it explicitly to process versions.txt again, by calling one of
the alternatives bellow that re-generates a v4l/.config.

If you are using a customized config, you'll need to call either one of those:
	make menuconfig
	make config
	make xconfig
	  or
	make gconfig

(in this specific case, just entering there and saving the config is enough - there's
no need to touch on any items)

Or, at the simple case were you're just building everything, you'll need to do:
	make allmodconfig

A side effect of touching at v4l/.config is that all (selected) drivers will
recompile again.

Cheers,
Mauro
