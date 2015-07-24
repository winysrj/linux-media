Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38516 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbbGXNiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 09:38:46 -0400
Received: by iggf3 with SMTP id f3so16780985igg.1
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2015 06:38:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AFD66B.800@gmail.com>
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
	<CALzAhNVjCK4sHQFpR3hS99PDiKVg=OdmL8HAVx1AM++9GjuFtQ@mail.gmail.com>
	<55AFD66B.800@gmail.com>
Date: Fri, 24 Jul 2015 09:38:45 -0400
Message-ID: <CALzAhNXcGGU2JA6Pj5JaB+YsxQXAiT+Mkw27b2LPDX9z_c321g@mail.gmail.com>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
From: Steven Toth <stoth@kernellabs.com>
To: =?UTF-8?Q?Tycho_L=C3=BCrsen?= <tycholursen@gmail.com>
Cc: tonyc@wincomm.com.tw, Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> What happens if you revert this back to the code from my original
>> patch, and include your changes listed below?
>>
>> IE:
>>     /* Tri-state the TS bus */
>>     si2168_set_ts_mode(fe, 1);
>>
>> 1) Do you still lock no signal lock issues.
>
> MythTV  says 'no lock' (though I don't know if such a message is reliable)
>>
>> 2) Do you see normal video as you'd typically expect?
>
> Nope, just a black screen.
> Did not test it with TVheadend.
> However, in MythTV (0.27.4) the line
>
> si2168_set_ts_mode(fe, 0);
>
> makes it work.
>>
>>
>> Thanks for helping! :)
>>
> You're welcome.

Thx. I'll spin up a couple of other si2168 boards I have and look at
their status, pre-post patch.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
