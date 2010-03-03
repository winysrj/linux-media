Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0CCDZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Mar 2010 22:25:48 -0500
Message-ID: <4B8DD6A8.6050201@redhat.com>
Date: Wed, 03 Mar 2010 00:25:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How do private controls actually work?
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>	 <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>	 <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>	 <201003022128.06210.hverkuil@xs4all.nl>	 <829197381003021242p1ae9d91ek68e2c063024d316@mail.gmail.com>	 <4B8D81CE.4070201@redhat.com> <1267581446.3070.76.camel@palomino.walls.org>
In-Reply-To: <1267581446.3070.76.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Tue, 2010-03-02 at 18:23 -0300, Mauro Carvalho Chehab wrote:
>> Devin Heitmueller wrote:
>>> On Tue, Mar 2, 2010 at 3:28 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> I had some extended discussion with Mauro on this yesterday on
>>> #linuxtv, and he is now in favor of introducing a standard user
>>                       ===
>>> control for chroma gain, as opposed to doing a private control at all.
>> To be clear: I was never against ;)
>>
>> It is worthy to summarize the discussions we have and the rationale to
>> create another control for it.
>>
>> I've checked the datasheets of some chipsets, and the chroma gain is
>> different than the saturation control: the gain control (chroma or luma)
>> are applied at the analog input (or analog input samples) before the color
>> decoding, while the saturation is applied to the U/V output levels (some
>> datasheets call it as U/V output gain
> 
> Yes, that is correct.
> 
> 
>>  - causing some mess on the interpretation
>> of this value).
> 
> AFAICT, the effect of chroma gain is not really different from a
> saturation control that scales both the U & V components by the same
> factor.
> 
>                _
> A color vector A can be expressed as
> 	_    _   _
> 	A = YW + C
>        _
> Where YW is a white vector that has a luminance component of magnitude
> Y.
> _
> C is the chrominace vector in a constant luuminance plane.  Its phase is
> the hue, and its magnitude is the saturation.
>                            _
> Adjusting the magnitude of C in the analog domain will change the
> saturation.
>           _                                                      _
> Adjusting C's U & V components will adjust only the magnitude of C, if U
> & V are adjusted by the same scale factor.  (You can tweak both the hue
> and saturation by adjusting U & V by different scale factors.)

Makes sense. Yet, provided that the A/D converters have a very limited range
(in general, 8 to 10 bits), and assuming that some designs may adjust the gain 
before A/D conversion, or they do some sort of quantization before adjusting
saturation, by adjusting the analog level, the quantization noise will be reduced.
> 
>> The API spec patch should clearly state that Saturation is for the U/V output
>> level, while gain is for the analog input gain.
> 
> That makes sense.
> 
> Since we're thinking about what to name controls, I will note the
> CX25843, doesn't quite fit the current discussion of an analog "chroma
> gain" independent from "luma gain":
> 
> 1. the CX25843 has at least 3 front end gains well before U/V
> separation:
>    a +12 dB analog boost
>    a analog coarse gain (controlled by an AGC),
>    a digital fine gain (also has an AGC).
> 
> The +12 dB analog boost can be applied separately for Y, C, Pb and/or
> Pr, but the other analog and digital gains cannot.  They will be applied
> to all video signal inputs the same.

CX88 seems similar to cx25843: it has the +12 dB boost and some levels to adjust
the AGC range.

The +12dB boost could be mapped as an analog gain control with just two values on its range:
0 and 12dB.

That's said, I don't think we should map all available controls to the userspace API's.
The only ones that should be exported are the ones that there are some use cases that
justifies its mapping.

> 
> 2. the CX25843 U and V saturation scale factors can be set
> independently, if desired.
> 
> 
> Regards,
> Andy
> 


-- 

Cheers,
Mauro
