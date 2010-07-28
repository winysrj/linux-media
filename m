Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0G1QC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 12:02:56 -0400
Message-ID: <4C5054B6.5050207@redhat.com>
Date: Wed, 28 Jul 2010 13:03:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/9] IR: replace spinlock with mutex.
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com> <1280330051-27732-4-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280330051-27732-4-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 12:14, Maxim Levitsky escreveu:
> Some handlers (lirc for example) allocates memory on initialization,
> doing so in atomic context is cumbersome.
> Fixes warning about sleeping function in atomic context.

You should not replace it by a mutex, as the decoding code may happen during
IRQ time on several drivers.

If lirc is allocating memory, it should be using GFP_ATOMIC to avoid sleeping.

Cheers,
Mauro
