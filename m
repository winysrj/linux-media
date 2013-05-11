Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48322 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3EKN2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 May 2013 09:28:19 -0400
Received: by mail-ie0-f179.google.com with SMTP id c13so9512137ieb.24
        for <linux-media@vger.kernel.org>; Sat, 11 May 2013 06:28:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALPBhf5Sx2-OOhASJVCu+oO39yAh4uBT3JgFa3RPpDGKVp9gTA@mail.gmail.com>
References: <CALPBhf5Sx2-OOhASJVCu+oO39yAh4uBT3JgFa3RPpDGKVp9gTA@mail.gmail.com>
Date: Sat, 11 May 2013 10:28:18 -0300
Message-ID: <CALF0-+XxTwjyGVb8EWrmoa2NPSpVZSmpE6Ha2Q-R++aSC8XeNg@mail.gmail.com>
Subject: Re: stk1160: cannot alloc 196608 bytes
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: a b <genericgroupmail@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 9, 2013 at 1:11 PM, a b <genericgroupmail@gmail.com> wrote:
> Hi,
>
> I am seeing occasional issues when using an easycap card on our fedora
> 17 machine.
[...]

On a very quick look you seem to be getting out of memory (out of
blocks of pages large enough for stk1160). Now, this may be some bug
in stk1160, maybe not.

I'll take a closer look in the next weeks.
-- 
    Ezequiel
