Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34687 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755067AbdD0Fw2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 01:52:28 -0400
Subject: Re: [patch] autogain support for bayer10 format (was Re: [patch]
 propagating controls in libv4l2)
To: Pavel Machek <pavel@ucw.cz>
References: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan> <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan> <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan> <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com> <20170426225150.GA4188@amd>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        abcloriens@gmail.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <8a129dca-69c2-366f-1a81-c64dbabc1983@gmail.com>
Date: Thu, 27 Apr 2017 08:52:21 +0300
MIME-Version: 1.0
In-Reply-To: <20170426225150.GA4188@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27.04.2017 01:51, Pavel Machek wrote:
> Hi!
>
>>>> There are two separate things here:
>>>>
>>>> 1) Autofoucs for a device that doesn't use subdev API
>>>> 2) libv4l2 support for devices that require MC and subdev API
>>>
>>> Actually there are three: 0) autogain. Unfortunately, I need autogain
>>> first before autofocus has a chance...
>>>
>>> And that means... bayer10 support for autogain.
>>>
>>> Plus, I changed avg_lum to long long. Quick calculation tells me int
>>> could overflow with few megapixel sensor.
>>>
>>> Oh, btw http://ytse.tricolour.net/docs/LowLightOptimization.html no
>>> longer works.
>>>
>>> Regards,
>>> 								Pavel
>>>
>>> diff --git a/lib/libv4lconvert/processing/autogain.c b/lib/libv4lconvert/processing/autogain.c
>>> index c6866d6..0b52d0f 100644
>>> --- a/lib/libv4lconvert/processing/autogain.c
>>> +++ b/lib/libv4lconvert/processing/autogain.c
>>> @@ -68,6 +71,41 @@ static void autogain_adjust(struct v4l2_queryctrl *ctrl, int *value,
>>> 	}
>>> }
>>>
>>> +static int get_luminosity_bayer10(uint16_t *buf, const struct v4l2_format *fmt)
>>> +{
>>> +	long long avg_lum = 0;
>>> +	int x, y;
>>> +	
>>> +	buf += fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
>>> +		fmt->fmt.pix.width / 4;
>>> +
>>> +	for (y = 0; y < fmt->fmt.pix.height / 2; y++) {
>>> +		for (x = 0; x < fmt->fmt.pix.width / 2; x++)
>>
>> That would take some time :). AIUI, we have NEON support in ARM kernels
>> (CONFIG_KERNEL_MODE_NEON), I wonder if it makes sense (me) to convert the
>> above loop to NEON-optimized when it comes to it? Are there any drawbacks in
>> using NEON code in kernel?
>
> Well, thanks for offer. This is actualy libv4l2.
>

Oh, somehow I got confused that this is kernel code :)

> But I'd say NEON conversion is not neccessary anytime soon. First,
> this is just trying to get average luminosity. We can easily skip
> quite a lot of pixels, and still get reasonable answer.
>
> Second, omap3isp actually has a hardware block computing statistics
> for us. We just don't use it for simplicity.
>

Right, I forgot about that.

> (But if you want to play with camera, I'll get you patches; there's
> ton of work to be done, both kernel and userspace :-).

Well, I saw a low hanging fruit I thought I can convert to NEON in a day 
or two, while having some rest from the huge "project" I am devoting all 
my spare time recently (rebasing hildon/maemo 5 on top of devuan 
Jessie). Still, if there is something relatively small to be done, just 
email me and I'll have a look.

Regards,
Ivo
