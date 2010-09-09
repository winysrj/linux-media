Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38482 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0IIEog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 00:44:36 -0400
Received: by qyk36 with SMTP id 36so5551749qyk.19
        for <linux-media@vger.kernel.org>; Wed, 08 Sep 2010 21:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100908214213.GD13938@hardeman.nu>
References: <20100907214943.30935.29895.stgit@localhost.localdomain>
	<20100907215143.30935.71857.stgit@localhost.localdomain>
	<4C8792B2.2010809@infradead.org>
	<20100908214213.GD13938@hardeman.nu>
Date: Thu, 9 Sep 2010 00:44:34 -0400
Message-ID: <AANLkTimwWs44woVz+0g2c-+OibbVBObz1-COM2kL11Cd@mail.gmail.com>
Subject: Re: [PATCH 1/5] rc-code: merge and rename ir-core
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, jarod@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 8, 2010 at 5:42 PM, David Härdeman <david@hardeman.nu> wrote:
> On Wed, Sep 08, 2010 at 10:42:10AM -0300, Mauro Carvalho Chehab wrote:
>> Em 07-09-2010 18:51, David Härdeman escreveu:
>> > This patch merges the files which makes up ir-core and renames the
>> > resulting module to rc-core. IMHO this makes it much easier to hack
>> > on the core module since all code is in one file.
>> >
>> > This also allows some simplification of ir-core-priv.h as fewer internal
>> > functions need to be exposed.
>>
>> I'm not sure about this patch. Big files tend to be harder to maintain,
>> as it takes more time to find the right functions inside it. Also, IMO,
>> it makes sense to keep the raw-event code on a separate file.
>
> I don't find "big" files difficult (note: we're talking about 1300 lines
> here).  Rather the opposite, no hesitation about which files a given
> function originates from and all related code in one nice file. evdev.c
> and input.c are good precedents. But of course, it all boils down to a
> matter of personal taste.

I think I have to finally admit that my personal taste tends toward
one "big" file in this particular case.

>> Anyway, if we apply this patch right now, it will cause merge conflicts with
>> the input tree, due to the get/setkeycodebig patches, and with some other
>> patches that are pending merge/review. The better is to apply such patch
>> just after the release of 2.6.37-rc1, after having all those conflicts
>> solved.
>
> I agree that the big scancode patches from the input tree should go
> first. I keep updating my patchset as the media_tree (staging/v2.6.37
> branch) changes so I have no problem sending an updated patchset at a
> suitable time in the future.

Please feel free to add this to the subsequent refreshes:

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
