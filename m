Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:60077 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbZCESRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 13:17:20 -0500
Date: Thu, 5 Mar 2009 12:29:12 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <49AFCD5B.4050100@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0903051221510.27780@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu>
 <49AE3EA1.3090504@kaiser-linux.li> <49AE41DE.1000300@kaiser-linux.li> <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu> <49AFCD5B.4050100@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Mar 2009, Thomas Kaiser wrote:

> Hello Theodore
>
> kilgota@banach.math.auburn.edu wrote:
>> 
>> 
>> On Wed, 4 Mar 2009, Thomas Kaiser wrote:
>> As to the actual contents of the header, as you describe things,
>> 
>> 0. Do you have any idea how to account for the discrepancy between
>>
>>>>  From usb snoop.
>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
>> and
>>>> In Linux the header looks like this:
>>>> 
>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
>> 
>> (I am referring to the 00 00 as opposed to F0 00)? Or could this have 
>> happened somehow just because these were not two identical sessions?
>
> Doesn't remember what the differences was. The first is from Windoz 
> (usbsnoop) and the second is from Linux.
>
>> 
>>>> 1. xx: don't know but value is changing between 0x00 to 0x07
>> 
>> as I said, this signifies the image format, qua compression algorithm in 
>> use, or if 00 then no compression.
>
> On the PAC207, the compression can be controlled with a register called 
> "Compression Balance size". So, I guess, depending on the value set in the 
> register this value in the header will show what compression level is set.
>
>> 
>>>> 2. xx: this is the actual pixel clock
>> 
>> So there is a control setting for this?
>
> Yes, in the PAC207, register 2. (12 MHz divided by the value set).
>
>> 
>>>> 3. xx: this is changing according light conditions from 0x03 (dark) to
>>>> 0xfc (bright) (center)
>>>> 4. xx: this is changing according light conditions from 0x03 (dark) to
>>>> 0xfc (bright) (edge)
>>>> 5. xx: set value "Digital Gain of Red"
>>>> 6. xx: set value "Digital Gain of Green"
>>>> 7. xx: set value "Digital Gain of Blue"
>> 
>> Does anyone have any idea of how actually to use this information/ for 
>> example, since a lot of cameras are reporting some kind of similar looking 
>> information, does anyone know if there are any kinds of standard scales for 
>> these entries? Just what are they supposed to signify, and how exactly is 
>> one supposed to use such values, if they have been presented? When I say "a 
>> lot of cameras," understand, I mean still cameras as well as webcams, and 
>> cameras with a lot of different chipsets in them, too. So this is a 
>> question whether there is any standard system for the presentation of such 
>> data, and how it might constructively be used in image processing. I have 
>> had questions about this kind of thing for a long time, and I do not know 
>> where to look for the answers.
>
> For the brightness, I guess, 0 means dark and 0xff completely bright (sensor 
> is in saturation)?

That of course is a guess. OTOH it could be on a scale of 0 to 0x80, or it 
could be that only the digits 0 through 9 are actually used, and the basis 
is then 100, or too many other variations to count. Also what is 
considered a "normal" or an "average" value? The trouble with your 
suggestion of a scale from 0 to 0xff is that it makes sense, and in a 
situation like this one obviously can not assume that.

What I am suspecting is that these things have some kind of standard 
definitions, which are not necessarily done by logic but by convention, 
and there is a document out there somewhere which lays it all down. The 
document could have been produced by Microsoft, for example, which 
doubtless has its own problems reducing chaos to order in the industry, or 
by some kind of consortium of camera manufacturers, or something like 
that. I really do strongly suspect that the interpretation of all of this 
is written down somewhere. But I don't know where to look.

Theodore Kilgore
