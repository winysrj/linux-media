Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53223 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbZCRVmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 17:42:51 -0400
Received: by bwz17 with SMTP id 17so251839bwz.37
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 14:42:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C1551E.1000700@kaiser-linux.li>
References: <49A8661A.4090907@control.lth.se> <49B57C1D.3060600@control.lth.se>
	 <49B57F7D.1020108@kaiser-linux.li> <49B62023.2090206@control.lth.se>
	 <49B65BA7.6070700@kaiser-linux.li> <49B68F34.60802@control.lth.se>
	 <49B6A495.9060204@kaiser-linux.li> <49B7D41B.4040801@control.lth.se>
	 <49C00484.7060601@kaiser-linux.li> <49C1551E.1000700@kaiser-linux.li>
Date: Wed, 18 Mar 2009 22:42:47 +0100
Message-ID: <1d4c7fd50903181442n39d72924q6a01b85e55c231e4@mail.gmail.com>
Subject: Re: Topro 6800 driver [JPEG decoding solved]
From: Thomas Champagne <lafeuil@gmail.com>
To: Thomas Kaiser <v4l@kaiser-linux.li>
Cc: Anders Blomdell <anders.blomdell@control.lth.se>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Youhhhouuu ! You are the King of the snoop ! How did you find an
huffman table in the middle of a file ?
But, I don't have received any file with the mail ? Have you correctly
attached the files in the mail ?
Thank you again for this good news !
Thomas

2009/3/18 Thomas Kaiser <v4l@kaiser-linux.li>:
> Thomas Kaiser wrote:
>>
>> Hello Anders
>>
>> Good news, I could decode a frame which I extracted from the usbsnoobs I
>> did :-). See attached picture frame3-03.jpg. It uses the quality 0.
>>
>> Your black frame you sent me gets now correctly decode, too
>> (frameA-01.jpg)
>>
>> I found the Huffman table in the Windoz driver file (TP6810.sys) at offset
>> 0x2a59c. The QTable which I found in a text file on my Windoz box can be
>> found in this driver file, also.
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
> - Byte 4 & 5: I think it is related to resolution. My snoops were done with
> 320x240 (0x141e) and Anders were made with 640x480 (0x283c), twice as big!
> - The rest is static
>
> Thomas
>
>
