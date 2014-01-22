Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:59270 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbaAVP0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 10:26:03 -0500
Received: by mail-ve0-f176.google.com with SMTP id oz11so310933veb.35
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 07:26:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNXs0dH-HoF792PQL_XqnO5OYzRmG2a3f8gt5CmB9JO0aQ@mail.gmail.com>
References: <CAGj5WxCajB0ORTQ_rz9wv+ec9bXE1A9tM_MGP3qb0eyaxhC5ew@mail.gmail.com>
	<CAHFNz9KzKdC0xvq7nM6yF0DGQ3pCq7tUr0et-cvf6Wk5Htarxg@mail.gmail.com>
	<CALzAhNW=uCLsu4sdrGyycxRoOdaRTFNM8yVj=Y+ahSZrWqrABg@mail.gmail.com>
	<CAHFNz9+Z9oBwezNURpOhoCn3Rk-HWHdZSh7CK7SopkPPv7Z6Qg@mail.gmail.com>
	<CALzAhNXs0dH-HoF792PQL_XqnO5OYzRmG2a3f8gt5CmB9JO0aQ@mail.gmail.com>
Date: Wed, 22 Jan 2014 20:56:01 +0530
Message-ID: <CAHFNz9KyEm=2GreevUzrdwWun8V3vzrgHE9yU389i59aKt=-uw@mail.gmail.com>
Subject: Re: Upstreaming SAA716x driver to the media_tree
From: Manu Abraham <abraham.manu@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Luis Alves <ljalvs@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Andreas Regel <andreas.regel@gmx.de>,
	Chris Lee <updatelee@gmail.com>, crazycat69@narod.ru,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 22, 2014 at 3:29 AM, Steven Toth <stoth@kernellabs.com> wrote:
> On Mon, Jan 13, 2014 at 10:35 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> On Tue, Jan 14, 2014 at 12:20 AM, Steven Toth <stoth@kernellabs.com> wrote:
>>>>> Manu, do you see any inconvenience in sending your driver to the
>>>>> linux_media tree?
>>>>> I'm available to place some effort on this task.
>>>>
>>>>
>>>> I can push the 716x driver and whatever additional changes that I have
>>>> later on this weekend, if that's okay with you.
>>>
>>> I never saw a push.
>>
>> Spliiting and cleaning up the patches took up more time than expected.
>> Please wait a few days.
>
> Any news on this?


I just pushed out a large chunk of the changes. There are a few
dependencies that need to be resolved with the rebased tree.
