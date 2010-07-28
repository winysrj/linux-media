Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38897 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab0G1QdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 12:33:04 -0400
Subject: Re: [PATCH 3/9] IR: replace spinlock with mutex.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <4C5054B6.5050207@redhat.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
	 <1280330051-27732-4-git-send-email-maximlevitsky@gmail.com>
	 <4C5054B6.5050207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 19:32:58 +0300
Message-ID: <1280334778.28785.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 13:03 -0300, Mauro Carvalho Chehab wrote:
> Em 28-07-2010 12:14, Maxim Levitsky escreveu:
> > Some handlers (lirc for example) allocates memory on initialization,
> > doing so in atomic context is cumbersome.
> > Fixes warning about sleeping function in atomic context.
> 
> You should not replace it by a mutex, as the decoding code may happen during
> IRQ time on several drivers.
I though decoding code is run by a work queue?
I don't see any atomic codepath here...

> 
> If lirc is allocating memory, it should be using GFP_ATOMIC to avoid sleeping.

If its really not possible, I can make lirc use GFP_ATOMIC. a bit ugly,
but should work.

Best regards,
	

