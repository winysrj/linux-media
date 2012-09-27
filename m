Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46985 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2I0HNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 03:13:52 -0400
Received: by wibhq12 with SMTP id hq12so5814686wib.1
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2012 00:13:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926105054.12aca245@lwn.net>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-4-git-send-email-javier.martin@vista-silicon.com>
	<20120926105054.12aca245@lwn.net>
Date: Thu, 27 Sep 2012 09:13:50 +0200
Message-ID: <CACKLOr0P7gy_PfPoeWxGdqE=jMAEug=zoWLJ3mbYMQcffBFOZA@mail.gmail.com>
Subject: Re: [PATCH 3/5] media: ov7670: calculate framerate properly for ov7675.
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 September 2012 18:50, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 26 Sep 2012 11:47:55 +0200
> Javier Martin <javier.martin@vista-silicon.com> wrote:
>
>> According to the datasheet ov7675 uses a formula to achieve
>> the desired framerate that is different from the operations
>> done in the current code.
>>
>> In fact, this formula should apply to ov7670 too. This would
>> mean that current code is wrong but, in order to preserve
>> compatibility, the new formula will be used for ov7675 only.
>
> At this point I couldn't tell you what the real situation is; it's been a
> while and there's always a fair amount of black magic involved with
> ov7670 configuration.  I do appreciate attention to not breaking existing
> users.

Indeed, this sensor is the quirkier I've dealt with, with those magic
values in non documented registers...

>> +static void ov7670_get_framerate(struct v4l2_subdev *sd,
>> +                              struct v4l2_fract *tpf)
>
> This bugs me, though.  It's called ov7670_get_framerate() but it's getting
> the rate for the ov7675 - confusing.  Meanwhile the real ov7670 code
> remains inline while ov7675 has its own function.

Actually, I did this on purpose because I wanted to remark that this
function should be valid for both models and because I expected that
the old behaviour was removed sometime in the future.

> Please make two functions, one of which is ov7675_get_framerate(), and call
> the right one for the model.  Same for the "set" functions, obviously.
> Maybe what's really needed is a structure full of sensor-specific
> operations?  The get_wsizes() function could go there too.  That would take
> a lot of if statements out of the code.

The idea of a structure of sensor-specific operations seems
reasonable. Furthermore, I think we should encourage users to use the
right formula in the future. For this reason we could define 4
functions

ov7670_set_framerate_legacy()
ov7670_get_framerate_legacy()
ov7675_set_framerate()
ov7675_get_framerate()

>> +     /*
>> +      * The datasheet claims that clkrc = 0 will divide the input clock by 1
>> +      * but we've checked with an oscilloscope that it divides by 2 instead.
>> +      * So, if clkrc = 0 just bypass the divider.
>> +      */
>
> Thanks for documenting this kind of thing.

You are welcome.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
