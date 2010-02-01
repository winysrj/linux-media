Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:54581 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab0BAVoD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 16:44:03 -0500
Received: by bwz23 with SMTP id 23so89552bwz.21
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 13:44:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B67464B.3020801@arcor.de>
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de>
	 <829197381002011252w93b0f17g4c4f6d35ffae45f3@mail.gmail.com>
	 <4B67464B.3020801@arcor.de>
Date: Mon, 1 Feb 2010 16:44:00 -0500
Message-ID: <829197381002011344g1c640c4fufa057071b8527d55@mail.gmail.com>
Subject: Re: [PATCH] - tm6000 DVB support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 1, 2010 at 4:23 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>> You should start by breaking it down into a patch series, so that the
>> incremental changes can be reviewed.  That will allow you to explain
>> in the patch descriptions why all the individual changes you have made
>> are required.
>>
>>
> how can I generate it?

You can use quilt to break it up into a patch series, or create a
local hg clone of v4l-dvb.

>> Why did you define a new callback for changing the tuner mode?  We
>> have successfully provided infrastructure on other bridges to toggle
>> GPIOs when changing modes.  For example, the em28xx has fields in the
>> board profile that allow you to toggle GPIOs when going back and forth
>> between digital and analog mode.
>>
>>
> I don't know, how you mean it. I'm amateur programmer.

Look at how the ".dvb_gpio" and ".gpio" fields are used in the board
profiles in em28xx-cards.c.  We toggle the GPIOs when switching the
from analog to digital mode, without the tuner having to do any sort
of callback.

>> What function does the "tm6000" member in the zl10353 config do?  It
>> doesn't seem to be used anywhere.
>>
>>
> I'll switch it next week to demodulator module.

Are you saying the zl10353 isn't working right now in your patch?  I'm
a bit confused.  If it doesn't work, then your patch title is a bit
misleading since it suggests that your patch provides DVB support for
the tm6000.  If it does work, then the tm6000 member shouldn't be
needed at all in the zl10353 config.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
