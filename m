Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:50209 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2HBQew (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 12:34:52 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-135.nexicom.net [216.168.121.135])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q72GYpB6021993
	for <linux-media@vger.kernel.org>; Thu, 2 Aug 2012 12:34:51 -0400
Message-ID: <7381e4d38b045460f0ff32e0905f079e.squirrel@lockie.ca>
In-Reply-To: <CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>
References: <50186040.1050908@lockie.ca>
    <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>
    <5019EE10.1000207@lockie.ca>
    <bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com>
    <CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>
Date: Thu, 2 Aug 2012 12:34:49 -0400
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: bjlockie@lockie.ca
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Andy Walls" <awalls@md.metrocast.net>,
	"linux-media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Thu, Aug 2, 2012 at 5:53 AM, Andy Walls <awalls@md.metrocast.net>
> wrote:
>> You can 'grep MODULE_ drivers/media/video/cx23885/*
>> drivers/media/video/cx25840/* ' and other relevant directories under
>> drivers/media/{dvb, common} to find all the parameter options for all
>> the drivers involved in making a HVR_1250 work.
>
> Or just build with everything enabled until you know it is working,
> and then optimize the list of modules later.

It should have been easier, select the card and it builds all the drivers
it needs. :-)
Is there a script somewhere that lets me select a card and automatically
modifies the kernel config?

>
> Also, the 1250 is broken for analog until very recently (patches went
> upstream for 3.5/3.6 a few days ago).

North American OTA is all digital so I have no way to test it.

>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


