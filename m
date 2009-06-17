Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:53493 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZFQEAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 00:00:11 -0400
Date: Tue, 16 Jun 2009 21:00:12 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: AH <andrzej.hajda@wp.pl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] High resolution timer for cx88 remotes
In-Reply-To: <20090616232825.31978261@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0906162059190.32713@shell2.speakeasy.net>
References: <4A17E6A9.4070409@wp.pl> <20090616232825.31978261@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 16 Jun 2009, Mauro Carvalho Chehab wrote:
> Em Sat, 23 May 2009 14:06:01 +0200
> AH <andrzej.hajda@wp.pl> escreveu:
> > Patched driver seems to work on my system, with kernel 2.6.28.
> > I have removed kernel checks for versions below 2.6.20 - they were
> > because of API changes in scheduler.

If you are going to break compatibility below 2.6.20 then you should add
the driver to versions.txt
