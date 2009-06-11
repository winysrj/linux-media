Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbZFKJki (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 05:40:38 -0400
Message-ID: <4A30D101.3090207@redhat.com>
Date: Thu, 11 Jun 2009 11:40:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: =?ISO-8859-1?Q?Jean-Philippe_Fran=E7ois?= <jp.francois@cynove.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9t031 (was RE: [PATCH] adding support for setting bus     
      parameters in sub device)
References: <42113.62.70.2.252.1244712785.squirrel@webmail.xs4all.nl>
In-Reply-To: <42113.62.70.2.252.1244712785.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/11/2009 11:33 AM, Hans Verkuil wrote:
>>
>> On 06/11/2009 10:35 AM, Hans Verkuil wrote:

<snip (a lot)>

>> Hmm,
>>
>> Why would we want the *application* to set things like this *at all* ?
>> with sensors hsync and vsync and other timing are something between
>> the bridge and the sensor, actaully in my experience the correct
>> hsync / vsync timings to program the sensor to are very much bridge
>> specific. So IMHO this should not be exposed to userspace at all.
>>
>> All userspace should be able to control is the resolution and the
>> framerate. Although controlling the framerate in many cases also
>> means controlling the maximum exposure time. So in many cases
>> one cannot even control the framerate. (Asking for 30 fps in an
>> artificially illuminated room will get you a very dark, useless
>> picture, with most sensors). Yes this means that with cams with
>> use autoexposure (which is something which we really want where ever
>> possible), the framerate can and will change while streaming.
>
> I think we have three possible use cases here:
>
> - old-style standard definition video: use S_STD
>

Ack

> - webcam-like devices: a combination of S_FMT and S_PARM I think? Correct
> me if I'm wrong. S_STD is useless for this, right?
>

Ack

> - video streaming devices like the davinci videoports where you can hook
> up HDTV receivers or FPGAs: here you definitely need a new API to setup
> the streaming parameters, and you want to be able to do that from the
> application as well. Actually, sensors are also hooked up to these devices
> in practice. And there you also want to be able to setup these parameters.
> You will see this mostly (only?) on embedded platforms.
>

I agree we need an in kernel API for this, but why expose it to 
userspace, as you say this will only happen on embedded systems, 
shouldn't the info then go in a board_info file / struct ?

Regards,

Hans
