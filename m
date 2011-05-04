Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44233 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1EDE16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 00:27:58 -0400
Received: by vxi39 with SMTP id 39so765894vxi.19
        for <linux-media@vger.kernel.org>; Tue, 03 May 2011 21:27:58 -0700 (PDT)
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <BANLkTimUen9CfMOhX19wptKrvC3--dQ18w@mail.gmail.com>
Date: Wed, 4 May 2011 00:27:55 -0400
Cc: Heiko Baums <lists@baums-on-web.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <02FF0356-BF5C-427E-8891-8AF9299CC416@wilsonet.com>
References: <20110423005412.12978e29@darkstar> <20110424163530.2bc1b365@darkstar> <BCCEA9F4-16D7-4E63-B32C-15217AA094F3@wilsonet.com> <20110425201835.0fbb84ee@darkstar> <A4226E90-09BE-45FE-AEEF-0EA7E9414B4B@wilsonet.com> <20110425230658.22551665@darkstar> <59898A0D-573E-46E9-A3B7-9054B24E69DF@wilsonet.com> <20110427151621.5ac73e12@darkstar> <1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com> <20110427204725.2923ac99@darkstar> <91CD2A5E-418A-4217-8D9F-1B29FC9DD24D@wilsonet.com> <20110427222855.2e3a3a4d@darkstar> <63E3BF90-BF19-43E3-B8DD-6D6F4896F2E7@wilsonet.com> <BANLkTik+gYRfhDBy9JWgvo+GWJk5Uz7RMQ@mail.gmail.com> <14961B2E-36D9-4CD2-87E7-629F115055F2@wilsonet.com> <20110503222149.1ce726d9@darkstar> <BANLkTin7i871oBseKwg2BmumzvUEb+wHTg@mail.gmail.com> <CC1D29DF-C192-4818-B16A-36AF9FDDAF2A@wilsonet.com> <BANLkTimUen9CfMOhX19wptKrvC3--dQ18w@mail.gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 3, 2011, at 5:52 PM, Devin Heitmueller wrote:

> On Tue, May 3, 2011 at 4:46 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> Yeah, good to have confirmation its got the same issue (and that
>> it doesn't appear to be a simple case of flat batteries)
>> 
>>> Jarod, send me your mailing address off-list, and I'll get a package
>>> into the mail this week.
>> 
>> Will do, coming shortly.
> 
> Not to hijack the thread, but when I was doing the saa7134 work for
> the 1150, I noticed something strange during testing.  I just was
> watching the my tty0 virtual console while whacking buttons on the
> remote.  It appears that there would be a backlog queued up in the
> driver.
> 
> For example, if I hit on the remote control:
> 
> 1111.....2
> 
> (where .... is a pause for a couple of seconds)
> 
> I would actually see to the console:
> 
> 1111....12
> 
> (were .... is the pause in time)
> 
> Note that there is a "1" after the pause, suggesting it was in some
> sort of queue or backlog that wasn't flushed.
> 
> Have you seen anything like this with other drivers?

I actually have. If I'm thinking clearly, the cases I've seen were taken
care of by converting the respective device drivers over to using
ir_raw_event_store_with_filter (and setting a timeout value), but I could
be mixing up the symptoms that led to those changes with something else.
I do know I've seen similar behavior with other hardware though. :)


> I'm asking
> because if this is something you think might be specific to the
> saa7134 (and you want to investigate), I can throw the 1150 board into
> the same package.
> 
> I guess I'm just raising the concern because the perceived behavior
> could be stray button presses being sent to the application.  For
> example, if I say "13" and then a few seconds later type "25", I don't
> want the application to receive "325".
> 
> Anyway, let me know if you want me to throw the second board in the
> outbound package.

Sure, throw it in, I'll see what I can see.

-- 
Jarod Wilson
jarod@wilsonet.com



