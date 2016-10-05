Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:32819 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752248AbcJEQzX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2016 12:55:23 -0400
Received: by mail-ua0-f170.google.com with SMTP id p102so44623913uap.0
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2016 09:55:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADDKRnB13h4cZN7y_EumnbcxK_Bj6evntx56Ya9WuZ3fYCJTBg@mail.gmail.com>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
 <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm> <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
 <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm> <20161005093417.6e82bd97@vdr>
 <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm> <20161005060450.1b0f2152@vento.lan>
 <CADDKRnABN_PoUtXGv3Rnbcc8FmgUFyLRm27KzShyK+9UPM3mqQ@mail.gmail.com>
 <CALCETrVWYfijXeuKzk6FDDReaKXXP6Wck=80wtTohS8JpJND6A@mail.gmail.com> <CADDKRnB13h4cZN7y_EumnbcxK_Bj6evntx56Ya9WuZ3fYCJTBg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 5 Oct 2016 09:55:01 -0700
Message-ID: <CALCETrU-k_JwfH62LQ5i__1PRF2ta3yrEWojvGByUdXXOt8d8Q@mail.gmail.com>
Subject: Re: Problem with VMAP_STACK=y
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 5, 2016 at 9:45 AM, J=C3=B6rg Otte <jrg.otte@gmail.com> wrote:
> 2016-10-05 17:53 GMT+02:00 Andy Lutomirski <luto@amacapital.net>:
>> On Wed, Oct 5, 2016 at 8:21 AM, J=C3=B6rg Otte <jrg.otte@gmail.com> wrot=
e:
>>> 2016-10-05 11:04 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.=
com>:
>>>> Em Wed, 5 Oct 2016 09:50:42 +0200 (CEST)
>>>> Jiri Kosina <jikos@kernel.org> escreveu:
>>>>
>>>>> On Wed, 5 Oct 2016, Patrick Boettcher wrote:
>>>>>
>>>>> > > > Thanks for the quick response.
>>>>> > > > Drivers are:
>>>>> > > > dvb_core, dvb_usb, dbv_usb_cynergyT2
>>>>> > >
>>>>> > > This dbv_usb_cynergyT2 is not from Linus' tree, is it? I don't se=
em
>>>>> > > to be able to find it, and the only google hit I am getting is yo=
ur
>>>>> > > very mail to LKML :)
>>>>> >
>>>>> > It's a typo, it should say dvb_usb_cinergyT2.
>>>>>
>>>>> Ah, thanks. Same issues there in
>>>>>
>>>>>       cinergyt2_frontend_attach()
>>>>>       cinergyt2_rc_query()
>>>>>
>>>>> I think this would require more in-depth review of all the media driv=
ers
>>>>> and having all this fixed for 4.9. It should be pretty straightforwar=
d;
>>>>> all the instances I've seen so far should be just straightforward
>>>>> conversion to kmalloc() + kfree(), as the buffer is not being embedde=
d in
>>>>> any structure etc.
>>>>
>>>> What we're doing on most cases is to put a buffer (usually with 80
>>>> chars for USB drivers) inside the "state" struct (on DVB drivers),
>>>> in order to avoid doing kmalloc/kfree all the times. One such patch is
>>>> changeset c4a98793a63c4.
>>>>
>>>> I'm enclosing a non-tested patch fixing it for the cinergyT2-core.c
>>>> driver.
>>>>
>>>> Thanks,
>>>> Mauro
>>>>
>>>> [PATCH] cinergyT2-core: don't do DMA on stack
>>>>
>>>
>>> Tried the cinergyT2 patch. No success. When I select a TV channel
>>> just nothing happens. There are no error messages.
>>
>> Could you try compiling with CONFIG_DEBUG_VIRTUAL=3Dy and seeing if you
>> get a nice error message?
>>
>> --Andy
>
> Done. Still no error messages in dmesg and syslog.
>
> DVB adapter signals it is tuned to the channel.
> For me it looks like there`s no data reaching the application
> (similar to if I forget to connect an antenna).

I'm surprised.  CONFIG_DEBUG_VIRTUAL=3Dy really ought to have caught the
problem, whatever it is.  You could try CONFIG_DEBUG_SG as well, but I
admit I'm grasping at straws there.  Maybe the DVB people have a
better idea as to what's going on here.

It's plausible that the patch you're testing got rid of the DMA on the
stack but is otherwise buggy.

--Andy
