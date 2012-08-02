Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55409 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2HBTtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 15:49:10 -0400
Received: by ghrr11 with SMTP id r11so2696280ghr.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 12:49:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dbb5a626e07a4a4f4db40094c35fbd96.squirrel@lockie.ca>
References: <50186040.1050908@lockie.ca>
	<c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>
	<5019EE10.1000207@lockie.ca>
	<bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com>
	<CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>
	<7381e4d38b045460f0ff32e0905f079e.squirrel@lockie.ca>
	<CAGoCfiyo_1e5iA4jZ=44=DqQFcPf3+pUFrQ1h=LHg=O-r_nPQA@mail.gmail.com>
	<dbb5a626e07a4a4f4db40094c35fbd96.squirrel@lockie.ca>
Date: Thu, 2 Aug 2012 15:49:08 -0400
Message-ID: <CAGoCfiyChK1dfvw=4AcLK59czW=FuxFDxkOM9V+DscK_=6SEwg@mail.gmail.com>
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: bjlockie@lockie.ca
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 2, 2012 at 3:41 PM,  <bjlockie@lockie.ca> wrote:
>
>> Heck, even for the 1250 there are eight or ten different versions, so
>> most users wouldn't even know the right one to choose.
>
> Do you mean boards that use different chips?
> I hate it when manufacturers do that (ie. with routers).

In some cases it's different chips (changing the design to use a
better/cheaper bridge, demodulator or tuner).  In some cases it's
because they have different inputs (there are several variants that
have different configurations of composite, s-video, audio connector,
IR support, etc).

As far as the manufacturer is concerned, if there is no end-user
visible feature difference, it's reasonable to not change the model
number and cause the confusion.  That said though, it's a real PITA
for Linux users who think they're something that the web says works
but in fact they are getting something else.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
