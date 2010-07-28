Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37768 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0G1VQe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 17:16:34 -0400
Subject: Re: [PATCH 4/9] IR: add helper functions for ir input devices that
 send ir timing data in small chunks, and alternation between pulses and
 spaces isn't guaranteed.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20100728205755.GI26480@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
	 <1280330051-27732-5-git-send-email-maximlevitsky@gmail.com>
	 <20100728174626.GE26480@redhat.com>  <20100728205755.GI26480@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 00:16:28 +0300
Message-ID: <1280351788.8891.17.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 16:57 -0400, Jarod Wilson wrote: 
> On Wed, Jul 28, 2010 at 01:46:27PM -0400, Jarod Wilson wrote:
> > On Wed, Jul 28, 2010 at 06:14:06PM +0300, Maxim Levitsky wrote:
> > > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > With the caveat of requiring an improved changelog, per Mauro's suggestion:
> > 
> > Acked-by: Jarod Wilson <jarod@redhat.com>
> > 
> > I suspect at least some of this code may be of use to the streamzap driver
> > as well (which I started looking at porting last night, despite my
> > insistence that I was going to work on lirc_zilog first...).
> 
> One other note: idle looks like it can happily exist as a bool instead of
> as an int, no?
> 

sure.

I have a problem with this code however, I just discovered.
I pretty much don't know how to solve it currently...

I just posted a mail about it.

Best regards,
Maxim Levitsky

