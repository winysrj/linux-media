Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:38343 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZD3PKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 11:10:45 -0400
Date: Thu, 30 Apr 2009 10:24:17 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: linux-media@vger.kernel.org
Subject: Re: Donating a mr97310 based elta-media 8212dc (0x093a:0x010e)
In-Reply-To: <20090430022847.GA15183@pengutronix.de>
Message-ID: <alpine.LNX.2.00.0904300953330.21567@banach.math.auburn.edu>
References: <20090430022847.GA15183@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Thu, 30 Apr 2009, Wolfram Sang wrote:

> Hi all,
>
> I recently found an elta media dc8212 camera (usb-id: 0x093a:0x010e) in a pile
> of old hardware. When looking for linux-support (out of curiosity, I don't need
> the cam), I saw that there is activity regarding these types of camera
> (mr97310) right now. As I am currently busy in other departments of the kernel,
> I was wondering if somebody here is interested in getting the camera to do
> further research? If so, just drop me a mail and I will send it free-of-charge.
>
> Regards,
>
>   Wolfram
>
> PS: The camera still works. Just checked with another OS on a friend's machine.
>
> -- 
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>

Hi,

If you want to do such a thing, I think it is very kind of you. As for 
myself, I suspect that I already have three or four similar cameras, and 
so I probably do not really need another one. Also, judging from your 
e-mail address you are in Germany and I am in the US, making it a less 
desirable prospect to ship such an object for such a distance.

Therefore, I would offer the suggestion that the camera should go to Kyle 
Guin, who wrote the kernel support, or, if he is also in the US (I do not 
know where he lives) then perhaps to Thomas Kaiser, who lives a bit closer 
to you. I think that all three of us are equally interested but as I said 
I do not believe that I need another one of these cameras. In case that I 
have missed someone else who might be interested, that is inadvertent on 
my part.

Judging from the Vendor:Product number which you report, it is one of the 
small MR97310 cameras for which the OEM driver was called the "CIF" 
driver. Indeed, these cameras are not supported right now, so the matter 
is interesting.

I do suspect at this point that the clue to getting these cameras to work 
is probably to be found in the initialization sequence. I did manage 
(finally!) to get one of my old test machines running Windows to accept a 
driver installation and to give me a sniff or two. My preliminary analysis 
from that experience is, first, the initialization sequence is a bit 
different, and, second, the frame data seems to look different from what I 
get with the current initialization sequence on Linux. I also tried to 
convert a couple of frame data outputs from a sniff log back into binary 
format, to see if I could get something out which looks like a picture. I 
think I did. Not a very good picture, but it seems that I got something 
more than mere noise. I also found out that some of my small cameras with 
the same ID will stream, and some will not. Those which will not stream 
have a rather strange failure mode: they go through all the motions, but 
they produce nothing but a string of repetitions of the SOF marker -- and 
this with the OEM driver software, too. But you say that yours actually 
worked.

Finally, I would ask one question:

In the libgphoto2 driver for these cameras, I have a listing for

{"Elta Medi@ digi-cam", GP_DRIVER_STATUS_EXPERIMENTAL, 0x093a, 0x010e},

Do you think this is the same camera, or a different one? Yours has a 
model number, and my listing does not. Elta could of course have produced 
two "different" cameras with the same guts inside, and sold them under two 
different model descriptions. I have seen lots of that kind of thing from 
other camera vendors. So should there be a separate entry listing this one 
by model number? The reason I do not know the answers to such questions 
is that, obviously, I have never seen either one of these two cameras. The 
first one was reported to me, just like the one which you are offering to 
us.

Also might you be interested to try it out as a still camera, with 
libgphoto2, before surrendering it to someone else?

Theodore Kilgore
