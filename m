Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44237 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2I3TWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Sep 2012 15:22:53 -0400
Received: by oagh16 with SMTP id h16so4420954oag.19
        for <linux-media@vger.kernel.org>; Sun, 30 Sep 2012 12:22:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixuTTcwmYXk+9mFsjYnQjPn3CtqLDGxRCz_NCnWGAyKRQ@mail.gmail.com>
References: <CAJEuUsudgQHSktrDwHfELcUC0PMiRHmSw8S8buLcOGUFBqJ9Jw@mail.gmail.com>
 <CAGoCfixuTTcwmYXk+9mFsjYnQjPn3CtqLDGxRCz_NCnWGAyKRQ@mail.gmail.com>
From: =?UTF-8?Q?Ladislav_J=C3=B3zsa?= <l.jozsa@gmail.com>
Date: Sun, 30 Sep 2012 21:22:33 +0200
Message-ID: <CAJEuUssC8nm8MYGqsACBvABcdudDQhS=AnGXpTzSFPZLJK3qyA@mail.gmail.com>
Subject: Re: DiBcom 7000PC: Not able to scan for services on Raspberry Pi
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 30, 2012 at 4:55 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sat, Sep 29, 2012 at 3:34 PM, Ladislav Józsa <l.jozsa@gmail.com> wrote:
>> Running the same on my x86_64 machine works and tvheadend sees
>> multiplexes. What else information do you need from me in order to
>> track the problem?
>
> Recompile your kernel with debug info so we can see the symbols for
> the stack dump.  Otherwise there is no way for anybody to know where
> the oops is occurring in the driver.
>
> Devin
>
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

Devin, thanks for the suggestion but it won't be necessary to
recompile kernel as it emerged that the TV adapter didn't have
sufficient power. When connected behind an active USB hub everything
works like a charm. Sorry for the noise.

Ladislav
.
