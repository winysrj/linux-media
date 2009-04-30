Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:50642 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764989AbZD3Sxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 14:53:43 -0400
Date: Thu, 30 Apr 2009 14:07:17 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: Wolfram Sang <w.sang@pengutronix.de>, linux-media@vger.kernel.org
Subject: Re: Donating a mr97310 based elta-media 8212dc (0x093a:0x010e)
In-Reply-To: <49F9E540.5030909@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0904301403480.22336@banach.math.auburn.edu>
References: <20090430022847.GA15183@pengutronix.de> <alpine.LNX.2.00.0904300953330.21567@banach.math.auburn.edu> <49F9E540.5030909@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 30 Apr 2009, Thomas Kaiser wrote:

> On 04/30/2009 05:24 PM, Theodore Kilgore wrote:
>> 
>> On Thu, 30 Apr 2009, Wolfram Sang wrote:
>> 
>>> Hi all,
>>> 
>>> I recently found an elta media dc8212 camera (usb-id: 0x093a:0x010e) in a 
>>> pile
>>> of old hardware. When looking for linux-support (out of curiosity, I don't 
>>> need
>>> the cam), I saw that there is activity regarding these types of camera
>>> (mr97310) right now. As I am currently busy in other departments of the 
>>> kernel,
>>> I was wondering if somebody here is interested in getting the camera to do
>>> further research? If so, just drop me a mail and I will send it 
>>> free-of-charge.
>>> 
>>> Regards,
>>>
>>>   Wolfram
>>> 
>>> PS: The camera still works. Just checked with another OS on a friend's 
>>> machine.
>>> 
>>> -- 
>>> Pengutronix e.K.                           | Wolfram Sang                |
>>> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>>> 
>> 
>> Hi,
>> 
>> If you want to do such a thing, I think it is very kind of you. As for 
>> myself, I suspect that I already have three or four similar cameras, and so 
>> I probably do not really need another one. Also, judging from your e-mail 
>> address you are in Germany and I am in the US, making it a less desirable 
>> prospect to ship such an object for such a distance.
>> 
>> Therefore, I would offer the suggestion that the camera should go to Kyle 
>> Guin, who wrote the kernel support, or, if he is also in the US (I do not 
>> know where he lives) then perhaps to Thomas Kaiser, who lives a bit closer 
>> to you. I think that all three of us are equally interested but as I said I 
>> do not believe that I need another one of these cameras. In case that I 
>> have missed someone else who might be interested, that is inadvertent on my 
>> part.
>
> Hello Wolfram, Theodore and Kyle
>
> While Theodore is mentioning my name and I live close to Germany, I show my 
> interest for the cam. Anyway, if it is better to send to someone else, that's 
> no problem for me.
>
> Theodore and I exchanged some mails about the compression algorithm of this 
> cam already and it would be nice for me to do something with the real 
> hardware.
>
> Anyway I showed my interest in the compression of the stream because the 
> vendor ID is the same like the Pixart cams (PAC207, PAC7311) for which I 
> wrote the initial drivers and found the decompression algorithm with the help 
> of others.
>
> Maybe the idea from Theodore to send the cam to me is not such a bad idea ;-)
>
> Should we discuss here for some days to find out who can make the most 
> progress with this cam?
>
> Wolfram, thanks for the offer to donate the cam!
>
> Thomas
>

Good luck. Maybe the two of you can actually arrange a hardware swap over 
a beer.

Meanwhile I will continue to look at some debugging output over here and 
to see if I can figure anything out. Thomas, I intend to be in contact. It 
may all turn into sour milk, but I think that I have discovered a few 
things recently.


Theodore Kilgore
