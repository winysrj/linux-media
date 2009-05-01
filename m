Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:53726 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbZEAR0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 13:26:54 -0400
Date: Fri, 1 May 2009 12:40:27 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: linux-media@vger.kernel.org
Subject: Re: Donating a mr97310 based elta-media 8212dc (0x093a:0x010e)
In-Reply-To: <20090501084729.GB6941@pengutronix.de>
Message-ID: <alpine.LNX.2.00.0905011224330.23299@banach.math.auburn.edu>
References: <20090430022847.GA15183@pengutronix.de> <alpine.LNX.2.00.0904300953330.21567@banach.math.auburn.edu> <20090501084729.GB6941@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 1 May 2009, Wolfram Sang wrote:

> Hi Theodore,
>
>> know where he lives) then perhaps to Thomas Kaiser, who lives a bit
>> closer to you. I think that all three of us are equally interested but as
>
> Well, looks like I will send it to Thomas then. I'm glad that it can still be
> useful.

I am glad that this is so easily resolved. As I said, I do not know where 
Kyle lives. If he is somewhere like UK then it would have been possible to 
get it to him easily, too. But if he is in the US, like me, then it seems 
that sending the camera for such a distance would simply be impractical.

>
>> Judging from the Vendor:Product number which you report, it is one of the
>> small MR97310 cameras for which the OEM driver was called the "CIF"
>> driver. Indeed, these cameras are not supported right now, so the matter
>> is interesting.

I meant, not supported for streaming. The camera ought to be well 
supported as a still camera.

>
> I tried simply adding the usb-id to the list in mr97310a.c, but as that didn't
> produce anything useful (green screen), I thought I'll leave it to the pros :)

Heh. No, that is not enough. Been there. Done that.


<snip>

>> Finally, I would ask one question:
>>
>> In the libgphoto2 driver for these cameras, I have a listing for
>>
>> {"Elta Medi@ digi-cam", GP_DRIVER_STATUS_EXPERIMENTAL, 0x093a, 0x010e},
>>
>> Do you think this is the same camera, or a different one? Yours has a
>
> I am pretty sure this is the same camera. "elta medi@ digi-cam" is printed on
> the front-side. The model number "8212DC" is just on a glued label on the
> down-side which may not be present on all charges or may have been removed or
> got lost somehow. I could make pictures of the cam if this helps.

I have the impression you sent another mail, now, with the picture. I have 
not looked at the picture, actually. But the picture would probably not 
help me at all, because I myself have never seen one of these cameras. 
What I know about the camera is well summarized in the following entry 
from libgphoto2/camlibs/mars/ChangeLog:

2004-10-26  Theodore Kilgore <kilgota@auburn.edu>
         * library.c: ID for Haimei HE-501A, reported by
                      Scott MacKenzie <irrational@poboxes.com>
                      ID for Elta Medi@ digicam, reported by
                      Nils Naumann, <nau@gmx.net>
                      Support patch submitted by Scott, tested by Nils.
         * mars.c:    Scott's patch applied.
         * protocol.txt: byte codes for new 352x288 and 176x144 resolution
                         settings recorded; section "UPDATES and REVISIONS" 
added.

This is the total extent of my knowledge. It does seem, judging from the 
address of the person who sent me the information about it, and from 
yours, that the Elta brand is probably local to Europe.

Finally, one of the main reasons why I pass this on is to point out that 
especially in the cheap camera market there is lots of stuff out there 
which just has a name painted on a case, or the case looks kind of weird 
(shaped like a plastic dog, dragon, or squishy toy, attached to a pair of 
sunglasses as a "spy camera" or whatever) and the electronics inside is 
indistinguishable from 20 or 30 other devices, which do not come from the 
same "manufacturer" and may not even have a similar appearance, at all. Do 
I know all the Mars CIF cameras which have the USB ID of 0x093a:0x010e ?
  Almost certainly, I do not. Unfortunately, without the cooperation of the 
manufacturers of these devices that is practically impossible. Therefore 
let us pray that this non-cooperation somehow will get changed.

Theodore Kilgore
