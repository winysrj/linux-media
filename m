Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56750 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1DNCPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 22:15:03 -0400
Received: by wwa36 with SMTP id 36so1425393wwa.1
        for <linux-media@vger.kernel.org>; Wed, 13 Apr 2011 19:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=zi-4ZUOuf_H+oikBcPJ4eV3qCPw@mail.gmail.com>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
	<1301922737.5317.7.camel@morgan.silverblock.net>
	<BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
	<BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
	<1302015521.4529.17.camel@morgan.silverblock.net>
	<BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
	<1302481535.2282.61.camel@localhost>
	<20110411163239.GA4324@mgebm.net>
	<BANLkTi=zi-4ZUOuf_H+oikBcPJ4eV3qCPw@mail.gmail.com>
Date: Wed, 13 Apr 2011 22:15:01 -0400
Message-ID: <BANLkTi=aknDbxqd_xLS2ZJrvHcwDc0MD9w@mail.gmail.com>
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Eric B Munson <emunson@mgebm.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 11, 2011 at 12:42 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Apr 11, 2011 at 12:32 PM, Eric B Munson <emunson@mgebm.net> wrote:
>>> Can you tune to other known digital channels?
>>
>> I will have to see if I can set one up by hand and try it.  I will get back to
>> you when I am able to do this (should be later today).
>>
>>>
>>> > Let me know if you need anything else.
>>>
>>> Are you tuning digital cable (North American QAM) or digital Over The
>>> Air (ATSC)?
>>
>> I am using digital cable (NA QAM).
>
> This is going to seem a little nuts, but just as a test could you try
> sticking the card into a different machine (with a different
> motherboard)?  I heard something a few months ago about an issue
> related to the power sequencing that only occurred with a specific
> motherboard.  Using any other motherboard resulted in success.
>
> It would be useful if we could rule that out.

I ruled this out today, my HTPC is using a Biostar G31D-M7 and my
desktop is using an ASUS P6X58D and I see the same behavior from the
hauppage card in both machines.
