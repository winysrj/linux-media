Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64034 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2F1NlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 09:41:18 -0400
Received: by obbuo13 with SMTP id uo13so3039722obb.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 06:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+MoWDrBaVAStQwQKrWb+CuNTZHuXJBuewgLJbu9ZrBg7rrJVg@mail.gmail.com>
References: <1340835544-12053-1-git-send-email-peter.senna@gmail.com>
	<CALF0-+XZybEFqndCEo4nGGH-achE5CuYOsC+EXiH-k06GSB5vA@mail.gmail.com>
	<CA+MoWDrBaVAStQwQKrWb+CuNTZHuXJBuewgLJbu9ZrBg7rrJVg@mail.gmail.com>
Date: Thu, 28 Jun 2012 10:41:18 -0300
Message-ID: <CALF0-+VFCf9vr=T3GHauuye1CiOHeGNfC7hrecWzs=2jAtQQ4w@mail.gmail.com>
Subject: Re: [PATCH] [V2] stv090x: variable 'no_signal' set but not used
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
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
> like on:

This would be true if stv090x_chk_signal() would be declared with __must_check.
But this is not the case, so I think you should try to just ignore the result.

I'm pretty sure you won't find any warning at all from the compiler.

Regards,
Ezequiel.
