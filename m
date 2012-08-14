Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab2HNNXO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 09:23:14 -0400
Message-ID: <502A5139.8080402@redhat.com>
Date: Tue, 14 Aug 2012 10:23:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	linuxtv-commits@linuxtv.org
Subject: Re: [git:v4l-dvb/for_v3.7] [media] mantis: Terratec Cinergy C PCI
 HD (CI)
References: <E1SzvhW-0005hd-1S@www.linuxtv.org> <CAHFNz9Ju7dB-iz0mcGuNMLDwibFXZqGe73jpBk7RPqG_w+MmXg@mail.gmail.com> <5029548E.90901@redhat.com> <CAHFNz9+qWXYkvJXeZfSu2DgAQ3BrsX591TS5x+XeEOVji3Hx2g@mail.gmail.com>
In-Reply-To: <CAHFNz9+qWXYkvJXeZfSu2DgAQ3BrsX591TS5x+XeEOVji3Hx2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-08-2012 04:45, Manu Abraham escreveu:
> On Tue, Aug 14, 2012 at 12:55 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 10-08-2012 20:55, Manu Abraham escreveu:
>>> Mauro,
>>>
>>> Please revert this patch. Patch is incorrect. There is the VP-20300,
>>> VP-20330, VP-2040, with differences in tuner types TDA10021, TDA10023,
>>> MK-I, MK-II and MK-III. I have detailed this issue in an earlier mail.
>>> Terratec Cinregy C is VP-2033 and not VP-2040.
>>
>> Well, as I don't have this board, you think that it is a VP-2033 while
>> Igor thinks it is a VP-2040, I can't tell who is right on that.
> 
> You don't need all the cards to apply changes, that's how the Linux
> patchland works.
> 
> I have "all" Mantis based devices here. So I can say with clarity that
> Terratec Cinergy C is VP-2033. I authored the whole driver for the
> chipset manufacturer and the card manufacturer and still in touch with
> all of them and pretty sure what is what.
>
> Any idiot can send any patch, that's why you need to ask the persons
> who added particular changes in that area.

Yes, you authored the driver, but that doesn't necessarily means that
you'll have all clones of VP-2033/VP-2040.

> Do you want me to add
> myself to MAINTAINERS to make it a bit more clearer, if that's what
> you prefer ?

If you're wiling to maintain it, not holding patches for more than the
few days required for their review, then YES!!! 

Please add yourself to the MAINTAINERS for the drivers you're willing
to maintain and submit me such patch for upstream merging.

> Please revert this change.

I'll do.

Regards,
Mauro
