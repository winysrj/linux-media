Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59543 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0G2Pad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 11:30:33 -0400
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <20100729035213.GA11543@redhat.com>
References: <1280360452-8852-1-git-send-email-maximlevitsky@gmail.com>
	 <20100729035213.GA11543@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 18:30:28 +0300
Message-ID: <1280417428.29938.62.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 23:52 -0400, Jarod Wilson wrote: 
> On Thu, Jul 29, 2010 at 02:40:43AM +0300, Maxim Levitsky wrote:
> > Hi,
> > This is second version of the patchset.
> > Hopefully, I didn't forget to address all comments.
> > 
> > In addition to comments, I changed helper function that processes samples
> > so it sends last space as soon as timeout is reached.
> > This breaks somewhat lirc, because now it gets 2 spaces in row.
> > However, if it uses timeout reports (which are now fully supported)
> > it will get such report in middle.
> > 
> > Note that I send timeout report with zero value.
> > I don't think that this value is importaint.
> 
> I just patched the entire series into a branch here and tested, no
> regressions with an mceusb transceiver with in-kernel decode, lirc decode
> or lirc tx. Only issue I had (which I neglected to mention earlier) was
> some pedantic issues w/whitespace. Here's the tree I built and tested:
> 
> http://git.wilsonet.com/linux-2.6-ir-wip.git/?a=shortlog;h=refs/heads/maxim
> 
> 7486d6ae3 addresses all the whitespace/formatting issues I had. Could
> either merge that into your patches, or I can just send it along as an
> additional patch after the fact. In either case, for 1-7 v2:
About whitespace, I usually fix what checkpacth.pl tells me.
Nothing beyond that :-)


> 
> Tested-by: Jarod Wilson <jarod@redhat.com>
> 
> I have no ene hardware to actually test with, but it did build. :)
> 
> For 1-9 v2:
> 
> Acked-by: Jarod Wilson <jarod@redhat.com>
> 

Best regards,
Maxim Levitsky

