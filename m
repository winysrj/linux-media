Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59257 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbZCAQdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2009 11:33:36 -0500
Received: by fxm24 with SMTP id 24so1681060fxm.37
        for <linux-media@vger.kernel.org>; Sun, 01 Mar 2009 08:33:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49A95428.1090306@control.lth.se>
References: <49A8661A.4090907@control.lth.se> <20090228113135.4bbbc294@free.fr>
	 <49A95428.1090306@control.lth.se>
Date: Sun, 1 Mar 2009 17:33:32 +0100
Message-ID: <1d4c7fd50903010833m78953db6j10cf1bd0a16203ca@mail.gmail.com>
Subject: Re: Topro 6800 driver
From: Thomas Champagne <lafeuil@gmail.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Linux Media <linux-media@vger.kernel.org>,
	Thomas Kaiser <v4l@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anders and others,

I have already tried to create a module for my webcam (Topro TP6800).
It have the same usb id (06a2:0003).
But I have the same problem as you about the image data. I don't know
what is the comment tag (FF:FE). I tried to skip the tag or to skip
the comment with the length after this tag but the image is never
good. I don't know where start the image. If you want an example of
the bad result you can download this image :
http://lafeuil.free.fr/webcam/images/1.jpg
So, I am also in the dark.

If you want to take a look to my code, you can download this file :
http://lafeuil.free.fr/webcam/tp6800.c

If somebody have an idea how can I transform the data, Tell me !

Good luck
Thomas Champagne

2009/2/28 Anders Blomdell <anders.blomdell@control.lth.se>:
> Jean-Francois Moine wrote:
>>
>> On Fri, 27 Feb 2009 23:15:54 +0100
>> Anders Blomdell <anders.blomdell@control.lth.se> wrote:
>>
>>> Hi,
>>>
>>> I'm trying to write a driver for a webcam based on Topro TP6801/CX0342
>>> (06a2:0003). My first attempt (needs gspca) can be found on:
>>>
>>> http://www.control.lth.se/user/andersb/tp6800.c
>>>
>>> Unfortunately the JPEG images (one example dump is in
>>> http://www.control.lth.se/user/andersb/topro_img_dump.txt), seems to
>>> be bogus, they start with (data is very similar to windows data):
>>>
>>> 00000000: 0xff,0xd8,0xff,0xfe,0x28,0x3c,0x01,0xe8,...
>>> ...
>>> 0000c340: ...,0xf4,0xc0,0xff,0xd9
>>>
>>> Anybody who has a good idea of how to find a DQT/Huffman table that
>>> works with this image data?
>>
>> Hi Anders,
>>
>> Thomas Champagne (See To:) was also writing a driver for this webcam.
>> Maybe you may merge your codes...
>
> Thomas, if you have DQT/Huffman tables for this camera, please drop me a
> note.
>
>>
>> About the JPEG images, the Huffman table is always the same
>
> Does this mean that it's the same for all JPEG images or only for one
> camera?
>
> If it's the same for all images, it should mean that I have a way to
> determine how much I have to chop off after the 0xfffe tag (no illegal
> huffman codes -> possibly chop at the correct position).
>
> Comments anyone?
>
>
>> and the
>>
>> quantization tables depend on the compression quality.
>>
>> From the USB trace I had from Thomas, I saw that:
>>
>> - when a packet starts with '55 ff d8', it is the first part of the
>>  image. This one should start at the offset 8 of the packet.
>>
>> - when a packet starts with 'cc', it is the next part of the image.
>
> This is even in the docs, and is implemented in the driver.
>
>> In the function pkt_scan, when finding the image start, you must add
>> the JPEG header: 'ff d8', DQT, huffman table, SOF0 and SOS.
>
> OK, will see if I can find the DQT (and possibly the Huffman table) in the
> windows driver (as suggested by Thomas Kaiser).
>
>> As we don't know the quality used by the webcam, in my test repository,
>> I added a control for that: the JPEG header is created at streamon
>> time, and the quantization tables may be modified by the control on the
>> fly (have a look at stk014.c for an example).
>>
>> This solution is not the right one: the JPEG quality must be set by the
>> VIDIOC_S_JPEGCOMP ioctl instead of VIDIOC_S_CTRL. I think I will update
>> the concerned subdrivers next week.
>
> I'll look into that monday.
>
>> BTW, don't use the video4linux-list@redhat.com mailing-list anymore: all
>> the video discussions are now done in linux-media@vger.kernel.org.
>
> OK, so Google hit http://www.linuxtv.org/v4lwiki/index.php/Main_Page is no
> hit then...
>
>
> Thanks
>
> Anders Blomdell
>
