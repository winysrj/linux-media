Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35982 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932230AbcJEPxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2016 11:53:33 -0400
Received: by mail-vk0-f46.google.com with SMTP id y190so194188159vkd.3
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2016 08:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADDKRnABN_PoUtXGv3Rnbcc8FmgUFyLRm27KzShyK+9UPM3mqQ@mail.gmail.com>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
 <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm> <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
 <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm> <20161005093417.6e82bd97@vdr>
 <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm> <20161005060450.1b0f2152@vento.lan>
 <CADDKRnABN_PoUtXGv3Rnbcc8FmgUFyLRm27KzShyK+9UPM3mqQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 5 Oct 2016 08:53:11 -0700
Message-ID: <CALCETrVWYfijXeuKzk6FDDReaKXXP6Wck=80wtTohS8JpJND6A@mail.gmail.com>
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

On Wed, Oct 5, 2016 at 8:21 AM, J=C3=B6rg Otte <jrg.otte@gmail.com> wrote:
> 2016-10-05 11:04 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.co=
m>:
>> Em Wed, 5 Oct 2016 09:50:42 +0200 (CEST)
>> Jiri Kosina <jikos@kernel.org> escreveu:
>>
>>> On Wed, 5 Oct 2016, Patrick Boettcher wrote:
>>>
>>> > > > Thanks for the quick response.
>>> > > > Drivers are:
>>> > > > dvb_core, dvb_usb, dbv_usb_cynergyT2
>>> > >
>>> > > This dbv_usb_cynergyT2 is not from Linus' tree, is it? I don't seem
>>> > > to be able to find it, and the only google hit I am getting is your
>>> > > very mail to LKML :)
>>> >
>>> > It's a typo, it should say dvb_usb_cinergyT2.
>>>
>>> Ah, thanks. Same issues there in
>>>
>>>       cinergyt2_frontend_attach()
>>>       cinergyt2_rc_query()
>>>
>>> I think this would require more in-depth review of all the media driver=
s
>>> and having all this fixed for 4.9. It should be pretty straightforward;
>>> all the instances I've seen so far should be just straightforward
>>> conversion to kmalloc() + kfree(), as the buffer is not being embedded =
in
>>> any structure etc.
>>
>> What we're doing on most cases is to put a buffer (usually with 80
>> chars for USB drivers) inside the "state" struct (on DVB drivers),
>> in order to avoid doing kmalloc/kfree all the times. One such patch is
>> changeset c4a98793a63c4.
>>
>> I'm enclosing a non-tested patch fixing it for the cinergyT2-core.c
>> driver.
>>
>> Thanks,
>> Mauro
>>
>> [PATCH] cinergyT2-core: don't do DMA on stack
>>
>
> Tried the cinergyT2 patch. No success. When I select a TV channel
> just nothing happens. There are no error messages.

Could you try compiling with CONFIG_DEBUG_VIRTUAL=3Dy and seeing if you
get a nice error message?

--Andy
