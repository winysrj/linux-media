Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55617 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3AOL11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 06:27:27 -0500
Received: by mail-oa0-f49.google.com with SMTP id l10so4983422oag.8
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2013 03:27:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130106113455.329ad868@redhat.com>
References: <20130106113455.329ad868@redhat.com>
Date: Tue, 15 Jan 2013 16:57:26 +0530
Message-ID: <CAHFNz9JjP1ZjLM67SA-01raNKcoUjVmD8-2JfkDe=hHAB61Lig@mail.gmail.com>
Subject: Re: Status of the patches under review at LMML (35 patches)
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 6, 2013 at 7:04 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is the summary of the patches that are currently under review at
> Linux Media Mailing List <linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
>

>
>
>                 == Manu Abraham <abraham.manu@gmail.com> ==
>
> Those patches are there for a long time. I think I'll simply apply all of
> them, if they're not reviewed on the next couple weeks:
>
> Mar,11 2012: [2/3] stv090x: use error counter 1 for BER estimation                  http://patchwork.linuxtv.org/patch/10301  Andreas Regel <andreas.regel@gmx.de>


I am not at all sure on this patch. If there is a valid test result on this
patch, then I am all for it.


> Mar,11 2012: [3/3] stv090x: On STV0903 do not set registers of the second path.     http://patchwork.linuxtv.org/patch/10302  Andreas Regel <andreas.regel@gmx.de>

Patch seems mostly correct, there are some unpleasantness in it.
But nevertheless it looks okay. Haven't tested it at all.

Acked-by: Manu Abraham <manu@linuxtv.org>


> Nov,29 2011: stv090x: implement function for reading uncorrected blocks count       http://patchwork.linuxtv.org/patch/8656   Mariusz Bia?o?czyk <manio@skyboo.net>


Comments within patchwork itself.



> Jun, 8 2011: Add remote control support for mantis                                  http://patchwork.linuxtv.org/patch/7217   Christoph Pinkl <christoph.pinkl@gmail.com>


I did test this patch a while back. It didn't work as expected at all.


> Apr, 1 2012: [05/11] Slightly more friendly debugging output.                       http://patchwork.linuxtv.org/patch/10520  "Steinar H. Gunderson" <sesse@samfundet.no>

Simply a cosmetic patch. Doesn't bring any advantage. Knowing what
 MMIO address failed doesn't help at all. If you have failures, then you
will have failures with the entire mapped addresses. So AFAICT, this
patch doesn't bring any advantage to help in additional debugging either.


> Apr, 1 2012: [06/11] Replace ca_lock by a slightly more general int_stat_lock.      http://patchwork.linuxtv.org/patch/10521  "Steinar H. Gunderson" <sesse@samfundet.no>


This is actually sleeping in interrupt context. All it does is a cosmetic
name change and adding a mutex across the IRQ handler, which is
 not a valid thing to do.

> Apr, 1 2012: [07/11] Fix a ton of SMP-unsafe accesses.                              http://patchwork.linuxtv.org/patch/10523  "Steinar H. Gunderson" <sesse@samfundet.no>


Use of volatile .. I am not sure. It does need a lock someplace, but I am
not sure whether this patch is doing correctly at all.


> Apr, 1 2012: [08/11] Remove some unused structure members.                          http://patchwork.linuxtv.org/patch/10525  "Steinar H. Gunderson" <sesse@samfundet.no>


The enumeration holds the status of the SmartBuffer, currently it is not
being checked against. Deleting it might not be a useful thing.. ? Though
the gpif_status in the mantis_dev structure could be removed, thus
removing a dereference.


> Apr, 1 2012: [09/11] Correct wait_event_timeout error return check.                 http://patchwork.linuxtv.org/patch/10526  "Steinar H. Gunderson" <sesse@samfundet.no>

Patch is correct, but likely needs to be regenerated, being dependant on
another patch


> Apr, 1 2012: [10/11] Ignore timeouts waiting for the IRQ0 flag.                     http://patchwork.linuxtv.org/patch/10527  "Steinar H. Gunderson" <sesse@samfundet.no>

There is something really wrong going on. The CPU went into a loop and
hence reads do not return. Ignoring timeouts doesn't seem the proper way
to me.


> Apr, 1 2012: [11/11] Enable Mantis CA support.                                      http://patchwork.linuxtv.org/patch/10524  "Steinar H. Gunderson" <sesse@samfundet.no>

Not yet there.
