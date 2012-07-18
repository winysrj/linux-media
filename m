Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.masin.eu ([80.188.199.19]:57298 "EHLO mail.masin.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab2GRNpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:45:07 -0400
From: =?utf-8?Q?Radek_Ma=C5=A1=C3=ADn?= <radek@masin.eu>
Date: Wed, 18 Jul 2012 15:45:04 +0200
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <1342619104849714500@masin.eu>
In-Reply-To: <CALF0-+U7HYyuLZJzUH4_OhJ7U4X33fOAmSmYuP-xATkMVjpKcQ@mail.gmail.com>
References: <1342615958949547500@masin.eu>
 <CALF0-+U7HYyuLZJzUH4_OhJ7U4X33fOAmSmYuP-xATkMVjpKcQ@mail.gmail.com>
Subject: Re: CX25821 driver in kernel 3.4.4 problem
MIME-Version: 1.0
Content-Type: text/plain;	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I can test it without problems. Please send me a patch.

Regards
Radek Masin
radek@masin.eu

Dne St, 07/18/2012 03:14 odp., Ezequiel Garcia <elezegarcia@gmail.com> napsal(a):
> Hi Radek,
> 
> On Wed, Jul 18, 2012 at 9:52 AM, Radek Mašín <radek@masin.eu> wrote:
> >    Hello,
> > I have upgraded my testing system with cx25821 based video capture card to system (OpenSuSE 12.1)
> > with kernel 3.4.4 and driver for cx25821 doesn't work. Previous system was with kernel 2.6.37 (OpenSuSE 11.4)
> > with this patch http://patchwork.linuxtv.org/patch/10056/ and manualy compiled module. With kernel 2.6.37
> > driver works properly.
> >
> > Now I can see, that driver is loaded, but no device in /dev/ are created. Please take a look for attached
> > outputs:
> >
> 
> I'm preparing a patch for you against v3.4.4. Unfortunately, I can't test this.
> Would you mind testing it and letting me know?
> 
> Thanks,
> Ezequiel.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
