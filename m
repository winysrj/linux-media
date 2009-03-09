Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n29CCpmN027915
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 08:12:51 -0400
Received: from sperry-03.control.lth.se (sperry-03.control.lth.se
	[130.235.83.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n29CAitL007119
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 08:12:03 -0400
Message-ID: <49B50740.3000902@control.lth.se>
Date: Mon, 09 Mar 2009 13:10:40 +0100
From: Anders Blomdell <anders.blomdell@control.lth.se>
MIME-Version: 1.0
To: Thomas Kaiser <v4l@kaiser-linux.li>
References: <49A8661A.4090907@control.lth.se>
	<49B194A7.4030808@kaiser-linux.li>
In-Reply-To: <49B194A7.4030808@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Topro 6800 driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Thomas Kaiser wrote:
> Hello Anders
> 
> Anders Blomdell wrote:
>> Hi,
>>
>> I'm trying to write a driver for a webcam based on Topro TP6801/CX0342
>> (06a2:0003). My first attempt (needs gspca) can be found on:
> 
> I own a cam with a TP6810 USB bridge and a CX0342 sensor (this is 
> written on the driver CD).
> 
>> http://www.control.lth.se/user/andersb/tp6800.c
>>
>> Unfortunately the JPEG images (one example dump is in
>> http://www.control.lth.se/user/andersb/topro_img_dump.txt), seems to be bogus,
>> they start with (data is very similar to windows data):
>>
>> 00000000: 0xff,0xd8,0xff,0xfe,0x28,0x3c,0x01,0xe8,...
>> ...
>> 0000c340: ...,0xf4,0xc0,0xff,0xd9
>>
>> Anybody who has a good idea of how to find a DQT/Huffman table that works with
>> this image data?
> 
> I did some usbsnoops today and see some similar things in the stream as 
> in your trace. Maybe you can comment on my observation?
> 
> When I stop the capturing, the las 2 Bytes are always 0xff 0xd9 which 
> look like a valid JPEG marker (End of Image)
> 
> When I search for 0xffd9, I see the following sequence:
> 
> FF D9 5x FF D8 FF FE 14 1E xx xx xx
Is the 5x directly following the FFD9 (in my camera, the next frame [55] is in a
new ISO frame)?

> - 5x is 55 or 5A
I have only seen ISO frames starting with 55 (new frame) AA (abort frame) CC
(frame continuation), the 5A case is not documented in the manual I have

> - the 3 xx are mostly the same, but they change a lot when I cover the 
> lens of the cam. So I think this is some image information (brightness?).
Or perhaps JPEG encoded data.

> This said, i don't think that FF D8 and FF FE are JPEG markers, just a 
> unique Byte pattern to mark the start of a new frame.
Since the manual states that the chip does JPEG compression, and the frames are
significantly smaller than 640*480 and varies in size, I expect it to be in some
compressed format, and so far I expect JPEG (but with unknown Huffman/DQT tables).

> I guess 5x FF D8 FF FE 14 1E xx xx xx and may be some more bytes is the 
> frame marker.
> 
> Comments?
It would be interesting to know if somebody well versed in windows programming
could write a program to get JPEG frames out of the driver directly (provided
this is possible of course), if the image part of such a frame matches the data
seen on USB, we would then have the Huffman/DQT tables.

At the moment I'm stuck, since I see no way to find out what Huffman/DQT tables
that are used.

/Anders

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
