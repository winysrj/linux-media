Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:55193 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbZDUBFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 21:05:18 -0400
Date: Mon, 20 Apr 2009 20:18:26 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Kyle Guinn <elyk03@gmail.com>
cc: Thomas Kaiser <v4l@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
 (headers)
In-Reply-To: <200904171904.02986.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0904201945230.6998@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200904162333.49502.elyk03@gmail.com> <alpine.LNX.2.00.0904171225120.11123@banach.math.auburn.edu> <200904171904.02986.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 17 Apr 2009, Kyle Guinn wrote:

> On Friday 17 April 2009 12:50:51 Theodore Kilgore wrote:

<snip>

>>>>
>>>> But I have never seen the 0x64 0xX0 bytes used to count the frames.
>>>> Could you tell me how to repeat that? It certainly would knock down the
>>>> validity of the above table wouldn't it?


>>>
>>> I've modified libv4l to print out the 12-byte header before it skips over
>>> it.
>>
>> Good idea, and an obvious one. Why did I not think of that?


OK, below are some results for several cameras. They will agree, more or 
less, with what you get.

>>
>>> Then when I fire up mplayer it prints out each header as each frame is
>>> received.  The framerate is only about 5 fps so there isn't a ton of data
>>> to parse through.  When I point the camera into a light I get this (at
>>> 640x480):
>>>
>>> ...
>>> ff ff 00 ff 96 64 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 65 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 65 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 66 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 66 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 67 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 67 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 64 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 64 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 65 50 c1 5c c6 00 00
>>> ...
>>
>> Which camera is this? Is it the Aiptek Pencam VGA+? If so, then I can try
>> it, too, because I also have one of them.
>>
>
> Yes, that's the one.  Try your others if you can and let me know what happens.


Some results follow now for various cameras. For some of them I have taken 
the trouble to give both 640x480 and 320x240 results. The one camera for 
which I have only given one result is a CIF camera for which we don't know 
how to do the decompression.

Some headers from the Aiptek Pencam VGA+ (0x08ca: 0x0111) at 640x480

Header:   ff ff 00 ff 96 64 d0 37 5a 27 48 91 
Header:   ff ff 00 ff 96 65 50 2c ce 1a 78 5d 
Header:   ff ff 00 ff 96 65 d0 1b 22 02 1a 4e 
Header:   ff ff 00 ff 96 66 50 0b b0 02 5c 01 
Header:   ff ff 00 ff 96 66 d0 0a 90 01 ec 09 
Header:   ff ff 00 ff 96 67 50 0b 81 02 7b fb 
Header:   ff ff 00 ff 96 67 d0 0c 64 01 ec 00 
Header:   ff ff 00 ff 96 64 50 0c 4e 02 fb f7 
Header:   ff ff 00 ff 96 64 d0 0c a3 02 eb f2 
Header:   ff ff 00 ff 96 65 50 0e c5 01 db d5 
Header:   ff ff 00 ff 96 65 d0 0f b3 03 8b bc 
Header:   ff ff 00 ff 96 66 50 10 03 03 ab bb 
Header:   ff ff 00 ff 96 66 d0 10 28 03 6b c0 
Header:   ff ff 00 ff 96 67 50 10 9a 03 5b b2 
Header:   ff ff 00 ff 96 67 d0 11 2a 03 eb 96 
Header:   ff ff 00 ff 96 64 50 11 54 03 fb 90 
Header:   ff ff 00 ff 96 64 d0 11 36 03 fb 92 
Header:   ff ff 00 ff 96 65 50 11 3c 03 fb 8f 
Header:   ff ff 00 ff 96 65 d0 11 41 04 4b 84 
Header:   ff ff 00 ff 96 66 50 11 5c 04 1b 84 
Header:   ff ff 00 ff 96 66 d0 11 69 04 3b 80 
Header:   ff ff 00 ff 96 67 50 11 75 03 fb 7e 
Header:   ff ff 00 ff 96 67 d0 10 b9 03 5b 90 
Header:   ff ff 00 ff 96 64 50 10 83 03 3b 98 
Header:   ff ff 00 ff 96 64 d0 11 0e 03 1b 99 
Header:   ff ff 00 ff 96 65 50 11 70 03 7b 92 
Header:   ff ff 00 ff 96 65 d0 11 68 03 1b a9 
Header:   ff ff 00 ff 96 66 50 11 1d 03 9b b2 
Header:   ff ff 00 ff 96 66 d0 10 e4 03 8b ba 
Header:   ff ff 00 ff 96 67 50 10 ad 03 2b cb

Some headers from the Aiptek Pencam VGA+ (0x08ca: 0x0111) at 320x240

Header:   ff ff 00 ff 96 64 d0 35 5f 2e 48 a9 
Header:   ff ff 00 ff 96 65 50 23 f4 11 e9 69 
Header:   ff ff 00 ff 96 65 d0 17 bf 0a 6b 1d 
Header:   ff ff 00 ff 96 66 50 18 31 0a 5b 11 
Header:   ff ff 00 ff 96 66 d0 1c df 0d aa 87 
Header:   ff ff 00 ff 96 67 50 19 71 09 aa db 
Header:   ff ff 00 ff 96 67 d0 12 6f 00 5b cf 
Header:   ff ff 00 ff 96 64 50 0c 46 01 1c 41 
Header:   ff ff 00 ff 96 64 d0 0e 48 02 5c 09 
Header:   ff ff 00 ff 96 65 50 0e cf 02 6b fd 
Header:   ff ff 00 ff 96 65 d0 0e 82 02 5c 05 
Header:   ff ff 00 ff 96 66 50 0e 45 02 5c 08 
Header:   ff ff 00 ff 96 66 d0 0e 94 02 6c 02 
Header:   ff ff 00 ff 96 67 50 0e 83 02 7b fd 
Header:   ff ff 00 ff 96 67 d0 0e 6f 02 7c 00 
Header:   ff ff 00 ff 96 64 50 0e 6e 02 7c 03 
Header:   ff ff 00 ff 96 64 d0 0e 61 02 4c 04 
Header:   ff ff 00 ff 96 65 50 0e 86 02 4c 00 
Header:   ff ff 00 ff 96 65 d0 0e e3 02 8b f2 
Header:   ff ff 00 ff 96 66 50 0f 62 02 fb e9 
Header:   ff ff 00 ff 96 66 d0 0e c2 02 ab f6 
Header:   ff ff 00 ff 96 67 50 0e 76 02 3c 07

Some headers from the "Ion Digital Camera" 0x093a:0x010f, at 640x480

Header:   ff ff 00 ff 96 64 d0 20 82 0c e9 af 
Header:   ff ff 00 ff 96 65 50 17 bd 00 a9 c6 
Header:   ff ff 00 ff 96 65 d0 11 90 00 1c 0c 
Header:   ff ff 00 ff 96 66 50 05 f7 00 7c 2b 
Header:   ff ff 00 ff 96 66 d0 07 4e 01 5c 17 
Header:   ff ff 00 ff 96 67 50 07 b9 01 8b fb 
Header:   ff ff 00 ff 96 67 d0 08 90 00 fc 05 
Header:   ff ff 00 ff 96 64 50 09 fc 00 db ef 
Header:   ff ff 00 ff 96 64 d0 0c e6 00 2c 05 
Header:   ff ff 00 ff 96 65 50 13 10 01 db 98 
Header:   ff ff 00 ff 96 65 d0 13 54 02 0b 82 
Header:   ff ff 00 ff 96 66 50 10 d2 02 8b b3 
Header:   ff ff 00 ff 96 66 d0 0c 46 01 7b e7 
Header:   ff ff 00 ff 96 67 50 07 1a 00 0c 5d 
Header:   ff ff 00 ff 96 67 d0 06 e4 00 0c 5f 
Header:   ff ff 00 ff 96 64 50 07 8b 00 0c 5f 
Header:   ff ff 00 ff 96 64 d0 08 60 00 0c 60 
Header:   ff ff 00 ff 96 65 50 08 fb 00 0c 60 
Header:   ff ff 00 ff 96 65 d0 09 0f 00 0c 60 
Header:   ff ff 00 ff 96 66 50 09 21 00 0c 60 
Header:   ff ff 00 ff 96 66 d0 0a f0 00 1c 40 
Header:   ff ff 00 ff 96 67 50 11 a4 00 8b e9 
Header:   ff ff 00 ff 96 67 d0 12 e2 00 0c 1c 
Header:   ff ff 00 ff 96 64 50 0c 41 01 5b e1 
Header:   ff ff 00 ff 96 64 d0 0b 72 01 2b ea 
Header:   ff ff 00 ff 96 65 50 09 67 01 2b f8 
Header:   ff ff 00 ff 96 65 d0 08 32 00 7c 08 
Header:   ff ff 00 ff 96 66 50 05 8e 00 0c 60 
Header:   ff ff 00 ff 96 66 d0 06 95 00 0c 4c 
Header:   ff ff 00 ff 96 67 50 09 95 00 1c 19 
Header:   ff ff 00 ff 96 67 d0 0a a2 00 0c 0f 
Header:   ff ff 00 ff 96 64 50 10 c2 00 5c 1a 
Header:   ff ff 00 ff 96 64 d0 10 ec 00 9b d2 
Header:   ff ff 00 ff 96 65 50 0f b4 00 eb bb 
Header:   ff ff 00 ff 96 65 d0 10 2b 01 9b 96 
Header:   ff ff 00 ff 96 66 50 0e 70 02 9b a3 
Header:   ff ff 00 ff 96 66 d0 0d 68 01 8b c2

Some headers from the "Ion Digital Camera" 0x093a:0x010f, at 320x240

Header:   ff ff 00 ff 96 64 d0 2f 56 1a c8 1a 
Header:   ff ff 00 ff 96 65 50 2e 55 17 38 9f 
Header:   ff ff 00 ff 96 65 d0 2d 61 11 e8 ed 
Header:   ff ff 00 ff 96 66 50 29 85 19 48 ff 
Header:   ff ff 00 ff 96 66 d0 29 ea 19 29 02 
Header:   ff ff 00 ff 96 67 50 28 fd 15 49 3f 
Header:   ff ff 00 ff 96 67 d0 28 40 10 c9 73 
Header:   ff ff 00 ff 96 64 50 26 8b 12 b9 6d 
Header:   ff ff 00 ff 96 64 d0 23 35 11 99 b6 
Header:   ff ff 00 ff 96 65 50 21 77 0f a9 f1 
Header:   ff ff 00 ff 96 65 d0 21 6f 10 b9 e7 
Header:   ff ff 00 ff 96 66 50 25 67 10 e9 af 
Header:   ff ff 00 ff 96 66 d0 28 97 14 c9 3a 
Header:   ff ff 00 ff 96 67 50 2b 64 16 e8 fe 
Header:   ff ff 00 ff 96 67 d0 2a 97 18 19 11 
Header:   ff ff 00 ff 96 64 50 27 99 18 89 3c 
Header:   ff ff 00 ff 96 64 d0 24 43 12 89 7f 
Header:   ff ff 00 ff 96 65 50 1f e8 0f 3a 11 
Header:   ff ff 00 ff 96 65 d0 1c e4 0c 3a 7c 
Header:   ff ff 00 ff 96 66 50 18 33 07 ba ed 
Header:   ff ff 00 ff 96 66 d0 15 d8 07 db 2a 
Header:   ff ff 00 ff 96 67 50 13 95 02 9b 7d 
Header:   ff ff 00 ff 96 67 d0 11 4a 02 4b 94 
Header:   ff ff 00 ff 96 64 50 18 8a 05 fa e6 
Header:   ff ff 00 ff 96 64 d0 20 25 0e ea 0f 
Header:   ff ff 00 ff 96 65 50 23 c7 0e 89 9d 
Header:   ff ff 00 ff 96 65 d0 1c 14 05 3a e4 
Header:   ff ff 00 ff 96 66 50 13 2b 03 1b 84 
Header:   ff ff 00 ff 96 66 d0 16 52 03 7b 33 
Header:   ff ff 00 ff 96 67 50 14 55 01 bb 44 
Header:   ff ff 00 ff 96 67 d0 0e 86 01 3b df 
Header:   ff ff 00 ff 96 64 50 0e 1a 00 fb de 
Header:   ff ff 00 ff 96 64 d0 0d 8d 01 8b dc 
Header:   ff ff 00 ff 96 65 50 0c e4 01 5b df 
Header:   ff ff 00 ff 96 65 d0 0c f2 01 7b d3 
Header:   ff ff 00 ff 96 66 50 0e 01 01 4b d0 
Header:   ff ff 00 ff 96 66 d0 11 1b 00 bb b7 
Header:   ff ff 00 ff 96 67 50 18 16 0b 9a a3 
Header:   ff ff 00 ff 96 67 d0 12 f5 03 4b 44 
Header:   ff ff 00 ff 96 64 50 0d a3 02 5b d4 
Header:   ff ff 00 ff 96 64 d0 11 70 02 9b 6e 
Header:   ff ff 00 ff 96 65 50 15 0f 09 ca db 
Header:   ff ff 00 ff 96 65 d0 0f 93 01 db a3 
Header:   ff ff 00 ff 96 66 50 0c 5b 02 3b eb 
Header:   ff ff 00 ff 96 66 d0 0c 17 01 db ee 
Header:   ff ff 00 ff 96 67 50 0b b3 01 db ee 
Header:   ff ff 00 ff 96 67 d0 0b 5b 01 fb ed 
Header:   ff ff 00 ff 96 64 50 0b d4 01 ab e3 
Header:   ff ff 00 ff 96 64 d0 0c 65 01 fb d8 
Header:   ff ff 00 ff 96 65 50 0c e7 02 3b d4 
Header:   ff ff 00 ff 96 65 d0 0c f9 02 4b d3 
Header:   ff ff 00 ff 96 66 50 0c ea 01 fb d9 
Header:   ff ff 00 ff 96 66 d0 0c d7 02 2b d5 
Header:   ff ff 00 ff 96 67 50 0c c5 02 4b d6 
Header:   ff ff 00 ff 96 67 d0 0d 07 01 fb d5 
Header:   ff ff 00 ff 96 64 50 0e 30 01 7b d1

Some headers from the "Sakar Digital" 0x093a:0x010f, at 640x480

Header:   ff ff 00 ff 96 64 d0 33 ad 24 38 5c 
Header:   ff ff 00 ff 96 65 50 30 a6 1d e7 86 
Header:   ff ff 00 ff 96 65 d0 21 5e 04 29 38 
Header:   ff ff 00 ff 96 66 50 0e aa 02 8b ad 
Header:   ff ff 00 ff 96 66 d0 0d a7 01 cb c8 
Header:   ff ff 00 ff 96 67 50 0f 5b 00 2b de 
Header:   ff ff 00 ff 96 67 d0 0f d8 04 eb 8a 
Header:   ff ff 00 ff 96 64 50 0f 6a 04 fb 8f 
Header:   ff ff 00 ff 96 64 d0 10 3a 03 eb 93 
Header:   ff ff 00 ff 96 65 50 10 e7 05 0b 7d 
Header:   ff ff 00 ff 96 65 d0 0f c9 02 1b b0 
Header:   ff ff 00 ff 96 66 50 16 26 05 db 38 
Header:   ff ff 00 ff 96 66 d0 16 c3 07 8b 1a 
Header:   ff ff 00 ff 96 67 50 15 66 07 8b 2f 
Header:   ff ff 00 ff 96 67 d0 13 a9 05 ab 64 
Header:   ff ff 00 ff 96 64 50 13 5b 07 0b 61 
Header:   ff ff 00 ff 96 64 d0 11 b9 05 bb 93 
Header:   ff ff 00 ff 96 65 50 10 66 05 0b aa 
Header:   ff ff 00 ff 96 65 d0 0e c5 05 eb af 
Header:   ff ff 00 ff 96 66 50 0c fc 04 8b ce 
Header:   ff ff 00 ff 96 66 d0 0c d0 04 8b ca 
Header:   ff ff 00 ff 96 67 50 0c a2 03 eb cf 
Header:   ff ff 00 ff 96 67 d0 0c 52 03 4b d2 
Header:   ff ff 00 ff 96 64 50 0d 04 03 7b cb 
Header:   ff ff 00 ff 96 64 d0 0d 64 03 bb c7 
Header:   ff ff 00 ff 96 65 50 0d 1d 03 0b d4 
Header:   ff ff 00 ff 96 65 d0 0c 52 01 9b ee 
Header:   ff ff 00 ff 96 66 50 0b eb 00 7c 07 
Header:   ff ff 00 ff 96 66 d0 0a eb 00 8b fa 
Header:   ff ff 00 ff 96 67 50 09 d5 00 9c 08 
Header:   ff ff 00 ff 96 67 d0 08 f7 00 6c 13 
Header:   ff ff 00 ff 96 64 50 08 8c 00 7c 11

Some headers from the "Sakar Digital" 0x093a:0x010f, at 320x240

Header:   ff ff 00 ff 96 64 d0 40 70 32 67 76 
Header:   ff ff 00 ff 96 65 50 36 93 21 67 b9 
Header:   ff ff 00 ff 96 65 d0 31 47 1f a8 89 
Header:   ff ff 00 ff 96 66 50 2a bb 1d f9 69 
Header:   ff ff 00 ff 96 66 d0 29 32 1b 29 7e 
Header:   ff ff 00 ff 96 67 50 29 33 18 c9 86 
Header:   ff ff 00 ff 96 67 d0 28 6e 17 99 a0 
Header:   ff ff 00 ff 96 64 50 29 0a 18 59 91 
Header:   ff ff 00 ff 96 64 d0 27 ed 17 99 a5 
Header:   ff ff 00 ff 96 65 50 24 38 14 5a 01 
Header:   ff ff 00 ff 96 65 d0 22 6a 13 5a 20 
Header:   ff ff 00 ff 96 66 50 1d f4 0e 1a 7f 
Header:   ff ff 00 ff 96 66 d0 18 2e 09 0a ef 
Header:   ff ff 00 ff 96 67 50 14 b2 07 0b 2e 
Header:   ff ff 00 ff 96 67 d0 15 4d 07 db 25 
Header:   ff ff 00 ff 96 64 50 17 f1 09 4a fa 
Header:   ff ff 00 ff 96 64 d0 23 a3 10 89 e8 
Header:   ff ff 00 ff 96 65 50 2d a9 17 98 e9 
Header:   ff ff 00 ff 96 65 d0 20 ab 0b ea 03 
Header:   ff ff 00 ff 96 66 50 18 9a 06 ca d1 
Header:   ff ff 00 ff 96 66 d0 1d 43 0f 1a 89 
Header:   ff ff 00 ff 96 67 50 1f 72 11 6a 40 
Header:   ff ff 00 ff 96 67 d0 1f c2 13 1a 5c 
Header:   ff ff 00 ff 96 64 50 1b 5f 0c ea 9f 
Header:   ff ff 00 ff 96 64 d0 18 3b 08 5a e6 
Header:   ff ff 00 ff 96 65 50 13 54 04 1b 73 
Header:   ff ff 00 ff 96 65 d0 11 90 03 eb 8d 
Header:   ff ff 00 ff 96 66 50 12 84 03 eb 8b 
Header:   ff ff 00 ff 96 66 d0 11 81 03 6b a1 
Header:   ff ff 00 ff 96 67 50 10 76 03 2b a2 
Header:   ff ff 00 ff 96 67 d0 16 5e 02 1a f8 
Header:   ff ff 00 ff 96 64 50 1b 4b 0d 4a c4 
Header:   ff ff 00 ff 96 64 d0 17 80 08 2b 0e 
Header:   ff ff 00 ff 96 65 50 10 fd 02 bb 93 
Header:   ff ff 00 ff 96 65 d0 0f bd 03 cb ae 
Header:   ff ff 00 ff 96 66 50 0f 2e 03 bb b1 
Header:   ff ff 00 ff 96 66 d0 0f 1e 03 bb b1 
Header:   ff ff 00 ff 96 67 50 0e 1f 03 4b b6 
Header:   ff ff 00 ff 96 67 d0 0e 9e 02 cb 9d 
Header:   ff ff 00 ff 96 64 50 0f 28 02 7b 9c 
Header:   ff ff 00 ff 96 64 d0 12 36 02 4b 74 
Header:   ff ff 00 ff 96 65 50 12 2f 03 eb 8b 
Header:   ff ff 00 ff 96 65 d0 0f fa 02 6b 9f

And last of all ...

Some headers from a Mars CIF camera (Innovage Mini Digital) 0x093a:0x010e
Dimensions were set at 352x288 (my current best guess). Compression unknown.

Header:   ff ff 00 ff 96 64 d0 00 0f 00 00 b6 
Header:   ff ff 00 ff 96 65 50 00 11 00 00 b6 
Header:   ff ff 00 ff 96 65 d0 00 13 00 00 b6 
Header:   ff ff 00 ff 96 66 50 00 12 00 00 b6 
Header:   ff ff 00 ff 96 66 d0 00 12 00 00 b6 
Header:   ff ff 00 ff 96 67 50 00 12 00 00 b6 
Header:   ff ff 00 ff 96 67 d0 00 12 00 00 b6 
Header:   ff ff 00 ff 96 64 50 00 10 00 00 b6 
Header:   ff ff 00 ff 96 64 d0 00 12 00 00 b6 
Header:   ff ff 00 ff 96 65 50 00 15 00 00 b6 
Header:   ff ff 00 ff 96 65 d0 00 15 00 00 b6 
Header:   ff ff 00 ff 96 66 50 00 0b 00 00 b6


One more comment comment about the 0x50 versus 0xd0 thing:

We do notice, of course, that 0xd0 = 0x50 | 0x80

and they occur alternately, with some degree of precision.

I probably ought to point out that something similar may be seen in the 
allocation table for these cameras, when they are used as still cameras. 
In libgphoto2/camlibs/mars (which supports these cameras in still mode) I 
wrote the file protocol.txt. Here, from that file, is a sample of an
allocation table and the entries in it:

0000  ff 00 ff 00 ff 00 ff 01-00 00 00 00 00 00 00 00
0010  08 00 04 00 0c b0 04 cc-86 13 9a 00 0c 2c 01 6c
0020  06 a6 bf 00 0c 2c 01 a4-88 39 e5 00 0c b0 04 66
0030  06 4c 7b 01 0c 2c 01 07-86 df a0 01 0c 2c 01 3f
0040  08 72 c6 01 0c b0 04 01-88 85 5c 02 0c b0 04 2b
0050  08 98 f2 02 0c b0 04 54-ff ff ff ff ff ff ff ff
0060  ff ff ff ff ff ff ff ff-ff ff ff ff ff ff ff ff


Briefly, line 0 is simply a distinctive marker for the allocation table, 
playing a role similar to the SOF marker for the frames. Then lines 0010 
through 0050 give data about the photos. There are nine photos in the 
camera in this sample. When we reach byte 0x58 and begin repeating 0xff, 
we finished reading about these nine photos. Thus, each block of 8 bytes 
says something about a photo, until the repetition of 0xff begins. After 
this the rest of the configuration data is simply junk.

Let's rearrange the sample, throwing away the unhelpful line 0000 and also
terminating after byte 0x57:

photo   1       08 00 04 00 0c b0 04 cc
         2       86 13 9a 00 0c 2c 01 6c
         3       06 a6 bf 00 0c 2c 01 a4
         4       88 39 e5 00 0c b0 04 66
         5       06 4c 7b 01 0c 2c 01 07
         6       86 df a0 01 0c 2c 01 3f
         7       08 72 c6 01 0c b0 04 01
         8       88 85 5c 02 0c b0 04 2b
         9       08 98 f2 02 0c b0 04 54

For each photo, byte 0 of its entry is a code for its size and 
compression. Or, rather, its lower nibble does that. Observe that the 
higher nibble is either 0 or 8, depending on position. Perhaps something 
analogous is occurring here, and there is no particular significance at 
all for the fluctuation between 0x50 and 0xd0, except that in this case it 
probably would make it really easy to spot a dropped frame.

Oh, BTW, I was not always pointing the cameras at a bright light, which 
could make some difference about those bytes at the end of the header.

Theodore Kilgore
