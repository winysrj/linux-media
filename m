Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:65458 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZDPQKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 12:10:39 -0400
Message-ID: <49E7587C.6010803@kaiser-linux.li>
Date: Thu, 16 Apr 2009 18:10:36 +0200
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Some questions about mr97310 controls (continuing previous thread
 on mr97310a.c)
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li> <49AE41DE.1000300@kaiser-linux.li> <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu> <49AFCD5B.4050100@kaiser-linux.li> <alpine.LNX.2.00.0904151850240.9310@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0904151850240.9310@banach.math.auburn.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Theodore

My answers/comments inline .....

On 04/16/2009 01:59 AM, Theodore Kilgore wrote:
> 
> 
> Thomas,
> 
> A few questions in the text below.
> 
> 
> On Thu, 5 Mar 2009, Thomas Kaiser wrote:
> 
>> Hello Theodore
>>
>> kilgota@banach.math.auburn.edu wrote:
>>>
>>>
>>> On Wed, 4 Mar 2009, Thomas Kaiser wrote:
>>> As to the actual contents of the header, as you describe things,
>>>
>>> 0. Do you have any idea how to account for the discrepancy between
>>>
>>>>>  From usb snoop.
>>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
>>> and
>>>>> In Linux the header looks like this:
>>>>>
>>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
>>>
>>> (I am referring to the 00 00 as opposed to F0 00)? Or could this have 
>>> happened somehow just because these were not two identical sessions?
> 
> In case I did not answer this one, I suspect it was probably different 
> sessions. I can think of no other explanation which makes sense to me.
> 
>>
>> Doesn't remember what the differences was. The first is from Windoz 
>> (usbsnoop) and the second is from Linux.
>>
>>>
>>>>> 1. xx: don't know but value is changing between 0x00 to 0x07
>>>
>>> as I said, this signifies the image format, qua compression algorithm 
>>> in use, or if 00 then no compression.
>>
>> On the PAC207, the compression can be controlled with a register 
>> called "Compression Balance size". So, I guess, depending on the value 
>> set in the register this value in the header will show what 
>> compression level is set.
> 
> One of my questions:
> 
> Just how does it work to set the "Compression Balance size"? Is this 
> some kind of special command sequence? Are we able to set this to 
> whatever we want?

It looks like. One can set a value from 0x0 to 0xff in the "Compression 
Balance size" register (reg 0x4a).
In the pac207 Linux driver, this register is set to 0xff to turn off the 
compression. While we use compression 0x88 is set (I think the same 
value like in Windoz). Hans did play with this register and found out 
that the compression changes with different values.

Hans, may you explain a bit more what you found out?

> 
> 
>>
>>>
>>>>> 2. xx: this is the actual pixel clock
>>>
>>> So there is a control setting for this?
>>
>> Yes, in the PAC207, register 2. (12 MHz divided by the value set).
>>
>>>
>>>>> 3. xx: this is changing according light conditions from 0x03 (dark) to
>>>>> 0xfc (bright) (center)
>>>>> 4. xx: this is changing according light conditions from 0x03 (dark) to
>>>>> 0xfc (bright) (edge)
>>>>> 5. xx: set value "Digital Gain of Red"
>>>>> 6. xx: set value "Digital Gain of Green"
>>>>> 7. xx: set value "Digital Gain of Blue"
> 
> 
> Varying some old questions: Precisely what is meant by the value of 
> "Digital Gain for XX" where XX is one of Red, Green, or Blue? On what 
> scale is this measured? Is is some kind of standardized scale? Or is it 
> something which is camera-specific? Also what is does "set" mean in this 
> context? This last in view of the fact that this is data which the 
> camera provides for our presumed information, not something which we are 
> sending to the camera?

When I recall correctly, I just saw that this fields in the header have 
the same value which I set in the "digital gain of Red/Green/Blue" 
registers. Therefor, I called it "set" value. But I don't remember if a 
change of these registers had any impact on the picture.

The range for these registers is from 0x0 to 0xff but as I don't know 
what they do, I don't know any more :-(

Thomas
