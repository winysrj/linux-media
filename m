Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:40370 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388414AbeGXSpl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 14:45:41 -0400
MIME-Version: 1.0
References: <1532381973-11856-1-git-send-email-linux@roeck-us.net> <20180724004110.37d0e5dc@coco.lan>
In-Reply-To: <20180724004110.37d0e5dc@coco.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2018 10:37:56 -0700
Message-ID: <CA+55aFyV=5QNJXn+t_ZDCigGi+HjM6N94DRb_E50_xUsk+VTFA@mail.gmail.com>
Subject: Re: [PATCH] media: staging: omap4iss: Include asm/cacheflush.h after
 generic includes
To: mchehab+samsung@kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Staging subsystem List <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 23, 2018 at 8:41 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> While I won't be against merging it, IMHO a better fix would be to
> add the includes asm/cacheflush.h needs inside it, e. g. something
> like adding:

No. The <asm/*> includes really should come after <linux/*>.

This is a media driver bug, plain and simple.

We should strive to avoid adding more header includes, it's one of the
major causes of kernel build slowdown.

             Linus
