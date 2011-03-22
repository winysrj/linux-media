Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57857 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab1CVUyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 16:54:45 -0400
Received: by wwa36 with SMTP id 36so9331198wwa.1
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 13:54:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8888F7.6010903@t-online.de>
References: <4D87AB0F.4040908@t-online.de>
	<20110321131602.36d146b1.rdunlap@xenotime.net>
	<AANLkTik22=YE-2W4AtO9w_kVm=oro_YM7hJ52Rj83Fmt@mail.gmail.com>
	<4D8888F7.6010903@t-online.de>
Date: Wed, 23 Mar 2011 02:24:44 +0530
Message-ID: <AANLkTimDww0692UN-HYfatcK5WFouPQYtZz0BF1EGR0Q@mail.gmail.com>
Subject: Re: S2-3200 switching-timeouts on 2.6.38
From: Manu Abraham <abraham.manu@gmail.com>
To: Rico Tzschichholz <ricotz@t-online.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Rico,

On Tue, Mar 22, 2011 at 5:03 PM, Rico Tzschichholz <ricotz@t-online.de> wrote:
> Hello Manu,
>
>> Actually, quite a lot of effort was put in to get that part right. It
>> does the reverse thing that's to be done.
>> The revamped version is here [1] If the issue persists still, then it
>> needs to be investigated further.
>>
>> [1] http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.html
>
> I am not sure how this is related to stb6100?
>
> Does that mean the current stb0899 patch [2] isnt ready to be proposed
> for 2.6.39 yet? Or does the stb6100 patch has a better design to solve
> this issue which should be adapted for stb0899 then?
> I was hoping to see it included before the merge window is closed again.
>
> [2] https://patchwork.kernel.org/patch/244201/


stb0899 is a channel decoder (or demodulator in other words) while the
stb6100 is a
tuner which provides I-Q components to the demod.

When a tuner locks to a transponder, in the spectrum in the absence of
a signal, it will be contain White (Gaussian) noise. In such a case
the demod has a hard time to lock to the signal. In this particular
case, we had a bit of luck additionally, ie we  found a case where the
stb0899 demodulator functioned perfectly well with another tuner, but
with the same hardware configuration. This helped in narrowing the bug
to the tuner and hence the fix.

The one in patchwork, does modify the step size but that doesn't
reduce the white noise, which is something like a lucky dip. (similar
to what Bjorn pointed out in another post.) I am not really sure
whether modifying the step size of any benefit/disadvantage, but need
to do some research on that aspect.

Best Regards,
Manu
]
