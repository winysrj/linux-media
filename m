Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:52241 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbZCDSuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 13:50:20 -0500
Date: Wed, 4 Mar 2009 13:01:22 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Thomas Kaiser <thomas@kaiser-linux.li>
cc: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <49AE41DE.1000300@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu>
 <49AE3EA1.3090504@kaiser-linux.li> <49AE41DE.1000300@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Mar 2009, Thomas Kaiser wrote:

> Thomas Kaiser wrote:
>> Hello Theodore
>> 
>> kilgota@banach.math.auburn.edu wrote:
>>> Also, after the byte indicator for the compression algorithm there are 
>>> some more bytes, and these almost definitely contain information which 
>>> could be valuable while doing image processing on the output. If they are 
>>> already kept and passed out of the module over to libv4lconvert, then it 
>>> would be very easy to do something with those bytes if it is ever figured 
>>> out precisely what they mean. But if it is not done now it would have to 
>>> be done then and would cause even more trouble.
>> 
>> I sent it already in private mail to you. Here is the observation I made 
>> for the PAC207 SOF some years ago:
>>
>>  From usb snoop.
>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
>> 1. xx: looks like random value
>> 2. xx: changed from 0x03 to 0x0b
>> 3. xx: changed from 0x06 to 0x49
>> 4. xx: changed from 0x07 to 0x55
>> 5. xx: static 0x96
>> 6. xx: static 0x80
>> 7. xx: static 0xa0
>> 
>> And I did play in Linux and could identify some fields :-) .
>> In Linux the header looks like this:
>> 
>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
>> 1. xx: don't know but value is changing between 0x00 to 0x07
>> 2. xx: this is the actual pixel clock
>> 3. xx: this is changing according light conditions from 0x03 (dark) to
>> 0xfc (bright) (center)
>> 4. xx: this is changing according light conditions from 0x03 (dark) to
>> 0xfc (bright) (edge)
>> 5. xx: set value "Digital Gain of Red"
>> 6. xx: set value "Digital Gain of Green"
>> 7. xx: set value "Digital Gain of Blue"
>> 
>> Thomas
>
> And I forgot to say that the center brightness sensor was used to do auto 
> brightness control in the old gspca driver. Pixel clock was changed on the 
> fly to get better brightness in dark light conditions.

Yes, you did send it. My point here was to preserve the header 
information, for future use. So this is a good accounting of some possible 
future uses.

As to the actual contents of the header, as you describe things,

0. Do you have any idea how to account for the discrepancy between

>>  From usb snoop.
>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
and 
>> In Linux the header looks like this:
>>
>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00

(I am referring to the 00 00 as opposed to F0 00)? Or could this have 
happened somehow just because these were not two identical sessions?

>> 1. xx: don't know but value is changing between 0x00 to 0x07

as I said, this signifies the image format, qua compression algorithm in 
use, or if 00 then no compression.

>> 2. xx: this is the actual pixel clock

So there is a control setting for this?

>> 3. xx: this is changing according light conditions from 0x03 (dark) to
>> 0xfc (bright) (center)
>> 4. xx: this is changing according light conditions from 0x03 (dark) to
>> 0xfc (bright) (edge)
>> 5. xx: set value "Digital Gain of Red"
>> 6. xx: set value "Digital Gain of Green"
>> 7. xx: set value "Digital Gain of Blue"

Does anyone have any idea of how actually to use this information/ for 
example, since a lot of cameras are reporting some kind of 
similar looking information, does anyone know if there are any kinds of 
standard scales for these entries? Just what are they supposed to signify, 
and how exactly is one supposed to use such values, if they have 
been presented? When I say "a lot of cameras," understand, I mean still 
cameras as well as webcams, and cameras with a lot of different chipsets 
in them, too. So this is a question whether there is any standard system 
for the presentation of such data, and how it might constructively be used 
in image processing. I have had questions about this kind of thing for a 
long time, and I do not know where to look for the answers.

Theodore Kilgore
