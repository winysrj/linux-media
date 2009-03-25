Return-path: <linux-media-owner@vger.kernel.org>
Received: from sperry-03.control.lth.se ([130.235.83.190]:56655 "EHLO
	sperry-03.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZCYRKv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 13:10:51 -0400
Message-ID: <49CA6592.1070005@control.lth.se>
Date: Wed, 25 Mar 2009 18:10:42 +0100
From: Anders Blomdell <anders.blomdell@control.lth.se>
MIME-Version: 1.0
To: Thomas Kaiser <v4l@kaiser-linux.li>
CC: Linux Media <linux-media@vger.kernel.org>,
	Thomas Champagne <lafeuil@gmail.com>
Subject: Re: Topro 6800 driver [JPEG decoding solved]
References: <49A8661A.4090907@control.lth.se>	<49B194A7.4030808@kaiser-linux.li>	<49B50740.3000902@control.lth.se>	<49B50E16.8080703@kaiser-linux.li> <49B56542.1090408@control.lth.se> <49B57799.3020504@kaiser-linux.li> <49B57C1D.3060600@control.lth.se> <49B57F7D.1020108@kaiser-linux.li> <49B62023.2090206@control.lth.se> <49B65BA7.6070700@kaiser-linux.li> <49B68F34.60802@control.lth.se> <49B6A495.9060204@kaiser-linux.li> <49B7D41B.4040801@control.lth.se> <49C00484.7060601@kaiser-linux.li> <49C1551E.1000700@kaiser-linux.li>
In-Reply-To: <49C1551E.1000700@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas Kaiser wrote:
> Thomas Kaiser wrote:
>> Hello Anders
>>
>> Good news, I could decode a frame which I extracted from the usbsnoobs I 
>> did :-). See attached picture frame3-03.jpg. It uses the quality 0.
>>
>> Your black frame you sent me gets now correctly decode, too (frameA-01.jpg)
>>
>> I found the Huffman table in the Windoz driver file (TP6810.sys) at 
>> offset 0x2a59c. The QTable which I found in a text file on my Windoz box 
>> can be found in this driver file, also.
>>
>> I attached some binary files which I used to build the 2 attached jpeg.
>>
>> For example use:
>> cat FFD8-Q0-320x240.bin huffman1.bin FFDA.bin frame3-3.bin >frame3-03.jpg
>> to make the picture frame3-03.jpg.
>>
>> This information should the cam get going in Linux ;-)
>>
>> Happy Hacking,
>>
>> Thomas
>>
>> PS: I sent this to the linux-media mail list, because somebody else is 
>> interested about this information, too.
>>
> 
> Just some comments about the observation you made on the frame header:
> 
> ff d8 ff fe 28 3c 01
> 
> - Byte 6: Yes, it is the current quality setting
> - Byte 4 & 5: I think it is related to resolution. My snoops were done with 320x240 (0x141e) and Anders were made with 640x480 (0x283c), twice as big!
> - The rest is static

OK,

Things are looking brighter, I can capture single images with a slightly
modified uvccapture and streaming with mplayer (with bogus colors, but
identifiable image data)

ucview doesn't work though; complains on huffman, but I'll look into colors first...

Regards

/Anders


-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden
