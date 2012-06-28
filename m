Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45097 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F1NZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 09:25:50 -0400
Received: by werb14 with SMTP id b14so402074wer.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 06:25:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+MoWDrBaVAStQwQKrWb+CuNTZHuXJBuewgLJbu9ZrBg7rrJVg@mail.gmail.com>
References: <1340835544-12053-1-git-send-email-peter.senna@gmail.com>
	<CALF0-+XZybEFqndCEo4nGGH-achE5CuYOsC+EXiH-k06GSB5vA@mail.gmail.com>
	<CA+MoWDrBaVAStQwQKrWb+CuNTZHuXJBuewgLJbu9ZrBg7rrJVg@mail.gmail.com>
Date: Thu, 28 Jun 2012 10:25:49 -0300
Message-ID: <CA+MoWDq32652XAP9fMsUYiFncFCSGxqPnhXYRQMj33YNvFb88g@mail.gmail.com>
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

On Thu, Jun 28, 2012 at 10:17 AM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> Hey Ezequiel,
>
> On Thu, Jun 28, 2012 at 1:02 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> Hey Peter,
>>
>> On Wed, Jun 27, 2012 at 7:18 PM, Peter Senna Tschudin
>> <peter.senna@gmail.com> wrote:
>>> -                       no_signal = stv090x_chk_signal(state);
>>> +                       (void) stv090x_chk_signal(state);
>>
>> Why are you casting return to void? I can't see there is a reason to it.
> The idea is to tell the compiler that I know that stv090x_chk_signal()
> return a value and I want to ignore it. It is to prevent the compiler
> to issue warn_unused_result. I found two ways of doing it. First is
> casting the return to void, second is to change the function
> definition adding the macro __must_check defined at <linux/compiler.c>
 defined at <linux/compiler.h>
> like on:
>
> http://lxr.linux.no/linux+v3.4.4/include/linux/kernel.h#L215
>
> The (void) solution looked simpler to me, but I'll be happy to change
> to the __must_check solution if better. What do you think? Keep as is?
> Add a comment? Change to __must_check?
>
>
>
>
>>
>> Regards,
>> Ezequiel.
>
> Regards,
>
> Peter
>
> --
> Peter Senna Tschudin
> peter.senna@gmail.com
> gpg id: 48274C36



-- 
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36
