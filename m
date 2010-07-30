Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57568 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab0G3Twa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 15:52:30 -0400
Subject: Re: [PATCH 0/9 v3] IR: few fixes, additions and ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <4C5328F2.8040404@redhat.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
	 <4C5328F2.8040404@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 22:52:24 +0300
Message-ID: <1280519544.3159.0.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 16:33 -0300, Mauro Carvalho Chehab wrote: 
> Em 30-07-2010 08:38, Maxim Levitsky escreveu:
> > Hi,
> > 
> > This is mostly same patchset.
> > 
> > I addressed the comments of Andy Walls.
> > 
> > Now IR decoding is done by a separate thread, and this fixes
> > the race, and unnesesary performance loss due to it.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> 
> Hmm... some change at this changeset is trying to divide a 64 bits integer
> at the LIRC driver. This is causing the following error:
> 
> Jul 30 16:45:23 agua kernel: [23834.179871] lirc_dev: IR Remote Control driver registered, major 251 
> Jul 30 16:45:23 agua kernel: [23834.181884] ir_lirc_codec: Unknown symbol __udivdi3 (err 0)
> 
> you should, instead use do_div for doing that. Another fix would be to define the timeout
> constants as int or u32.
I know about that, but forgot, sorry.

Sure, will do.

Best regards,
Maxim Levitsky

