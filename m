Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52341 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0IIET5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 00:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <1283808373-27876-3-git-send-email-maximlevitsky@gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	<1283808373-27876-3-git-send-email-maximlevitsky@gmail.com>
Date: Thu, 9 Sep 2010 00:19:46 -0400
Message-ID: <AANLkTim_ZXKGpQp5Ji42kyLXps6-Onwk9dRX2NhY=bC9@mail.gmail.com>
Subject: Re: [PATCH 2/8] IR: make sure we register the input device when it is
 safe to do so.
From: Jarod Wilson <jarod@wilsonet.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> As soon as input device is registered, it might be accessed (and it is)
> This can trigger a hardware interrupt that can access
> not yet initialized ir->raw, (by sending a sample)
>
> This can be reproduced by holding down a remote button and reloading the module.
> And this always crashes the systems where hardware decides to send an interrupt
> right at the moment it is enabled.
>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Finally got my head wrapped around this one too, and I do see the
problem, and this fix looks good to me.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
