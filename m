Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab0JNTbW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:31:22 -0400
Date: Thu, 14 Oct 2010 15:30:48 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [2/8] IR: make sure we register the input device when it is safe
 to do so.
Message-ID: <20101014193048.GA4244@redhat.com>
References: <1283808373-27876-3-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283808373-27876-3-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Sep 06, 2010 at 09:26:07PM -0000, Maxim Levitsky wrote:
> As soon as input device is registered, it might be accessed (and it is)
> This can trigger a hardware interrupt that can access
> not yet initialized ir->raw, (by sending a sample)
> 
> This can be reproduced by holding down a remote button and reloading the module.
> And this always crashes the systems where hardware decides to send an interrupt
> right at the moment it is enabled.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Another one I thought I'd acked, but I don't see the ack in patchwork, so
it may have been from an earlier/superseded version...

Finally got my head wrapped around this one too, and I do see the
problem, and this fix looks good to me.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

