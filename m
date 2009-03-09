Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n29Iq6hm030434
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 14:52:06 -0400
Received: from sperry-03.control.lth.se (sperry-03.control.lth.se
	[130.235.83.190])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n29IpntJ005160
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 14:51:51 -0400
Message-ID: <49B56542.1090408@control.lth.se>
Date: Mon, 09 Mar 2009 19:51:46 +0100
From: Anders Blomdell <anders.blomdell@control.lth.se>
MIME-Version: 1.0
To: Thomas Kaiser <v4l@kaiser-linux.li>
References: <49A8661A.4090907@control.lth.se>	<49B194A7.4030808@kaiser-linux.li>
	<49B50740.3000902@control.lth.se>
	<49B50E16.8080703@kaiser-linux.li>
In-Reply-To: <49B50E16.8080703@kaiser-linux.li>
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
>>>> Anybody who has a good idea of how to find a DQT/Huffman table that works with
>>>> this image data?
>>> I did some usbsnoops today and see some similar things in the stream as 
>>> in your trace. Maybe you can comment on my observation?
>>>
>>> When I stop the capturing, the las 2 Bytes are always 0xff 0xd9 which 
>>> look like a valid JPEG marker (End of Image)
>>>
>>> When I search for 0xffd9, I see the following sequence:
>>>
>>> FF D9 5x FF D8 FF FE 14 1E xx xx xx
>> Is the 5x directly following the FFD9 (in my camera, the next frame [55] is in a
>> new ISO frame)?
> 
> Actually, the 5x is always the first byte in the IsoPacket. In my 
> snoops, it is mostly 5A.
> 
>>> - 5x is 55 or 5A
>> I have only seen ISO frames starting with 55 (new frame) AA (abort frame) CC
>> (frame continuation), the 5A case is not documented in the manual I have
> 
> Can you send this manual to me (private)?
> 
>>> - the 3 xx are mostly the same, but they change a lot when I cover the 
>>> lens of the cam. So I think this is some image information (brightness?).
>> Or perhaps JPEG encoded data.
>>
>>> This said, i don't think that FF D8 and FF FE are JPEG markers, just a 
>>> unique Byte pattern to mark the start of a new frame.
>> Since the manual states that the chip does JPEG compression, and the frames are
>> significantly smaller than 640*480 and varies in size, I expect it to be in some
>> compressed format, and so far I expect JPEG (but with unknown Huffman/DQT tables).
>>
>>> I guess 5x FF D8 FF FE 14 1E xx xx xx and may be some more bytes is the 
>>> frame marker.
> 
> I did some more studying over the weekend....
> 
> In my snoops, I think:

When I set the RGB/YUV gains to zero, I get:
> 5a ff d8 ff fe 14 1e 00 fd f5 45 7e e8 f8 b8 df 49 57
     ff d8 ff fe 28 3c 01 fc ff 00 45 66 9a 69 a2 95 4d 2a 12 d1 00 a2 b4

followed by a big number of repeated (0x152c bytes total):

  02 8a 00 a2 80 28 a0 0a 28

and ending with:

  02 8a 00 a2 80 ff d9

In binary the repeating sequence can be diveded in half:

  0000 0010 1000 1010 0000 0000 1010 0010 1000
  0000 0010 1000 1010 0000 0000 1010 0010 1000

Which approximately adds up to 1200 repetitions of this bitpattern 2*(0x152c -
23)/9.

And a 640*480 image divided in 8*8 subframes gives (640*480/(8*8)) 1200
subframes, so now the question is how much info about the Huffman table this
gives us?

When I change the quality setting of the camera, the bitpattern changes, but
size stays approximately the same, here follows the start of the frames at
different quality settings. Notable facts:

  1. Byte 6 seems to be currently used quality setting
  2. Byte 4 & 5 are exactly twice as big as in Thomas dump, could it be related
     to size?
  3. Quality settings 0x10 to 0x1f seems to generate the same bit-patter, which
     indicates that the file Thomas found might be the DQT, now the quistion is
     if my dumps together with those tables are enough to determine the huffman
     table used (hopefully the same for all quality settings)

sd_setquality
0 = write(79, 0)
Size=1539, quality=0
ff d8 ff fe 28 3c 00 fc 01 45 73 c1 c1 c3 c1 c3
a7 0b 0a 95 4d 34 a4 92 4a 12 4a c9 24 b4 4b 64
02 8a e8 02 8a 00 a2 80 28 a0 0a 28 02 8a 00 a2
80 28 a0 0a 28 02 8a 00 a2 80 28 a0 0a 28 02 8a
00 a2 80 28 a0 0a 28 02 8a 00 a2 80 28 a0 0a 28
02 8a 00 a2 80 28 a0 0a 28 02 8a 00 a2 80 28 a0
0a 28 02 8a 00 a2 80 28 a0 0a 28 02 8a 00 a2 80
28 a0 0a 28 02 8a 00 a2 80 28 a0 0a 28 02 8a 00
sd_setquality
0 = write(79, 1)
Size=152d, quality=1
ff d8 ff fe 28 3c 01 fc ff 00 45 66 9a 69 a2 95
4d 2a 12 d1 00 a2 b4 02 8a 00 a2 80 28 a0 0a 28
02 8a 00 a2 80 28 a0 0a 28 02 8a 00 a2 80 28 a0
0a 28 02 8a 00 a2 80 28 a0 0a 28 02 8a 00 a2 80
28 a0 0a 28 02 8a 00 a2 80 28 a0 0a 28 02 8a 00
a2 80 28 a0 0a 28 02 8a 00 a2 80 28 a0 0a 28 02
8a 00 a2 80 28 a0 0a 28 02 8a 00 a2 80 28 a0 0a
28 02 8a 00 a2 80 28 a0 0a 28 02 8a 00 a2 80 28
sd_setquality
0 = write(79, 2)
Size=152a, quality=2
ff d8 ff fe 28 3c 02 f9 55 15 29 a5 52 95 34 a8
48 05 15 40 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 3)
Size=1526, quality=3
ff d8 ff fe 28 3c 03 f9 fd 15 12 49 42 01 45 50
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
sd_setquality
0 = write(79, 4)
Size=1526, quality=4
ff d8 ff fe 28 3c 04 f9 fd 15 12 49 42 01 45 50
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
sd_setquality
0 = write(79, 5)
Size=1526, quality=5
ff d8 ff fe 28 3c 05 f9 fd 15 12 49 42 01 45 50
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
sd_setquality
0 = write(79, 6)
Size=1526, quality=6
ff d8 ff fe 28 3c 06 f1 94 54 49 25 08 05 15 40
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
sd_setquality
0 = write(79, 7)
Size=1525, quality=7
ff d8 ff fe 28 3c 07 f1 94 54 4a 2c 80 51 54 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 8)
Size=1524, quality=8
ff d8 ff fe 28 3c 08 f2 94 54 d0 05 15 40 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
sd_setquality
0 = write(79, 9)
Size=1523, quality=9
ff d8 ff fe 28 3c 09 f2 94 54 01 45 50 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, a)
Size=1523, quality=a
ff d8 ff fe 28 3c 0a f3 54 54 01 45 50 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, b)
Size=1523, quality=b
ff d8 ff fe 28 3c 0b f3 54 54 01 45 50 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
50 05 14 01 45 00 51 40 14 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, c)
Size=1523, quality=c
ff d8 ff fe 28 3c 0c f3 f4 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
sd_setquality
0 = write(79, d)
Size=1523, quality=d
ff d8 ff fe 28 3c 0d f3 f4 50 05 14 01 45 00 51
40 14 50 05 14 01 45 00 51 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
sd_setquality
0 = write(79, e)
Size=1522, quality=e
ff d8 ff fe 28 3c 0e e2 d1 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
sd_setquality
0 = write(79, f)
Size=1522, quality=f
ff d8 ff fe 28 3c 0f e2 d1 40 14 50 05 14 01 45
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
51 40 14 50 05 14 01 45 00 51 40 14 50 05 14 01
45 00 51 40 14 50 05 14 01 45 00 51 40 14 50 05
14 01 45 00 51 40 14 50 05 14 01 45 00 51 40 14
sd_setquality
0 = write(79, 10)
Size=1557, quality=10
ff d8 ff fe 28 3c 10 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 11)
Size=1557, quality=11
ff d8 ff fe 28 3c 11 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 12)
Size=1557, quality=12
ff d8 ff fe 28 3c 12 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 13)
Size=1557, quality=13
ff d8 ff fe 28 3c 13 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 14)
Size=1557, quality=14
ff d8 ff fe 28 3c 14 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 15)
Size=1557, quality=15
ff d8 ff fe 28 3c 15 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 16)
Size=1557, quality=16
ff d8 ff fe 28 3c 16 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 17)
Size=1557, quality=17
ff d8 ff fe 28 3c 17 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 18)
Size=1557, quality=18
ff d8 ff fe 28 3c 18 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 19)
Size=1557, quality=19
ff d8 ff fe 28 3c 19 fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 1a)
Size=1557, quality=1a
ff d8 ff fe 28 3c 1a fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 1b)
Size=1557, quality=1b
ff d8 ff fe 28 3c 1b fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 1c)
Size=1557, quality=1c
ff d8 ff fe 28 3c 1c fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 1d)
Size=1557, quality=1d
ff d8 ff fe 28 3c 1d fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 1e)
Size=1557, quality=1e
ff d8 ff fe 28 3c 1e fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00
sd_setquality
0 = write(79, 1f)
Size=1557, quality=1f
ff d8 ff fe 28 3c 1f fc 01 45 73 c1 c1 c2 f0 f8
58 58 18 18 58 78 18 18 18 74 60 e0 e0 e0 d1 4e
1e 16 0e 16 1d 2a 8c 3c 2c 2c 3a 15 34 61 e1 e1
d1 4d 34 51 45 14 aa 68 a5 2a 69 49 24 80 51 5d
00 51 40 14 50 05 14 01 45 00 51 40 14 50 05 14
01 45 00 51 40 14 50 05 14 01 45 00 51 40 14 50
05 14 01 45 00 51 40 14 50 05 14 01 45 00 51 40
14 50 05 14 01 45 00 51 40 14 50 05 14 01 45 00



> 
> is the frame header, so at offset 18, the JPEG streams starts.
> And I am 100% sure that the stream is JPEG coded.
> 
>>> Comments?
>> It would be interesting to know if somebody well versed in windows programming
>> could write a program to get JPEG frames out of the driver directly (provided
>> this is possible of course), if the image part of such a frame matches the data
>> seen on USB, we would then have the Huffman/DQT tables.
> 
> Might be possible for some one you knows how to interact with the Windoz 
> driver, I don't.
> Or you can get the sensor in saturation (only white picture), then you 
> know how the picture should look like. When the whole picture is only 
> white, each MCU has to be the same ;-)
> 
>> At the moment I'm stuck, since I see no way to find out what Huffman/DQT tables
>> that are used.
> 
> I found some interesting file in a TP6810 folder on my Windoz box after 
> I installed the driver. See Attachment ;-)
> 
> Hope this helps, I will study some more....
> 
> Thomas
> 
> 


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
