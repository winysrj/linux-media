Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:49914 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1AYJKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 04:10:54 -0500
Message-ID: <4D3E939A.5020100@matrix-vision.de>
Date: Tue, 25 Jan 2011 10:10:50 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] ISP lane shifter support
References: <4D394675.90304@matrix-vision.de> <201101241457.44866.laurent.pinchart@ideasonboard.com> <4D3D89BC.8070305@matrix-vision.de> <201101242045.24561.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101242045.24561.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 01/24/2011 08:45 PM, Laurent Pinchart wrote:
> Hi Michael,
> 
> On Monday 24 January 2011 15:16:28 Michael Jones wrote:
>> On 01/24/2011 02:57 PM, Laurent Pinchart wrote:
>> <snip>
>>
>>>>> As the lane shifter is located at the CCDC input, it might be easier to
>>>>> implement support for this using the CCDC input format. ispvideo.c
>>>>> would need to validate the pipeline when the output of the entity
>>>>> connected to the CCDC input (parallel sensor, CCP2 or CSI2) is
>>>>> configured with a format that can be shifted to the format at the CCDC
>>>>> input.
>>>>
>>>> This crossed my mind, but it seems illogical to have a link with a
>>>> different format at each of its ends.
>>>
>>> I agree in theory, but it might be problematic for the CCDC. Right now
>>> the CCDC can write to memory or send the data to the preview engine, but
>>> not both at the same time. That's something that I'd like to change in
>>> the future. What happens if the user then sets different widths on the
>>> output pads ?
>>
>> Shouldn't we prohibit the user from doing this in ccdc_[try/set]_format
>> in the first place? By "prohibit", I mean shouldn't we be sure that the
>> pixel format on pad 1 is always the same as on pad 2?
> 
> Yes we should (although we could have a larger width on the memory write port, 
> as the video port can further shift the data).

Doesn't this conflict with your comment below that we shouldn't silently
change pad 1 when setting pad 2?  How can we ensure that they're always
the same if a change in one doesn't result in a change in the other?
See my example below.

I didn't realize the video port can further shift the data.  Where can I
find this in the TRM?

> 
>> Downside: this suggests that set_fmt on pad 2 could change the fmt on pad 1,
>> which may be unexpected. But that does at least reflect the reality of the
>> hardware, right?
> 
> I don't think it would be a good idea to silently change formats on pad 1 when 
> setting the format on pad 2. Applications don't expect that. That's why I've 
> proposed changing the format on pad 0 instead. I agree that it would be better 
> to have the same format on the sensor output and on CCDC pad 0 though.
> 

I don't understand how we can change the pixel format on pad 1 without
also changing it on pad 2.  Let me take a simple example:
0. Default state: all 3 CCDC pads have SGRBG10.
1. Sensor delivers Y10, so I set CCDC pad 0 to Y10. CCDC then changes
format of pad 1&2 to Y10 also.
2. I want 8-bit data written to memory, so I set Y8 on pad 1 to use the
shifter. Pad 0 stays Y10, but pad 2 can no longer get Y10, so (?) it
must be changed to Y8.  And I have to allow the change on pad 1 to be
able to use the shifter at all.

I agree applications may not expect this behavior.  They may _expect_
that they can get Y10 to the video port and Y8 to memory, but they
can't.  Isn't this just what we pay for the simplicity of building the
lane shifter into the CCDC subdev rather than creating its own subdev?

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
