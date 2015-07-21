Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36016 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbbGUQTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 12:19:24 -0400
Received: by qkdv3 with SMTP id v3so136153739qkd.3
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2015 09:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AE6F31.3050308@gmail.com>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<55AB5320.8030100@gmail.com>
	<CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>
	<55AD1C77.6030208@gmail.com>
	<CALzAhNVmmAy=4r0Vd=T82HPUrOzxK9Rg2-M=DQ8gUa-DXKsS6w@mail.gmail.com>
	<55AE6F31.3050308@gmail.com>
Date: Tue, 21 Jul 2015 12:19:23 -0400
Message-ID: <CALzAhNVuez1_byQe+FiOjZPdUpdgMg0q8CT2KPJ-rO8o8dohzw@mail.gmail.com>
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

On Tue, Jul 21, 2015 at 12:11 PM, Tycho Lürsen <tycholursen@gmail.com> wrote:
> Hi Steven,
> I was too curious to wait for you and Antti to settle your differences, so I
> tested again against a 4.2-RC2
> I did not disable DVB-T/T2, instead I reordered the lot. MythTV just sees
> the first system in the .delsys line in si2168.c,
> so when it looks like this:
> SYS_DVBC_ANNEX_A, SYS_DVBT, SYS_DVBT2
> I'm good.

We have no differences, its Antti's si2168 driver. If Antti doesn't
like the approach for tri-stating, he's free to suggest and
alternative. I suggested two alternatives yesterday.

>
> Result:
> With your patch both MythTV and Tvheadend still can't tune. Without it,
> everything is ok.
>
> I'm not very interested in czap results, only in real use cases. For me
> that's MythTV, but just to be sure I also tested with TVheadend.

That's pretty bizarre results, although thank you for testing. :)

When you say it can't tune, do you mean the signal does not lock, or
that no video appears?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
