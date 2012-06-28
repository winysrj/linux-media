Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52835 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2F1Nz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 09:55:57 -0400
Received: by wgbdr13 with SMTP id dr13so2229857wgb.1
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 06:55:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+VFCf9vr=T3GHauuye1CiOHeGNfC7hrecWzs=2jAtQQ4w@mail.gmail.com>
References: <1340835544-12053-1-git-send-email-peter.senna@gmail.com>
	<CALF0-+XZybEFqndCEo4nGGH-achE5CuYOsC+EXiH-k06GSB5vA@mail.gmail.com>
	<CA+MoWDrBaVAStQwQKrWb+CuNTZHuXJBuewgLJbu9ZrBg7rrJVg@mail.gmail.com>
	<CALF0-+VFCf9vr=T3GHauuye1CiOHeGNfC7hrecWzs=2jAtQQ4w@mail.gmail.com>
Date: Thu, 28 Jun 2012 10:55:55 -0300
Message-ID: <CA+MoWDr6G0Uij-tYPmwG21HSV86m+V36MVuXapF2aY88oG4oKg@mail.gmail.com>
Subject: Re: [PATCH] [V2] stv090x: variable 'no_signal' set but not used
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guy Martin <gmsoft@tuxicoman.be>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2012 at 10:41 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Thu, Jun 28, 2012 at 10:17 AM, Peter Senna Tschudin
> <peter.senna@gmail.com> wrote:
>> Hey Ezequiel,
>>
>> On Thu, Jun 28, 2012 at 1:02 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>> Hey Peter,
>>>
>>> On Wed, Jun 27, 2012 at 7:18 PM, Peter Senna Tschudin
>>> <peter.senna@gmail.com> wrote:
>>>> -                       no_signal = stv090x_chk_signal(state);
>>>> +                       (void) stv090x_chk_signal(state);
>>>
>>> Why are you casting return to void? I can't see there is a reason to it.
>> The idea is to tell the compiler that I know that stv090x_chk_signal()
>> return a value and I want to ignore it. It is to prevent the compiler
>> to issue warn_unused_result. I found two ways of doing it. First is
>> casting the return to void, second is to change the function
>> definition adding the macro __must_check defined at <linux/compiler.c>
>> like on:
>
> This would be true if stv090x_chk_signal() would be declared with __must_check.
> But this is not the case, so I think you should try to just ignore the result.
>
> I'm pretty sure you won't find any warning at all from the compiler.
You are right! Thanks. I'll do V3 of the patch.


>
> Regards,
> Ezequiel.



-- 
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36
