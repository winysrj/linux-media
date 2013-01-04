Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.serverraum.org ([78.47.150.89]:36615 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3ADUQg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:16:36 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.serverraum.org (Postfix) with ESMTP id BD4DE3F038
	for <linux-media@vger.kernel.org>; Fri,  4 Jan 2013 21:08:27 +0100 (CET)
Received: from mail.serverraum.org ([127.0.0.1])
	by localhost (web.serverraum.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IaGeaynvUUNi for <linux-media@vger.kernel.org>;
	Fri,  4 Jan 2013 21:08:27 +0100 (CET)
Received: from mail-ob0-f170.google.com (mail-ob0-f170.google.com [209.85.214.170])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by mail.serverraum.org (Postfix) with ESMTPSA id 6B62C3F039
	for <linux-media@vger.kernel.org>; Fri,  4 Jan 2013 21:08:27 +0100 (CET)
Received: by mail-ob0-f170.google.com with SMTP id wp18so15277955obc.1
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:08:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121222214224.409ed60a@redhat.com>
References: <50D3F5A8.5010903@hispeed.ch>
	<50D62544.5060708@hispeed.ch>
	<20121222214224.409ed60a@redhat.com>
Date: Fri, 4 Jan 2013 21:08:25 +0100
Message-ID: <CADYPuQ4NRgMXLj+FqYK4i--As7aoXQFmP8kJHTCB+SxWQh8yJA@mail.gmail.com>
Subject: Re: terratec h5 rev. 3?
From: Philipp Dreimann <philipp@dreimann.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Roland Scheidegger <rscheidegger_lists@hispeed.ch>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 December 2012 00:42, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em Sat, 22 Dec 2012 22:25:24 +0100
> Roland Scheidegger <rscheidegger_lists@hispeed.ch> escreveu:
>
>> Am 21.12.2012 06:38, schrieb linux-media-owner@vger.kernel.org:
>> > Hi,
>> >
>> > I've recently got a terratec h5 for dvb-c and thought it would be
>> > supported but it looks like it's a newer revision not recognized by em28xx.
>> > After using the new_id hack it gets recognized and using various htc
>> > cards (notably h5 or cinergy htc stick, cards 79 and 82 respectively) it
>> > seems to _nearly_ work but not quite (I was using h5 firmware for the
>> > older version). Tuning, channel scan works however tv (or dvb radio)
>> > does not, since it appears the error rate is going through the roof
>> > (with some imagination it is possible to see some parts of the picture
>> > sometimes and hear some audio pieces). femon tells something like this:
>>
>> <snip>
>> Hmm actually it doesn't work any better at all with windows neither, so
>> I guess it doesn't like my cable signal (I do have another mantis-based
>> pci dvb-c card which works without issue). Maybe the tuner is just crappy.
>> So I guess it wouldn't hurt to simply add the usb id of this card
>> (0ccd:10b6) as another terratec h5 (this doesn't get you the IR but it's
>> a start I guess).
>> The dvb-t part though works without issue on windows, and I could not
>> get that to work in linux (I've used kaffeine and dvb-fe-tool to force
>> the dvbt delivery system if that's supposed to work). When scanning the
>> right frequency it spew out some error messages though:
>> DvbScanFilter::timerEvent: timeout while reading section; type = 0 pid = 0
>> kaffeine(7527) DvbScanFilter::timerEvent: timeout while reading section;
>> type = 2 pid = 17
>
> If DVB-T is also not working, then I suspect that the device is different
> than the previous revisions. There are two ways to connect the DRX-K with
> em28xx: serial or parallel. Maybe you need to touch that.
>
> The better would be to sniff the usb traffic using the tools at v4l-utils.git
> and see what's happening there.
Roland, did you sniff the usb traffic and/or adjust the serial/
parallel setting yet? I happen to have a H5 rev 3 as well.

>>
>> Roland
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
