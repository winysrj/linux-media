Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:61081 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3EaPYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 11:24:00 -0400
Received: by mail-ie0-f181.google.com with SMTP id x14so4283555ief.40
        for <linux-media@vger.kernel.org>; Fri, 31 May 2013 08:23:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+V5mShZmVt=gJmA6dAH+3JGtJFv-UOxCbbWoPtZvf1+SA@mail.gmail.com>
References: <CAA1g13mVO_buU8AeROBT3qSXsS2EQtAvHVHdEo5-RGMcRYC47A@mail.gmail.com>
	<CALF0-+XcBRxqOb5gARG9JkFNoubXouHv_MHqC7paS5E5M7oSUg@mail.gmail.com>
	<CAA1g13n2GknjeCZ2fJbXH1trz8aog01BqEB_JwqU8QX9bda2Cg@mail.gmail.com>
	<CALF0-+V5mShZmVt=gJmA6dAH+3JGtJFv-UOxCbbWoPtZvf1+SA@mail.gmail.com>
Date: Fri, 31 May 2013 11:23:59 -0400
Message-ID: <CAA1g13=i8XC=NbKeazO90eOXNMMhcK=MT1S+pXJ_SQFLMjoCSA@mail.gmail.com>
Subject: Re: Unrecognized decoder chip (not gm7113c)
From: Greg Horvath <horvath.105@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am not sure how much work it would take to upgrade this particular
kernel to 3.7+. The code for it came from
https://github.com/olegk0/rk3066-kernel but I think it differs
significantly from the main line structure and has several custom
drivers. I will try and get a 3.7 kernel running on an x86 machine and
see if I can get it to run though. Thanks for taking the time to
investigate.

On Thu, May 30, 2013 at 6:12 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Thu, May 30, 2013 at 6:22 PM, Greg Horvath <horvath.105@gmail.com> wrote:
>> I am not running them at the same time. There are two sets of dmesg output.
>> One for the stk1160 driver and the other when I attempted to load easycap
>> driver without loading stk1160.
>>
>>
>
> Right. In that case you can forget about the "easycap" driver.
> I can only help you getting your stuff working with stk1160.
>
> Do you have any chance to upgrade your kernel to a v3.7+ ?
>
> Keep in mind it's very unlikely that you'll get much support from the community
> using such an ancient kernel, and with a driver that you backported yourself
> (although I'll investigate this a bit).
>
> --
>     Ezequiel
