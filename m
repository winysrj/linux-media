Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:52583 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZDALOI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 07:14:08 -0400
Date: Wed, 1 Apr 2009 13:13:41 +0200
From: Janne Grunau <j@jannau.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Mike Isely <isely@pobox.com>, isely@isely.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5 of 8] pvrusb2: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090401111341.GA26440@aniel>
References: <patchbomb.1238338474@aniel> <20090329145908.GF17855@aniel> <Pine.LNX.4.64.0903312059100.7804@cnc.isely.net> <20090401063718.69e28bd2@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401063718.69e28bd2@caramujo.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 01, 2009 at 06:37:18AM -0300, Mauro Carvalho Chehab wrote:
> On Tue, 31 Mar 2009 21:02:16 -0500 (CDT)
> Mike Isely <isely@isely.net> wrote:
> 
> > 
> > This patch will not at all impact the operation of the pvrusb2 driver, 
> > and if associating with the USB interface's device node is preferred 
> > then I'm fine with it.
> > 
> > Acked-by: Mike Isely <isely@pobox.com>

Thanks, added.

> > Mauro: Is this series going to be pulled into v4l-dvb or shall I just 
> > bring this one specific change into my pvrusb2 repo?  Is there any 
> > reason not to pull it?
> 
> I'll take care on it on the next time I'll apply patchwork patches.

You don't need to. My plan was to send a pull request once I have enough
feedback. I should have said that in the intro mail.

> I suspect
> that Janne preferred to send via email for people to better analyse the impacts.

Yes, exactly.

Janne
