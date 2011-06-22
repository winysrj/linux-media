Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:47813 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752444Ab1FVFps (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 01:45:48 -0400
Message-ID: <4E018189.3020305@gmx.de>
Date: Wed, 22 Jun 2011 05:45:45 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
References: <4DDAE63A.3070203@gmx.de> <1308670579-15138-1-git-send-email-laurent.pinchart@ideasonboard.com> <BANLkTim6wUaeZCya=9dMvU7iHj4W4E57Fg@mail.gmail.com> <201106220031.57972.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106220031.57972.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Geert, Laurent,

On 06/21/2011 10:31 PM, Laurent Pinchart wrote:
> Hi Geert,
>
> On Tuesday 21 June 2011 22:49:14 Geert Uytterhoeven wrote:
>> On Tue, Jun 21, 2011 at 17:36, Laurent Pinchart wrote:
>>> +The FOURCC-based API replaces format descriptions by four character
>>> codes +(FOURCC). FOURCCs are abstract identifiers that uniquely define a
>>> format +without explicitly describing it. This is the only API that
>>> supports YUV +formats. Drivers are also encouraged to implement the
>>> FOURCC-based API for RGB +and grayscale formats.
>>> +
>>> +Drivers that support the FOURCC-based API report this capability by
>>> setting +the FB_CAP_FOURCC bit in the fb_fix_screeninfo capabilities
>>> field. +
>>> +FOURCC definitions are located in the linux/videodev2.h header. However,
>>> and +despite starting with the V4L2_PIX_FMT_prefix, they are not
>>> restricted to V4L2 +and don't require usage of the V4L2 subsystem.
>>> FOURCC documentation is +available in
>>> Documentation/DocBook/v4l/pixfmt.xml.
>>> +
>>> +To select a format, applications set the FB_VMODE_FOURCC bit in the
>>> +fb_var_screeninfo vmode field, and set the fourcc field to the desired
>>> FOURCC. +The bits_per_pixel, red, green, blue, transp and nonstd fields
>>> must be set to +0 by applications and ignored by drivers. Note that the
>>> grayscale and fourcc +fields share the same memory location. Application
>>> must thus not set the +grayscale field to 0.
>>
>> These are the only parts I don't like: (ab)using the vmode field (this
>> isn't really a vmode flag), and the union of grayscale and fourcc (avoid
>> unions where possible).
>
> I've proposed adding a FB_NONSTD_FORMAT bit to the nonstd field as a FOURCC
> mode indicator in my initial RFC. Florian Tobias Schandinat wasn't very happy
> with that, and proposed using the vmode field instead.
>
> Given that there's virtually no fbdev documentation, whether the vmode field
> and/or nonstd field are good fit for a FOURCC mode indicator is subject to
> interpretation.

The reason for my suggestion is that the vmode field is accepted to contain only 
flags and at least to me there is no hard line what is part of the video mode 
and what is not. In contrast the nonstd field is already used in a lot of 
different (incompatible) ways. I think if we only use the nonstd field for 
handling FOURCC it is likely that some problems will appear.

>> What about storing the FOURCC value in nonstd instead?
>
> Wouldn't that be a union of nonstd and fourcc ? :-) FOURCC-based format
> setting will be a standard fbdev API, I'm not very keen on storing it in the
> nonstd field without a union.
>
>> As FOURCC values are always 4 ASCII characters (hence all 4 bytes must
>> be non-zero), I don't think there are any conflicts with existing values of
>> nonstd. To make it even safer and easier to parse, you could set bit 31 of
>> nonstd as a FOURCC indicator.
>
> I would then create a union between nonstd and fourcc, and document nonstd as
> being used for the legacy API only. Most existing drivers use a couple of
> nonstd bits only. The driver that (ab)uses nonstd the most is pxafb and uses
> bits 22:0. Bits 31:24 are never used as far as I can tell, so nonstd&
> 0xff000000 != 0 could be used as a FOURCC mode test.
>
> This assumes that FOURCCs will never have their last character set to '\0'. Is
> that a safe assumption for the future ?

Yes, I think. The information I found indicates that space should be used for 
padding, so a \0 shouldn't exist.
I think using only the nonstd field and requiring applications to check the 
capabilities would be possible, although not fool proof ;)

Great work, Laurent, do you have plans to modify fbset to allow using this 
format API from the command line?


Regards,

Florian Tobias Schandinat
