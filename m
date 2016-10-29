Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55890 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752262AbcJ2VEm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Oct 2016 17:04:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] [media] dib0700: fix nec repeat handling
Date: Sat, 29 Oct 2016 23:04:32 +0200
Message-ID: <7477306.RsW9ioQisc@wuerfel>
In-Reply-To: <20161013212844.GA23230@gofer.mess.org>
References: <1476366699-21611-1-git-send-email-geert@linux-m68k.org> <20161013211407.GB21731@gofer.mess.org> <20161013212844.GA23230@gofer.mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, October 13, 2016 10:28:44 PM CEST Sean Young wrote:
> When receiving a nec repeat, ensure the correct scancode is repeated
> rather than a random value from the stack. This removes the need
> for the bogus uninitialized_var() and also fixes the warnings:
> 
>     drivers/media/usb/dvb-usb/dib0700_core.c: In function ‘dib0700_rc_urb_completion’:
>     drivers/media/usb/dvb-usb/dib0700_core.c:679: warning: ‘protocol’ may be used uninitialized in this function
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/usb/dvb-usb/dib0700_core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Fixes: 2ceeca0499d7 ("[media] rc: split nec protocol into its three variants")
Fixes: d3c501d1938c ("V4L/DVB: dib0700: Fix RC protocol logic to properly handle NEC/NECx and RC-5")


The warning is gone for me too, so this obsoletes both
https://patchwork.linuxtv.org/patch/37494/ and
https://patchwork.kernel.org/patch/9380747/

Can we get this patch merged into v4.9 soonish? The warning
is currently disabled, but I'd like to make sure it gets turned
on again by default, and we should fix all the actual bugs in
the process.

	Arnd

[I replied to Mauro's other address here as mchehab@s-opensource.com
bounced with "Failed to transport message. Message sending failed
since the following recipients were rejected by the server:
mchehab@s-opensource.com (The server responded: Requested action
not taken: mailbox unavailable invalid DNS MX or A/AAAA resource
record)"]

