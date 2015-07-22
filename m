Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34760 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbbGVMz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 08:55:59 -0400
Received: by qkfc129 with SMTP id c129so109489252qkf.1
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2015 05:55:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AF42F9.4020407@gmail.com>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<55AB5320.8030100@gmail.com>
	<CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>
	<55AD1C77.6030208@gmail.com>
	<CALzAhNVmmAy=4r0Vd=T82HPUrOzxK9Rg2-M=DQ8gUa-DXKsS6w@mail.gmail.com>
	<55AE6F31.3050308@gmail.com>
	<CALzAhNVuez1_byQe+FiOjZPdUpdgMg0q8CT2KPJ-rO8o8dohzw@mail.gmail.com>
	<55AE8A73.9070802@gmail.com>
	<CALzAhNW9_S=gaT9ioytcpz1hBJ4qjdxaJN6E7ZPQ__8QPdQ=6w@mail.gmail.com>
	<55AF42F9.4020407@gmail.com>
Date: Wed, 22 Jul 2015 08:55:58 -0400
Message-ID: <CALzAhNVjCK4sHQFpR3hS99PDiKVg=OdmL8HAVx1AM++9GjuFtQ@mail.gmail.com>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
From: Steven Toth <stoth@kernellabs.com>
To: =?UTF-8?Q?Tycho_L=C3=BCrsen?= <tycholursen@gmail.com>
Cc: tonyc@wincomm.com.tw, Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 22, 2015 at 3:15 AM, Tycho Lürsen <tycholursen@gmail.com> wrote:
> Hi Steven,
> I'm happy to inform you that all failures have vanished.

Thanks.

>
> Summarizing:
> I compiled 4.2-RC3 with your patch and with
>
> /* Tri-state the TS bus */
>  si2168_set_ts_mode(fe, 0);

What happens if you revert this back to the code from my original
patch, and include your changes listed below?

IE:
   /* Tri-state the TS bus */
   si2168_set_ts_mode(fe, 1);

1) Do you still lock no signal lock issues.
2) Do you see normal video as you'd typically expect?

Thanks for helping! :)

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
