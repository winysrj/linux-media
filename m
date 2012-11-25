Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58459 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2KYFCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 00:02:22 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so7022542qcr.19
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2012 21:02:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B199A9.8050909@gmail.com>
References: <50B1047B.4040901@gmail.com>
	<CAGoCfiwpj5ua79wOp8_CZfD_O9EOG7PAA4wE3L4n3-d-+FEhVg@mail.gmail.com>
	<50B199A9.8050909@gmail.com>
Date: Sun, 25 Nov 2012 00:02:21 -0500
Message-ID: <CAGoCfiyygbarz55T6KhGcM0ssNwkpXiiye7bvdk=t8Ln_c0q1A@mail.gmail.com>
Subject: Re: Poor HVR 1600 Video Quality - Feedback for Devin Heitmueller 2012-11-24
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Lightfoot <boblfoot@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 24, 2012 at 11:08 PM, Bob Lightfoot <boblfoot@gmail.com> wrote:
> Hope you can shed an idea or three.
>
> My end goal it to again record analog video in MythTV.

Two other questions:

Have you tried dropping the card into a Windows box to make sure your
hardware isn't just dead?  I know you said you thought it worked 6-9
months ago, but it's possible that it is just dumb luck that part of
the hardware died and it has nothing to do with the kernel revision.

Also, what kernel did it work last on?  If you could determine a
specific revision, it would help narrow down where the problem was
introduced (assuming it really is a regression in the kernel).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
