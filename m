Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51230 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab1DDX32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 19:29:28 -0400
Received: by vxi39 with SMTP id 39so4564259vxi.19
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2011 16:29:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B6690ADE-0D4F-4E22-8AB2-DB68AD43E749@dons.net.au>
References: <mailman.466.1301890961.26790.linux-dvb@linuxtv.org>
	<SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl>
	<BANLkTimEtbx6HkqBQLBTc7XX_wEYgs7fJg@mail.gmail.com>
	<F8BDDD6D-6870-4291-99C9-D8FCABFEEB05@dons.net.au>
	<BANLkTimBYhq_Ag3nkU1105Em0-AXvMiQbQ@mail.gmail.com>
	<B6690ADE-0D4F-4E22-8AB2-DB68AD43E749@dons.net.au>
Date: Tue, 5 Apr 2011 09:29:27 +1000
Message-ID: <BANLkTinkRdq4=5tHYvCfvsKAisnq=Xt00Q@mail.gmail.com>
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
From: Nathan Stitt <nathan.j.stitt@gmail.com>
To: "Daniel O'Connor" <darius@dons.net.au>
Cc: Vincent McIntyre <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I have this card.

It had been working fine on 2.6.32 kernels, even using both tuners.
Only complaint was that the stream from one transponder was always
rubbish (but that channel had rubbish shows mostly anyway, so, meh).

Upgrading to a 2.6.35 kernel in an attempt to have a newly added card
supported, seems to have fixed that problem.

However now if both tuners are in use, with one of them on another
particular transponder (different to the previous problematic one),
the recordings fail, with mythtv saying:

2011-04-03 19:56:53.271 DVBRec(10:/dev/dvb/adapter3/frontend0) Error:
Stream handler died unexpectedly.
2011-04-03 19:56:53.272 DVBRec(7:/dev/dvb/adapter2/frontend0) Error:
Stream handler died unexpectedly.

/var/log/messages doesn't say anything about this card around that time.

If only one of the tuners on the card is recording from that
transponder, it works fine. It only fails when both tuners are in use.
It doesn't matter whether the problematic transponder was tuned
before, simultaneously or after the other.

I've since started running with the latest v4l releases, however the
problem remains.

On 5 April 2011 08:57, Daniel O'Connor <darius@dons.net.au> wrote:
>
> On 05/04/2011, at 8:18, Vincent McIntyre wrote:
>> On 4/4/11, Daniel O'Connor <darius@dons.net.au> wrote:
>>>
>>> I take it you use both tuners? I find I can only use one otherwise one of
>>> them hangs whatever app is using it.
>>>
>>
>> I do. I haven't tested very carefully that I can use both tuners at
>> once successfully but I am pretty sure there have been times when both
>> have been running. I only use them with mythtv,
>> unless I am testing something like new v4l modules and in that case I
>> just use one tuner at a time.
>>
>> The box has two tuner cards, and this one is usually the second one in
>> the enumeration.
>
> OK. I only have the one (dual tuner) card but I find that if I enable it mythtv eventually hangs opening one of them.
>
> Perhaps the recent locking changes for that driver will help..
>
> --
> Daniel O'Connor software and network engineer
> for Genesis Software - http://www.gsoft.com.au
> "The nice thing about standards is that there
> are so many of them to choose from."
>  -- Andrew Tanenbaum
> GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
