Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38745 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3JNUkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 16:40:20 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so7891845pdj.31
        for <linux-media@vger.kernel.org>; Mon, 14 Oct 2013 13:40:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381568085-2407-1-git-send-email-ljalvs@gmail.com>
References: <1381568085-2407-1-git-send-email-ljalvs@gmail.com>
Date: Mon, 14 Oct 2013 16:40:19 -0400
Message-ID: <CAOcJUbxMjw0naKFtTJauunvuaNwqTNeHHPaOE9GWUSHegaex2w@mail.gmail.com>
Subject: Re: [PATCH] cx24117: Fix/enhance set_voltage function.
From: Michael Krufky <mkrufky@linuxtv.org>
To: Luis Alves <ljalvs@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 12, 2013 at 4:54 AM, Luis Alves <ljalvs@gmail.com> wrote:
> Hi,
>
> On this patch:
> Added a few defines to describe what every constant in the set_voltage function.
> Added the description to the CX24117 GPIO control commands.
> Moved the GPIODIR setup to the initfe function.

Luis,

It is generally not preferred to send multiple changes in a single
patch, even if the changes themselves are small.

I know it's not such a huge patch, but, it is preferred for each patch
to contain only one single change, provided that the patch remains
atomic in nature.  I don't think it would be such a problem to merge
these changes as-is, but I do think it would be better to try to
enforce the idea of "one change per atomic patch" when possible.

Can you re-spin this into two (or three) smaller patches?

The first patch should handle the cosmetics, "Added a few defines to
describe every constant in the set_voltage function" & "Added the
description to the CX24117 GPIO control commands" ...  As you see,
these two bits change the code slightly but do not alter the behavior
of the driver.

The final patch should be the one that does alter the driver's
behavior, "Moved the GPIODIR setup to the initfe function"

Doing this can potentially help to quicken the review & merge process,
while also enhancing the readability of the change history within the
kernel.

Cheers,

Mike Krufky
