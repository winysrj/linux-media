Return-path: <mchehab@gaivota>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59449 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0KBU0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 16:26:36 -0400
Received: by yxk8 with SMTP id 8so4057575yxk.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 13:26:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101102201733.12010.30019.stgit@localhost.localdomain>
References: <20101102201733.12010.30019.stgit@localhost.localdomain>
Date: Tue, 2 Nov 2010 16:26:35 -0400
Message-ID: <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com>
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, Nov 2, 2010 at 4:17 PM, David Härdeman <david@hardeman.nu> wrote:
> This is my current patch queue, the main change is to make struct rc_dev
> the primary interface for rc drivers and to abstract away the fact that
> there's an input device lurking in there somewhere.
>
> In addition, the cx88 and winbond-cir drivers are converted to use rc-core.
>
> The patchset is now based on current linux-2.6 upstream git tree since it
> carries both the v4l patches from the staging/for_v2.6.37-rc1 branch, large
> scancode support and bugfixes.
>
> Given the changes, these patches touch every single driver. Obviously I
> haven't tested them all due to a lack of hardware (I have made sure that
> all drivers compile without any warnings and I have tested the end result
> on mceusb and winbond-cir hardware, Jarod Wilson has tested nuvoton-cir,
> imon and several mceusb devices).

And streamzap! :)

Mauro's at the kernel summit, but I had a brief moment to talk to him
earlier today. He had a few issues he wanted to give feedback on, but
I didn't get any specifics yet, other than him not liking the rc-map.c
bits merged into rc-main.c, mainly because part of the plan is to
remove in-kernel maps entirely in 2.6.38. It doesn't make a big
difference to me either way, and rc-main.c is still only 1300-ish
lines, and would be even less once rc-map.c bits are ripped out...

-- 
Jarod Wilson
jarod@wilsonet.com
