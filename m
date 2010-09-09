Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35179 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0IIFAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 01:00:53 -0400
Received: by qyk36 with SMTP id 36so5567920qyk.19
        for <linux-media@vger.kernel.org>; Wed, 08 Sep 2010 22:00:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100907215148.30935.38281.stgit@localhost.localdomain>
References: <20100907214943.30935.29895.stgit@localhost.localdomain>
	<20100907215148.30935.38281.stgit@localhost.localdomain>
Date: Thu, 9 Sep 2010 01:00:52 -0400
Message-ID: <AANLkTi=sNGau3s+oLPf+5VYRN37iO8z8g_gctX4gDKRi@mail.gmail.com>
Subject: Re: [PATCH 2/5] rc-core: remove remaining users of the ir-functions keyhandlers
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	jarod@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, Sep 7, 2010 at 5:51 PM, David Härdeman <david@hardeman.nu> wrote:
> This patch removes the remaining usages of the ir_input_nokey() and
> ir_input_keydown() functions provided by drivers/media/IR/ir-functions.c
> by using the corresponding functionality in rc-core directly instead.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>

Killing off legacy crud is a good thing. For a moment, I was confused
by all the ir_type bits being removed, thinking those were still
needed to populate allowed_protocols, but from reading through the
patch in more detail, none of them are used for that. Then it dawned
on me that (all of?) these are drivers that deal in scancodes, and
allowed_protocols only really matters for raw IR drivers and scancode
drivers that have a change_protocol function wired up. The only
drivers that have that which the patch touches are saa7134-input.c and
tm6000-input.c, and they're left intact, so all the ir_type bits
removed are indeed completely unnecessary. That was a long-winded way
of saying:

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
