Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61445 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2GRNOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:14:11 -0400
Received: by gglu4 with SMTP id u4so1515961ggl.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 06:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342615958949547500@masin.eu>
References: <1342615958949547500@masin.eu>
Date: Wed, 18 Jul 2012 10:14:10 -0300
Message-ID: <CALF0-+U7HYyuLZJzUH4_OhJ7U4X33fOAmSmYuP-xATkMVjpKcQ@mail.gmail.com>
Subject: Re: CX25821 driver in kernel 3.4.4 problem
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-2?Q?Radek_Ma=B9=EDn?= <radek@masin.eu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Radek,

On Wed, Jul 18, 2012 at 9:52 AM, Radek Mašín <radek@masin.eu> wrote:
>    Hello,
> I have upgraded my testing system with cx25821 based video capture card to system (OpenSuSE 12.1)
> with kernel 3.4.4 and driver for cx25821 doesn't work. Previous system was with kernel 2.6.37 (OpenSuSE 11.4)
> with this patch http://patchwork.linuxtv.org/patch/10056/ and manualy compiled module. With kernel 2.6.37
> driver works properly.
>
> Now I can see, that driver is loaded, but no device in /dev/ are created. Please take a look for attached
> outputs:
>

I'm preparing a patch for you against v3.4.4. Unfortunately, I can't test this.
Would you mind testing it and letting me know?

Thanks,
Ezequiel.
