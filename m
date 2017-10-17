Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:45377 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752911AbdJQPQE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 11:16:04 -0400
Received: by mail-io0-f181.google.com with SMTP id i38so2650900iod.2
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 08:16:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171017082307.qsupictqciku73jj@valkosipuli.retiisi.org.uk>
References: <20171016232456.GA100862@beast> <20171017082307.qsupictqciku73jj@valkosipuli.retiisi.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 17 Oct 2017 08:16:03 -0700
Message-ID: <CAGXu5j+TN6rfM1t8qSO7b_5n+65MHAXsf8kZYRMyiq+2Orz+SQ@mail.gmail.com>
Subject: Re: [PATCH] staging/atomisp: Convert timers to use timer_setup()
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 17, 2017 at 1:23 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Mon, Oct 16, 2017 at 04:24:56PM -0700, Kees Cook wrote:
>> In preparation for unconditionally passing the struct timer_list pointer to
>> all timer callbacks, switch to using the new timer_setup() and from_timer()
>> to pass the timer pointer explicitly.
>>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Alan Cox <alan@linux.intel.com>
>> Cc: Daeseok Youn <daeseok.youn@gmail.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: linux-media@vger.kernel.org
>> Cc: devel@driverdev.osuosl.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> This appears to be the same as the patch I've applied previously.

Okay, sorry for the noise. I didn't see it in -next when I did my
rebase this week.

-Kees

-- 
Kees Cook
Pixel Security
