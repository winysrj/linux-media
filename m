Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35134 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410AbcAKPz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 10:55:29 -0500
Received: by mail-ig0-f177.google.com with SMTP id t15so98146224igr.0
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 07:55:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhKH7LM2o0ppmJx5BK_3e3iT8sEixg2AMHN9ueBMjB9AKA@mail.gmail.com>
References: <CAJ2oMhJVjKrfXEKx6xnGQkEpcSWBywabrDwy9biJkhjmnZ7Kbg@mail.gmail.com>
	<5693930C.9050001@xs4all.nl>
	<CAJ2oMhKH7LM2o0ppmJx5BK_3e3iT8sEixg2AMHN9ueBMjB9AKA@mail.gmail.com>
Date: Mon, 11 Jan 2016 17:55:28 +0200
Message-ID: <CAJ2oMhLP5F=6JBi9S4SsuZ=L1GecuV694md7mgqfKR2uEGTr2A@mail.gmail.com>
Subject: Re: vivid - add support for YUV420
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 1:58 PM, Ran Shalit <ranshalit@gmail.com> wrote:
> On Mon, Jan 11, 2016 at 1:33 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 01/09/2016 10:58 AM, Ran Shalit wrote:
>>> Hello,
>>>
>>> I've been doing some tests with capturing video from virtual driver (vivid).
>>> I've tried to force it to YUV420, but it ignores that, becuase it does
>>> not support this format.
>>
>> Yes, it does. What kernel are you using? Something old? Support for 4:2:0 was
>> added to vivid in March 2015.
>>
>>> I would please like to ask if there is some way I can output YUV420
>>> format with vivi.
>>
>> Upgrade your kernel :-)
>
> Right.
> The kernel in Cent0S 7.2 (last release) is 3.10.0.
> I am not sure I can update CentOS with kernel.org last release because
> of probably many dependencies ( Is it possible ?)
> Anyway, vivid , is life saving tool for newcomers. Absolutely.
>
> Regards,
> Ran
>


Hi,

Do you think it worth trying to upgrade vivid package only from 3.10
(vivi) to 3.18 (vivid),
or is it too complex to try and depend on many other files ?

Thanks,
Ran
