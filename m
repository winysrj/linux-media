Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57052 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1DLLi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 07:38:29 -0400
Received: by bwz15 with SMTP id 15so5277883bwz.19
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 04:38:27 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Apr 2011 23:38:27 -1200
Message-ID: <BANLkTimfop0KEM=msAGcoZwVm88Qgx_HDA@mail.gmail.com>
Subject: Re: [PATCH] tm6000: fix vbuf may be used uninitialized (Dmitri please read)
From: Dan Carpenter <error27@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Dmitri Belimov <d.belimov@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 4/11/11, Jarod Wilson <jarod@wilsonet.com> wrote:
> So I was just circling back around on this one, and took some time to read
> the actual code and the radio support addition. After doing so, I don't
> see why the patch I proposed wouldn't do. The buffer is only manipulated
> if !dev->radio or if vbuf is non-NULL (the memcpy call). If its initialized
> to NULL, it only gets used exactly as it did before 8aff8ba9 when
> !dev->radio, and if its not been used or its NULL following manipulations
> protected by !dev->radio, it doesn't get copied. What is the "real bug" I
> am missing there? (Or did I already miss a patch posted to linux-media
> addressing it?)
>

My laptop was stolen so I can't review code for the next couple weeks.

I remember that I thought your patch looked correct, but I was hoping that
Dmitri would Ack it.

regards,
dan carpenter
