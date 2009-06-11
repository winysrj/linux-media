Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2528 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761708AbZFKKkJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 06:40:09 -0400
Message-ID: <43899.62.70.2.252.1244716793.squirrel@webmail.xs4all.nl>
Date: Thu, 11 Jun 2009 12:39:53 +0200 (CEST)
Subject: Re: mt9t031 (was RE: [PATCH] adding support for setting bus        
        parameters in sub device)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: Jean-Philippe =?iso-8859-1?Q?Fran=E7ois?=
	<jp.francois@cynove.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Muralidharan Karicheri" <a0868495@dal.design.ti.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>
> On 06/11/2009 11:33 AM, Hans Verkuil wrote:
>>>
>>> On 06/11/2009 10:35 AM, Hans Verkuil wrote:
>
> <snip (a lot)>
>
>>> Hmm,
>>>
>>> Why would we want the *application* to set things like this *at all* ?
>>> with sensors hsync and vsync and other timing are something between
>>> the bridge and the sensor, actaully in my experience the correct
>>> hsync / vsync timings to program the sensor to are very much bridge
>>> specific. So IMHO this should not be exposed to userspace at all.
>>>
>>> All userspace should be able to control is the resolution and the
>>> framerate. Although controlling the framerate in many cases also
>>> means controlling the maximum exposure time. So in many cases
>>> one cannot even control the framerate. (Asking for 30 fps in an
>>> artificially illuminated room will get you a very dark, useless
>>> picture, with most sensors). Yes this means that with cams with
>>> use autoexposure (which is something which we really want where ever
>>> possible), the framerate can and will change while streaming.
>>
>> I think we have three possible use cases here:
>>
>> - old-style standard definition video: use S_STD
>>
>
> Ack
>
>> - webcam-like devices: a combination of S_FMT and S_PARM I think?
>> Correct
>> me if I'm wrong. S_STD is useless for this, right?
>>
>
> Ack
>
>> - video streaming devices like the davinci videoports where you can hook
>> up HDTV receivers or FPGAs: here you definitely need a new API to setup
>> the streaming parameters, and you want to be able to do that from the
>> application as well. Actually, sensors are also hooked up to these
>> devices
>> in practice. And there you also want to be able to setup these
>> parameters.
>> You will see this mostly (only?) on embedded platforms.
>>
>
> I agree we need an in kernel API for this, but why expose it to
> userspace, as you say this will only happen on embedded systems,
> shouldn't the info then go in a board_info file / struct ?

These timings are not fixed. E.g. a 720p60 video stream has different
timings compared to a 1080p60 stream. So you have to be able to switch
from userspace. It's like PAL and NTSC, but then many times worse :-)

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

