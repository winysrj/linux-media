Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:49488 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZCIUKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 16:10:07 -0400
Message-ID: <49B57799.3020504@kaiser-linux.li>
Date: Mon, 09 Mar 2009 21:10:01 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Anders Blomdell <anders.blomdell@control.lth.se>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Topro 6800 driver
References: <49A8661A.4090907@control.lth.se>	<49B194A7.4030808@kaiser-linux.li>	<49B50740.3000902@control.lth.se>	<49B50E16.8080703@kaiser-linux.li> <49B56542.1090408@control.lth.se>
In-Reply-To: <49B56542.1090408@control.lth.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Anders

Anders Blomdell wrote:
 > When I set the RGB/YUV gains to zero, I get:
 >> 5a ff d8 ff fe 14 1e 00 fd f5 45 7e e8 f8 b8 df 49 57
 >      ff d8 ff fe 28 3c 01 fc ff 00 45 66 9a 69 a2 95 4d 2a 12 d1 00 a2 b4
 >
 > followed by a big number of repeated (0x152c bytes total):
 >
 >   02 8a 00 a2 80 28 a0 0a 28
 >
 > and ending with:
 >
 >   02 8a 00 a2 80 ff d9
 >
 > In binary the repeating sequence can be diveded in half:
 >
 >   0000 0010 1000 1010 0000 0000 1010 0010 1000
 >   0000 0010 1000 1010 0000 0000 1010 0010 1000

That is more less the same sequence I get when I do my saturation stuff 
(white picture) :-) . As of coincidence, the same Bit pattern is found 
in the PAC7311 when I do the saturation stuff. And I know the PAC7311 
stream. That's the reason why I wrote I am 100% sure that this is JPEG 
;-) PAC7311 has a special marker between each MCU which has to be 
removed. I don't see such thing in this stream. So it must be pure JPEG.

 >
 > Which approximately adds up to 1200 repetitions of this bitpattern 
2*(0x152c -
 > 23)/9.
 >
 > And a 640*480 image divided in 8*8 subframes gives (640*480/(8*8)) 1200
 > subframes, so now the question is how much info about the Huffman 
table this
 > gives us?

I think nothing :-( , but you found the MCUs :-) As it looks quite the 
same as on the PAC7311, why not just try the Huffman table from the PAC7311?

The frame header on the PAC7311 is ff ff 00 ff 96 62 + 1 Byte MCU Marker 
44, then the JPEG data starts. Look at this:
ff ff 00 ff 96 62 44 f7 ca 28 01 10 a2 80 11 0a 28 01 10 a2 80 11 0a 28
Side note: the first 01 10 is the MCU marker 44 embedded in the Bit stream.

TP8610, first few Bytes with frame header:
5a ff d8 ff fe 14 1e 00 fd f5 45 7e e8 f8 b8 df 49 57 ab 0a 28 73 0a 28 
02 8a 00 a2 80 28 a0 0a

Therefor I think this is the start of the stream:
ab 0a 28 73 0a 28 02 8a 00 a2 80 28 a0 0a

Don't know why we have 73 in between :-(

Hope this one helps....

Thomas




