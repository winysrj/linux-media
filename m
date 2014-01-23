Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64822 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaAWTLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 14:11:10 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so2669192oag.28
        for <linux-media@vger.kernel.org>; Thu, 23 Jan 2014 11:11:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140122200142.002a39c2@samsung.com>
References: <20140115173559.7e53239a@samsung.com>
	<1390246787-15616-1-git-send-email-a.seppala@gmail.com>
	<20140121122826.GA25490@pequod.mess.org>
	<CAKv9HNZzRq=0FnBH0CD0SCz9Jsa5QzY0-Y0envMBtgrxsQ+XBA@mail.gmail.com>
	<20140122162953.GA1665@pequod.mess.org>
	<CAKv9HNbVQwAcG98S3_Mj4A6zo8Ae2fLT6vn4LOYW1UMrwQku7Q@mail.gmail.com>
	<20140122210024.GA3223@pequod.mess.org>
	<20140122200142.002a39c2@samsung.com>
Date: Thu, 23 Jan 2014 21:11:09 +0200
Message-ID: <CAKv9HNY7==4H2ZDrmaX+1BcarRAJd7zUE491oQ2ZJZXezpwOAw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 January 2014 00:01, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Not sure if you saw it, but there's already another patchset proposing
> that, that got submitted before this changeset:
>         https://patchwork.linuxtv.org/patch/21625/

I actually didn't notice that until now. Seems quite a similar kind of
approach with even more advanced features than what I had in mind
(namely the scancode filtering and masking).

However it looks like that patchset has the same drawback about not
knowing which protocol to use for the wakeup scancode as was pointed
from my patch.

I think I'll try to come up with a new patch addressing the comments
I've seen so far.

-Antti
