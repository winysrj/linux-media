Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55033 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3JVK6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Oct 2013 06:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqVh1hzC0rzft9gD+4zmJpnpH9OKj64vyO4teCrX5wuT+g@mail.gmail.com>
References: <CAG-2HqX-TO7h8zJ6F01r2LfRVjQtb0pK_1wKGsYVKzB0zC7TQA@mail.gmail.com>
 <20131015215943.GC26542@hardeman.nu> <CAB+yVgCtvRHRLxP2SRgCAqkCKdyThgr48fOvBFe9YHfz3xArmQ@mail.gmail.com>
 <CAG-2HqVh1hzC0rzft9gD+4zmJpnpH9OKj64vyO4teCrX5wuT+g@mail.gmail.com>
From: =?UTF-8?Q?Juan_Jes=C3=BAs_Garc=C3=ADa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
Date: Tue, 22 Oct 2013 11:57:33 +0100
Message-ID: <CAB+yVgBKrEk-7JioddM_EHPfme=NFDqUQwa+=JH-7yA8-1gYFw@mail.gmail.com>
Subject: Re: WPC8769L (WEC1020) support in winbond-cir?
To: Tom Gundersen <teg@jklm.no>
Cc: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
	Sean Young <sean@mess.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried to find the hacked code, but it's not there anymore.

I have the docs, through, and a rough idea of what would have to be
done in order to support WEC1020 in winbond-cir.

I cannot tell when I will be able to put time into this, though :-(


Best regards,

    Juan.

2013/10/17 Tom Gundersen <teg@jklm.no>:
>
>
> On Wednesday, October 16, 2013, Juan Jesús García de Soria Lucena
> <skandalfo@gmail.com> wrote:
>> Hi there,
>>
>> 2013/10/15 David Härdeman <david@hardeman.nu>
>>>
>>> IIRC, Juan had a hacked-up version of the winbond-cir driver working on
>>> his hardware back in March (the hardware seems similar enough, basically
>>> the WEC1022 adds some additional Wake-On-IR functionality...I seem to
>>> recall).
>>
>> I did indeed look at this at the time. I still have the hardware, should
>> have the hardware docs somewhere, and can look at where I left that hacked
>> code at the time...
>> I really would have liked to merge in the support for it into winbond-cir,
>> but real life took over.
>>>
>>> But I think Juan is the one to talk to. I don't have the WEC1020
>>> hardware and I don't have his experience of adding support for it...
>>
>> As I said, I still have the hardware around. I might get some time around
>> this weekend to look at it and come back with at least an idea of what is
>> left to be done.
>
> Thanks for taking a look.
>
> Cheers,
>
> Tom



-- 
:wq
