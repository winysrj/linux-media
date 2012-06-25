Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62598 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2FYUGK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 16:06:10 -0400
Received: by bkcji2 with SMTP id ji2so3583011bkc.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 13:06:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE8C0E0.3080104@redhat.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
	<4FE8BC2D.9030902@redhat.com>
	<CALF0-+UyWjbbPYCKV-AgS=6FZ349D27GrijrYa_RWPUqcfo8rw@mail.gmail.com>
	<4FE8C0E0.3080104@redhat.com>
Date: Mon, 25 Jun 2012 17:06:08 -0300
Message-ID: <CALF0-+V_NCb2TMdd9SS-jrPKS8ocWRNAvwo1-ptPCW2GtNZEkw@mail.gmail.com>
Subject: Re: [PATCH 01/12] saa7164: Use i2c_rc properly to store i2c register status
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2012 at 4:49 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> If i2c_rc was never initialized, then just remove it. If it is required,
> then there's a bug somewhere out there on those drivers.
>
> IMHO, if the I2C bus doesn't register, any driver that requires I2C bus
> should return -ENODEV.

Agreed.

>
> It should be noticed that there are a few devices that don't need I2C bus
> to work: simple video grabber cards that don't have anything on their I2C.
> There are several of them at bttv, and a few at cx88 and saa7134. Maybe that's
> the reason why those drivers have a var to indicate if i2c got registered.

Mmm, that would explain mysterious i2c_rc.

Anyway, I'm still a *q-bit* unsure about which drivers require i2c to
work and which don't.
I'm gonna investigate this carefully and send a v2 (probably just to
send a v3 later :)

Thanks for reviewing,
Ezequiel.
