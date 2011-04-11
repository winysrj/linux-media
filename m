Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50896 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1DKQml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 12:42:41 -0400
Received: by ewy4 with SMTP id 4so1771848ewy.19
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 09:42:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110411163239.GA4324@mgebm.net>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
	<1301922737.5317.7.camel@morgan.silverblock.net>
	<BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
	<BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
	<1302015521.4529.17.camel@morgan.silverblock.net>
	<BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
	<1302481535.2282.61.camel@localhost>
	<20110411163239.GA4324@mgebm.net>
Date: Mon, 11 Apr 2011 12:42:39 -0400
Message-ID: <BANLkTi=zi-4ZUOuf_H+oikBcPJ4eV3qCPw@mail.gmail.com>
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 11, 2011 at 12:32 PM, Eric B Munson <emunson@mgebm.net> wrote:
>> Can you tune to other known digital channels?
>
> I will have to see if I can set one up by hand and try it.  I will get back to
> you when I am able to do this (should be later today).
>
>>
>> > Let me know if you need anything else.
>>
>> Are you tuning digital cable (North American QAM) or digital Over The
>> Air (ATSC)?
>
> I am using digital cable (NA QAM).

This is going to seem a little nuts, but just as a test could you try
sticking the card into a different machine (with a different
motherboard)?  I heard something a few months ago about an issue
related to the power sequencing that only occurred with a specific
motherboard.  Using any other motherboard resulted in success.

It would be useful if we could rule that out.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
