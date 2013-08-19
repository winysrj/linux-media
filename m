Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta.bitpro.no ([92.42.64.202]:36378 "EHLO mta.bitpro.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3HSTqk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 15:46:40 -0400
Message-ID: <52127667.8050202@bitfrost.no>
Date: Mon, 19 Aug 2013 21:47:51 +0200
From: Hans Petter Selasky <hps@bitfrost.no>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>, Ulf <mopp@gmx.net>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54> <520F643C.70306@iki.fi> <5210B5F3.4040607@bitfrost.no> <CALzAhNXUKZPEyFe0eND3Lb3dQwfVaMUWS30kx0sQJj7YG2rKow@mail.gmail.com>
In-Reply-To: <CALzAhNXUKZPEyFe0eND3Lb3dQwfVaMUWS30kx0sQJj7YG2rKow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/13 21:02, Steven Toth wrote:
>> FYI: The Si2168 driver is available from "dvbsky-linux-3.9-hps-v2.diff"
>> inside. Maybe the Si2165 is similar?
>
> Excellent.
>

Hi Guys,

I was contacted by someone claiming to be from "RSD" ??, named Danny 
Griegs, off-list, claiming I have the source code for sit2.c and cannot 
distribute it.

I want to make clear to everyone that the tarball I've provided only 
contains the C-equivalent of the "objdump -dx" output from the 
media_build-bst/v4l/sit2.o.x86 which is distributed officially by DVBSKY.

He claimed I had to pull the tarball off my site right away or face 
legal actions. I cannot understand this, and would like to ask you guys 
what you think. Obviously my sit2.c is too similar to their "licensed" 
sit2.c. And now these guys want to send a lawyer after me. What a mess. 
Should I laugh or cry. Any advice from you guys about this?

BTW: The hexdump of the sit2.o.x86 contains the string "license=GPL". 
Does that give me any rights to redistribute the re-assembled C-code ?

>
>> 00002460  63 28 29 20 66 61 69 6c  65 64 0a 00 01 36 73 69  |c() failed...6si|
>> 00002470  74 32 3a 20 25 73 2c 20  70 6f 77 65 72 20 75 70  |t2: %s, power up|
>> 00002480  0a 00 01 36 73 69 74 32  3a 20 25 73 2c 20 70 6f  |...6sit2: %s, po|
>> 00002490  77 65 72 20 75 70 5b 25  64 5d 0a 00 76 65 72 73  |wer up[%d]..vers|
>> 000024a0  69 6f 6e 3d 31 2e 30 30  00 6c 69 63 65 6e 73 65  |ion=1.00.license|
>> 000024b0  3d 47 50 4c 00 61 75 74  68 6f 72 3d 4d 61 78 20  |=GPL.author=Max |
>> 000024c0  4e 69 62 62 6c 65 20 3c  6e 69 62 62 6c 65 2e 6d  |Nibble <nibble.m|
>> 000024d0  61 78 40 67 6d 61 69 6c  2e 63 6f 6d 3e 00 64 65  |ax@gmail.com>.de|
>> 000024e0  73 63 72 69 70 74 69 6f  6e 3d 73 69 74 32 20 64  |scription=sit2 d|
>> 000024f0  65 6d 6f 64 75 6c 61 74  6f 72 20 64 72 69 76 65  |emodulator drive|
>> 00002500  72 00 70 61 72 6d 3d 73  69 74 32 5f 64 65 62 75  |r.parm=sit2_debu|
>> 00002510  67 3a 41 63 74 69 76 61  74 65 73 20 66 72 6f 6e  |g:Activates fron|
>> 00002520  74 65 6e 64 20 64 65 62  75 67 67 69 6e 67 20 28  |tend debugging (|
>> 00002530  64 65 66 61 75 6c 74 3a  30 29 00 70 61 72 6d 74  |default:0).parmt|
>> 00002540  79 70 65 3d 73 69 74 32  5f 64 65 62 75 67 3a 69  |ype=sit2_debug:i|

Thank you.

--HPS
