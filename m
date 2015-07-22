Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36964 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbbGVRoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 13:44:18 -0400
Received: by wibud3 with SMTP id ud3so183612259wib.0
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2015 10:44:14 -0700 (PDT)
Message-ID: <55AFD66B.800@gmail.com>
Date: Wed, 22 Jul 2015 19:44:11 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: tonyc@wincomm.com.tw, Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants - testers
 reqd.
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>	<55AB5320.8030100@gmail.com>	<CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>	<55AD1C77.6030208@gmail.com>	<CALzAhNVmmAy=4r0Vd=T82HPUrOzxK9Rg2-M=DQ8gUa-DXKsS6w@mail.gmail.com>	<55AE6F31.3050308@gmail.com>	<CALzAhNVuez1_byQe+FiOjZPdUpdgMg0q8CT2KPJ-rO8o8dohzw@mail.gmail.com>	<55AE8A73.9070802@gmail.com>	<CALzAhNW9_S=gaT9ioytcpz1hBJ4qjdxaJN6E7ZPQ__8QPdQ=6w@mail.gmail.com>	<55AF42F9.4020407@gmail.com> <CALzAhNVjCK4sHQFpR3hS99PDiKVg=OdmL8HAVx1AM++9GjuFtQ@mail.gmail.com>
In-Reply-To: <CALzAhNVjCK4sHQFpR3hS99PDiKVg=OdmL8HAVx1AM++9GjuFtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Op 22-07-15 om 14:55 schreef Steven Toth:
> On Wed, Jul 22, 2015 at 3:15 AM, Tycho Lürsen <tycholursen@gmail.com> wrote:
>> Hi Steven,
>> I'm happy to inform you that all failures have vanished.
> Thanks.
>
>> Summarizing:
>> I compiled 4.2-RC3 with your patch and with
>>
>> /* Tri-state the TS bus */
>>   si2168_set_ts_mode(fe, 0);
> What happens if you revert this back to the code from my original
> patch, and include your changes listed below?
>
> IE:
>     /* Tri-state the TS bus */
>     si2168_set_ts_mode(fe, 1);
>
> 1) Do you still lock no signal lock issues.
MythTV  says 'no lock' (though I don't know if such a message is reliable)
> 2) Do you see normal video as you'd typically expect?
Nope, just a black screen.
Did not test it with TVheadend.
However, in MythTV (0.27.4) the line

si2168_set_ts_mode(fe, 0);

makes it work.
>
> Thanks for helping! :)
>
You're welcome.
