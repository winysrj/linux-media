Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:38982 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaBKSOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 13:14:19 -0500
Received: by mail-qa0-f50.google.com with SMTP id cm18so12085872qab.23
        for <linux-media@vger.kernel.org>; Tue, 11 Feb 2014 10:14:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2457095.pZsX4lrjVF@radagast>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
	<52F8AA42.2020409@imgtec.com>
	<CAKv9HNZj2Jr4GnHXAtvqfaVsmQFVUxBmZZT-rBePoHB0X8ShiA@mail.gmail.com>
	<2457095.pZsX4lrjVF@radagast>
Date: Tue, 11 Feb 2014 20:14:19 +0200
Message-ID: <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 February 2014 22:50, James Hogan <james.hogan@imgtec.com> wrote:
>> > I suspect it needs some more space at the end too, to be sure that no
>> > more bits afterwards are accepted.
>>
>> I'm sorry but I'm not sure I completely understood what you meant
>> here. For RC-5-SZ the entire scancode gets encoded and nothing more.
>> Do you mean that the encoder should append some ir silence to the end
>> result to make sure the ir sample has ended?
>
> Yeh something like that. Certainly the raw decoders I've looked at expect a
> certain amount of space at the end to avoid decoding part of a longer protocol
> (it's in the pulse distance helper as the trailer space timing). Similarly the
> IMG hardware decoder has register fields for the free-time to require at the
> end of the message.
>
> In fact it becomes a bit awkward for the raw IR driver for the IMG hardware
> which uses edge interrupts, as it has to have a timeout to emit a final repeat
> event after 150ms of inactivity, in order for the raw decoders to accept it
> (unless you hold the button down in which case the repeat code edges result in
> the long space).
>

Ok, I understand now.

I suppose I can append some IR silence to the encoded result. The
trailer space timing seems like a good way to do it. I'll create new
version of my patches sometime later.

Are you working on the wakeup protocol selector sysfs interface?

-Antti
