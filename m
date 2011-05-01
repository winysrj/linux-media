Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52229 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1EAEyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 00:54:09 -0400
Received: by eyx24 with SMTP id 24so1473430eyx.19
        for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 21:54:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B2B80B47-7366-41D4-8051-FF82B9198FA8@wilsonet.com>
References: <BANLkTinp69oB1qCK_ieX8vYm3F+Qd=e2mg@mail.gmail.com>
	<B2B80B47-7366-41D4-8051-FF82B9198FA8@wilsonet.com>
Date: Sun, 1 May 2011 14:54:07 +1000
Message-ID: <BANLkTi=u26EwJ+yV9Z96J0yPyCGEUcgiiQ@mail.gmail.com>
Subject: Re: imon: spews to dmesg
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 4/20/11, Jarod Wilson <jarod@wilsonet.com> wrote:


> Those are almost all dev_dbg spew.

Indeed, it seems to come from

        retval = send_packet(ictx);
        if (retval) {
                pr_err("send packet failed!\n");
                goto exit;
        } else {
                dev_dbg(ictx->dev, "%s: write %d bytes to LCD\n",
                        __func__, (int) n_bytes);
        }

in imon.c


> The normal way to enable dev_dbg spew is via some debugfs magic:
>
> http://outer-rim.gnu4u.org/?p=38
>
> (see also <kernel source>/Documentation/dynamic-debug-howto.txt)
>

I don't quite see why this would have happened since I didn't have a
debugfs mounted
during the build or after rebooting to use the new modules, to the
best of my knowledge.

> But I also seem to recall that DEBUG may be getting defined
> somewhere as part of the media_build process, which might be what
> is enabling that spew in your case.

I can't follow the flow in the build system well enough to see for
sure where this would be enabled or not, but some after grepping I
found the following in the file
 /linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
 136-
 137:#define DEBUG 0
 138-static int ttusb_cmd(struct ttusb *ttusb,

All other uses of DEBUG that I can find are #if'ed or #ifdef'ed in the
C code files.

dvb-ttusb-budget.c is being built, but why should the definition there
affect other modules?

Cheers
Vince
