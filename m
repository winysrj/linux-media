Return-path: <linux-media-owner@vger.kernel.org>
Received: from shark3.inbox.lv ([194.152.32.83]:55432 "EHLO shark3.inbox.lv"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933565AbeEWRSp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 13:18:45 -0400
Subject: Re: Bugfix for Tevii S650
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Olli Salonen <olli.salonen@iki.fi>
References: <897fac42-1456-c2ad-94be-3aee64df18d6@inbox.lv>
 <CAHp75VfsJUSAV0TPkcSOMrZedqhcM117JFtH-xHFAJKLPDqQ9A@mail.gmail.com>
From: Light <light23@inbox.lv>
Message-ID: <56b188e7-d5b4-f9d0-a887-d501f4a5f49d@inbox.lv>
Date: Wed, 23 May 2018 19:18:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAHp75VfsJUSAV0TPkcSOMrZedqhcM117JFtH-xHFAJKLPDqQ9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Cc: Olli

The problem started with this commit. it added function 
dw2102_disconnect() to dw2102.c

author     Olli Salonen <olli.salonen@xxxxx>    2015-03-16 17:14:05 (GMT)
committer    Mauro Carvalho Chehab <mchehab@xxxxxxxx> 2015-04-03 
01:24:01 (GMT)
commit    70769b24d2973428907de3429dd2a5792e4ce317 (patch)

[media] dw2102: store i2c client for tuner into dw2102_state


On 21.05.2018 22:30, Andy Shevchenko wrote:
> +Cc: Mauro
>
> On Mon, May 21, 2018 at 3:01 PM, Light <light23@xxxxx> wrote:
>> Hi,
>>
>> starting with kernel 4.1 the tevii S650 usb box is not working any more, last
>> working version was 4.0.
>>
>> The  bug was also reported here
>> https://www.spinics.net/lists/linux-media/msg121356.html
>>
>> I found a solution for it and uploaded a patch to the kernel bugzilla.
>>
>> See here: https://bugzilla.kernel.org/show_bug.cgi?id=197731
>>
>> Can somebody of the maintainers have a look on it and apply the patch to the
>> kernes sources?
> You forget to Cc to maintainers (at least Mauro).
>
