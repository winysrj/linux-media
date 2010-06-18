Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33094 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488Ab0FROal (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jun 2010 10:30:41 -0400
Received: by fxm10 with SMTP id 10so650333fxm.19
        for <linux-media@vger.kernel.org>; Fri, 18 Jun 2010 07:30:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C14F922.1020802@coronamundi.de>
References: <4C14F922.1020802@coronamundi.de>
Date: Fri, 18 Jun 2010 10:30:39 -0400
Message-ID: <AANLkTinpwSQlGWtlz8cTCCQyzfWN6qiqLcsJczs87WTZ@mail.gmail.com>
Subject: Re: PROBLEM: 2.6.34-rc7 kernel panics "BUG: unable to handle kernel
	NULL pointer dereference at (null)" while channel scan runnin
From: David Ellingsworth <david@identd.dyndns.org>
To: Silamael <Silamael@coronamundi.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 13, 2010 at 11:28 AM, Silamael <Silamael@coronamundi.de> wrote:
> Hello!
>
> In the meanwhile i tried several different kernel versions:
> - 2.6.26 (as included in Debian Lenny): crash
> - 2.6.32-3 (as in Debian Squeeze): crash
> - 2.6.32-5 (updated version in Debian Squeeze): crash
> - 2.6.34: crash
>
> In every kernel version I've tested, the crashdump looks the same. Each
> time there's an NULL pointer given to saa7146_buffer_next().
>
> Would be nice if someone could give me some hints. I'm not sure whether
> it's a broken driver or it's due to broken hardware or some other issues.
>
> Thanks a lot!
>

Matthias,

While I don't doubt there's probably a bug in this driver, you haven't
provided nearly enough information to correct it. Please resubmit with
the full backtrace provided by the kernel at the time of the crash.
Without this information, it's hard to gauge the exact cause of the
error and thus no one will attempt to fix it.

Regards,

David Ellingsworth
