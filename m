Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:46310 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0CAVRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 16:17:18 -0500
Received: by bwz4 with SMTP id 4so2199786bwz.28
        for <linux-media@vger.kernel.org>; Mon, 01 Mar 2010 13:17:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100301075503.5963576f@tele>
References: <1267388365.1854.30.camel@miniol> <20100301075503.5963576f@tele>
Date: Mon, 1 Mar 2010 22:17:16 +0100
Message-ID: <68dded741003011317p6809cc71k1da4609fb5584346@mail.gmail.com>
Subject: Re: [PATCH 1/2] New driver for MI2020 sensor with GL860 bridge
From: Olivier Lorin <olorin75@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

light source is not related to LEDs, it is for the kind of light
source (tungsten, etc). The Windows driver had this control beside the
white balance. I could remove this new control as under Windows the
white balance is achieved by software and not hardware so the white
balance control is available with Linux.

About delay, they are required with at least 2 of four sensors managed
by the driver because there can be communication faults. It also
depends on the laptop as a same sensor driver is kown to always fails
with a laptop and not another one. I prefer now to secure the
communication with all four sensors with a small delay after a data
has been sent.
The delay is mostly stringent in the case of the MI2020 because there
is more than 400 USB messages sent to the webcam at startup and
initialisation time. Added with other required delay, several seconds
are needed to initialise the webcam. I know a "msleep(1)" lasts 5ms to
10ms depending on the scheduler. The msleep slows down too much the
communication. The OV2640 requires also more than 200 messages.
I never got any error with 850ms but we could use 900 or 1000ms. I
chose the less long delay.

Cheers,
OL

2010/3/1, Jean-Francois Moine <moinejf@free.fr>:
> On Sun, 28 Feb 2010 21:19:25 +0100
> Olivier Lorin <olorin75@gmail.com> wrote:
>
>> - General changes for all drivers because of new MI2020 sensor
>> driver :
>>   - add the light source control
>>   - control value changes only applied after an end of image
>>   - replace msleep with duration less than 5 ms by a busy loop
>> - Fix for an irrelevant OV9655 image resolution identifier name
>
> Hello Olivier,
>
> What is this 'light source'? In the list, we are talking about the
> webcam LEDs and how to switch them on/off. Is it the same feature?
>
> Is it important to have a so precise delay in the webcam exchanges?
>
> Cheers.
>
> --
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
>
