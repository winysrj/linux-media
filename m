Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39052 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab0G2MCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 08:02:30 -0400
Received: by vws3 with SMTP id 3so207368vws.19
        for <linux-media@vger.kernel.org>; Thu, 29 Jul 2010 05:02:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=8GyE8-EdMfoL+MDXvFGi1V-ikvHc5m=h3Q9zt@mail.gmail.com>
References: <AANLkTinU8gO1gx+3wD4hqYp7O2U2RC2UQ597Jag=gMPw@mail.gmail.com>
	<AANLkTi=8GyE8-EdMfoL+MDXvFGi1V-ikvHc5m=h3Q9zt@mail.gmail.com>
Date: Thu, 29 Jul 2010 17:32:24 +0530
Message-ID: <AANLkTin3JCnG77TuQCZO18d2j6VigSEZW+oEcwop1y11@mail.gmail.com>
Subject: Re: [PATCH] Fix possible memory leak in dvbca.c
From: Manu Abraham <abraham.manu@gmail.com>
To: Tomer Barletz <barletz@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 27, 2010 at 6:28 PM, Tomer Barletz <barletz@gmail.com> wrote:
> 2010/7/25 Tomer Barletz <barletz@gmail.com>:
>> Allocated memory will never get free when read fails.
>> See attached patch.
>>
>> Tomer
>>
>
> Attached a better patch... :)
>

Ok, thanks. Will apply.

Regards,
Manu
