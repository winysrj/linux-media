Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:43146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab1EZJqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 05:46:32 -0400
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <4DDD95AF.4010004@redhat.com> <201105261054.59914.laurent.pinchart@ideasonboard.com> <201105261120.41282.arnd@arndb.de>
In-Reply-To: <201105261120.41282.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 26 May 2011 06:46:15 -0300
To: Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	David Rusling <david.rusling@linaro.org>
Message-ID: <62f95b67-499c-4ec5-8b44-517ad96138f3@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Arnd Bergmann <arnd@arndb.de> wrote:

>On Thursday 26 May 2011, Laurent Pinchart wrote:
>> On Thursday 26 May 2011 01:50:07 Mauro Carvalho Chehab wrote:
>> > Em 25-05-2011 20:43, Laurent Pinchart escreveu:
>> > > Issues arise when devices have floating point registers. And yes,
>that
>> > > happens, I've learnt today about an I2C sensor with floating
>point
>> > > registers (in this specific case it should probably be put in the
>broken
>> > > design category, but it exists :-)).
>> > 
>> > Huh! Yeah, an I2C sensor with FP registers sound weird. We need
>more
>> > details in order to address those.
>> 
>> Fortunately for the sensor I'm talking about most of those registers
>are read-
>> only and contain large values that can be handled as integers, so all
>we need 
>> to do is convert the 32-bit IEEE float value into an integer. Other
>hardware 
>> might require more complex FP handling.
>
>As an additional remark here, most architectures can handle float in
>the
>kernel in some way, but they all do it differently, so it's basically
>impossible to do in a cross-architecture device driver.
> 
>> > I'm all about showing the industry in with direction we would like
>it to
>> > go. We want that all Linux-supported
>architectures/sub-architectures
>> > support inter-core communications in kernelspace, in a more
>efficient way
>> > that it would happen if such communication would happen in
>userspace.
>> 
>> I agree with that. My concern is about things like
>> 
>> "Standardizing on the OpenMax media libraries and the GStreamer
>framework is 
>> the direction that Linaro is going." (David Rusling, Linaro CTO,
>quoted on 
>> lwn.net)
>> 
>> We need to address this now, otherwise it will be too late.
>
>Absolutely agreed. OpenMAX needs to die as an interface abstraction
>layer.
>
>IIRC, the last time we discussed this in Linaro, the outcome was
>basically
>that we want to have an OpenMAX compatible library on top of V4L, so
>that the
>Linaro members can have a checkmark in their product specs that lists
>them
>as compatible, but we wouldn't do anything hardware specific in there,
>or
>advocate the use of OpenMAX over v4l2 or gstreamer.

That looks to be the right approach. 
OpenMax as an optional  userspace library is fine, but implementing it as a replacement to v4l2 would be a huge mistake.
>
>	Arnd


Cheers,
Mauro 

-- 
Sent from my phone. Please excuse my brevity.
