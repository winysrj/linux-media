Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56781 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3AGQbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 11:31:18 -0500
Received: by mail-ob0-f172.google.com with SMTP id za17so17670037obc.17
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 08:31:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130106113455.329ad868@redhat.com>
References: <20130106113455.329ad868@redhat.com>
Date: Mon, 7 Jan 2013 22:01:17 +0530
Message-ID: <CAHFNz9K1Jk16AC836STOqdpRR+ZhsTRcwDhn1Puqv9ykGw9wSA@mail.gmail.com>
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
> P.S.: This email is c/c to the developers where some action is expected.
>       If you were copied, please review the patches, acking/nacking or
>       submitting an update.
>
>
>                 == New patches ==
>
> Those patches require some review from the community:
>
> This one could break again DVB-S->DVB-S2 support, so, it needs to be
> carefully reviewed and tested:
>
> Jun,21 2012: [media] dvb frontend core: tuning in ISDB-T using DVB API v3           http://patchwork.linuxtv.org/patch/12988  Olivier Grenie <olivier.grenie@parrot.com>
>
> This one fix a code that, IMHO, should, instead be replaced by
> something better:
> Sep,17 2012: [3/3] cx25821: Cleanup filename assignment code                        http://patchwork.linuxtv.org/patch/14445  Peter Senna Tschudin <peter.senna@gmail.com>
>
> This one doesn't seem right for me. Anybody can test/work with it?
> Sep, 2 2012: fix: iMon Knob event interpretation issues                             http://patchwork.linuxtv.org/patch/16030  Alexandre Lissy <alexandrelissy@free.fr>
>
> I'm not sure if we should apply this one or not, as it will increase
> the probability of miss-interpreting a nec IR protocol. Comments?
> Jul,26 2012: media: rc: Add support to decode Remotes using NECx IR protocol        http://patchwork.linuxtv.org/patch/13480  Ravi Kumar V <kumarrav@codeaurora.org>
>
>
>                 == Manu Abraham <abraham.manu@gmail.com> ==
>
> Those patches are there for a long time. I think I'll simply apply all of
> them, if they're not reviewed on the next couple weeks:
>
> Mar,11 2012: [2/3] stv090x: use error counter 1 for BER estimation                  http://patchwork.linuxtv.org/patch/10301  Andreas Regel <andreas.regel@gmx.de>
> Mar,11 2012: [3/3] stv090x: On STV0903 do not set registers of the second path.     http://patchwork.linuxtv.org/patch/10302  Andreas Regel <andreas.regel@gmx.de>
> Nov,29 2011: stv090x: implement function for reading uncorrected blocks count       http://patchwork.linuxtv.org/patch/8656   Mariusz Bia?o?czyk <manio@skyboo.net>
> Jun, 8 2011: Add remote control support for mantis                                  http://patchwork.linuxtv.org/patch/7217   Christoph Pinkl <christoph.pinkl@gmail.com>
> Apr, 1 2012: [05/11] Slightly more friendly debugging output.                       http://patchwork.linuxtv.org/patch/10520  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [06/11] Replace ca_lock by a slightly more general int_stat_lock.      http://patchwork.linuxtv.org/patch/10521  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [07/11] Fix a ton of SMP-unsafe accesses.                              http://patchwork.linuxtv.org/patch/10523  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [08/11] Remove some unused structure members.                          http://patchwork.linuxtv.org/patch/10525  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [09/11] Correct wait_event_timeout error return check.                 http://patchwork.linuxtv.org/patch/10526  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [10/11] Ignore timeouts waiting for the IRQ0 flag.                     http://patchwork.linuxtv.org/patch/10527  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [11/11] Enable Mantis CA support.                                      http://patchwork.linuxtv.org/patch/10524  "Steinar H. Gunderson" <sesse@samfundet.no>


Somehow, these patches missed me. This weekend, I am traveling.
I will take a look at it during the weekend after that one.

Regards,
Manu
