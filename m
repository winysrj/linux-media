Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:35365 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128Ab0BAVXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 16:23:53 -0500
Message-ID: <4B67464B.3020801@arcor.de>
Date: Mon, 01 Feb 2010 22:23:23 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] - tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <829197381002011252w93b0f17g4c4f6d35ffae45f3@mail.gmail.com>
In-Reply-To: <829197381002011252w93b0f17g4c4f6d35ffae45f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.02.2010 21:52, schrieb Devin Heitmueller:
> On Mon, Feb 1, 2010 at 3:35 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>   
>> add Terratec Cinergy Hybrid XE
>> bugfix i2c transfer
>> add frontend callback
>> add init for tm6010
>> add digital-init for tm6010
>> add callback for analog/digital switch
>> bugfix usb transfer in DVB-mode
>>
>> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>     
> Hi Stefan,
>
> It's good to see you're making progress.  However, this is going to
> need *alot* of work before it will be able to be accepted upstream.
>
> You should start by breaking it down into a patch series, so that the
> incremental changes can be reviewed.  That will allow you to explain
> in the patch descriptions why all the individual changes you have made
> are required.
>
>   
how can I generate it?
> However, I will try to put some of my thoughts down based on the quick
> glance I took at the patch.
>
> Why did you define a new callback for changing the tuner mode?  We
> have successfully provided infrastructure on other bridges to toggle
> GPIOs when changing modes.  For example, the em28xx has fields in the
> board profile that allow you to toggle GPIOs when going back and forth
> between digital and analog mode.
>
>   
I don't know, how you mean it. I'm amateur programmer.
> You've got a bunch of changes in the xc3028 tuner that will
> *definitely* need close inspection and would need to be validated on a
> variety of products using the xc3028 before they could be accepted
> upstream.  While you have done what you felt was necessary to make it
> work for your board, this cannot be at the cost of possible
> regressions to other products that are already supported.
>
> You really should look into fixing whatever is screwed up in the
> tm6000 i2c implementation so that the read support works, rather than
> relying on nothing ever having to perform a read operation.
>
> What function does the "tm6000" member in the zl10353 config do?  It
> doesn't seem to be used anywhere.
>
>   
I'll switch it next week to demodulator module.
> There are a bunch of codingstyle issues which will need to be fixed.
>
> My foremost concerns are obviously the things that touch other
> drivers, since your work could cause regressions/breakage for other
> boards, which is actually much worse than your board not being
> supported.
>
>   

Cheers

Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>

