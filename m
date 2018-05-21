Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34409 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbeEUUaZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 16:30:25 -0400
Received: by mail-qt0-f169.google.com with SMTP id m5-v6so20636508qti.1
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 13:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <897fac42-1456-c2ad-94be-3aee64df18d6@inbox.lv>
References: <897fac42-1456-c2ad-94be-3aee64df18d6@inbox.lv>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 21 May 2018 23:30:24 +0300
Message-ID: <CAHp75VfsJUSAV0TPkcSOMrZedqhcM117JFtH-xHFAJKLPDqQ9A@mail.gmail.com>
Subject: Re: Bugfix for Tevii S650
To: Light <light23@inbox.lv>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Cc: Mauro

On Mon, May 21, 2018 at 3:01 PM, Light <light23@inbox.lv> wrote:
> Hi,
>
> staring with kernel 4.1 the tevii S650 usb box is not working any more, last
> working version was 4.0.
>
> The  bug was also reported here
> https://www.spinics.net/lists/linux-media/msg121356.html
>
> I found a solution for it and uploaded a patch to the kernel bugzilla.
>
> See here: https://bugzilla.kernel.org/show_bug.cgi?id=197731
>
> Can somebody of the maintainers have a look on it and apply the patch to the
> kernes sources?

You forget to Cc to maintainers (at least Mauro).

-- 
With Best Regards,
Andy Shevchenko
