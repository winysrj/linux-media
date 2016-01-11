Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35902 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304AbcAKL6x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 06:58:53 -0500
Received: by mail-io0-f169.google.com with SMTP id g73so149601473ioe.3
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 03:58:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5693930C.9050001@xs4all.nl>
References: <CAJ2oMhJVjKrfXEKx6xnGQkEpcSWBywabrDwy9biJkhjmnZ7Kbg@mail.gmail.com>
	<5693930C.9050001@xs4all.nl>
Date: Mon, 11 Jan 2016 13:58:51 +0200
Message-ID: <CAJ2oMhKH7LM2o0ppmJx5BK_3e3iT8sEixg2AMHN9ueBMjB9AKA@mail.gmail.com>
Subject: Re: vivid - add support for YUV420
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 1:33 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 01/09/2016 10:58 AM, Ran Shalit wrote:
>> Hello,
>>
>> I've been doing some tests with capturing video from virtual driver (vivid).
>> I've tried to force it to YUV420, but it ignores that, becuase it does
>> not support this format.
>
> Yes, it does. What kernel are you using? Something old? Support for 4:2:0 was
> added to vivid in March 2015.
>
>> I would please like to ask if there is some way I can output YUV420
>> format with vivi.
>
> Upgrade your kernel :-)

Right.
The kernel in Cent0S 7.2 (last release) is 3.10.0.
I am not sure I can update CentOS with kernel.org last release because
of probably many dependencies ( Is it possible ?)
Anyway, vivid , is life saving tool for newcomers. Absolutely.

Regards,
Ran


> BTW, please don't use vivi to refer to the vivid driver. There used to be an
> older vivi driver that was replaced by vivid, so calling the vivid driver 'vivi'
> is very confusing to me :-)
>
> Regards,
>
>         Hans
>
>>
>> Best Regards,
>> Ran
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
