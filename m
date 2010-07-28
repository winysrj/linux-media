Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0G1R2U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:28:20 -0400
Date: Wed, 28 Jul 2010 13:17:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 8/9] IR: Add ENE input driver.
Message-ID: <20100728171739.GB26480@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
 <1280330051-27732-9-git-send-email-maximlevitsky@gmail.com>
 <4C506472.3080506@redhat.com>
 <1280337215.6590.1.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280337215.6590.1.camel@maxim-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 08:13:35PM +0300, Maxim Levitsky wrote:
> On Wed, 2010-07-28 at 14:10 -0300, Mauro Carvalho Chehab wrote: 
> > Em 28-07-2010 12:14, Maxim Levitsky escreveu:
> > > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > Please, instead of patch 9/9, do a patch moving ENE driver from staging into 
> > drivers/media/IR, and then a patch porting it into rc-core. This will allow us
> > to better understand what were done to convert it to rc-core, being an example
> > for others that may work on porting the other drivers to rc-core.
> 
> The version in staging is outdated.

D'oh, sorry about that.

> Should I first update it, and then move?

Yeah, that sounds sane to me.

-- 
Jarod Wilson
jarod@redhat.com

