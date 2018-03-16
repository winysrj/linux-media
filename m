Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:44903 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750877AbeCPSps (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 14:45:48 -0400
Message-ID: <1521225943.6119.10.camel@perches.com>
Subject: Re: [PATCH][RFC] kernel.h: provide array iterator
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Abbott <abbotti@mev.co.uk>
Date: Fri, 16 Mar 2018 11:45:43 -0700
In-Reply-To: <b6af11b9-d697-59ec-6acc-80f0657a3e11@prevas.dk>
References: <1521108052-26861-1-git-send-email-kieran.bingham@ideasonboard.com>
         <b6af11b9-d697-59ec-6acc-80f0657a3e11@prevas.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-03-16 at 16:27 +0100, Rasmus Villemoes wrote:
> On 2018-03-15 11:00, Kieran Bingham wrote:
> > Simplify array iteration with a helper to iterate each entry in an array.
> > Utilise the existing ARRAY_SIZE macro to identify the length of the array
> > and pointer arithmetic to process each item as a for loop.

I recall getting negative feedback on a similar proposal
a decade ago:

https://lkml.org/lkml/2007/2/13/25

Not sure this is different.
