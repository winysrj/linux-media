Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n29E6sl6001445
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 10:06:54 -0400
Received: from sperry-03.control.lth.se (sperry-03.control.lth.se
	[130.235.83.190])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n29E6VnX013436
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 10:06:32 -0400
Message-ID: <49B52263.1010302@control.lth.se>
Date: Mon, 09 Mar 2009 15:06:27 +0100
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
Will do (TP6801 manual), also available at:

http://www.topro.com.tw/Product_Show.asp?Product_ID=39
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
> 5a ff d8 ff fe 14 1e 00 fd f5 45 7e e8 f8 b8 df 49 57
> 
> is the frame header, so at offset 18, the JPEG streams starts.
What do you base that on (just curious, I'm not in a position to argument)?

> And I am 100% sure that the stream is JPEG coded.
What makes you so sure? FF00 perhaps?

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
Hmm, perhaps setting all entries in the gammatables to the same value would give
some useful information then. See more below...

> 
>> At the moment I'm stuck, since I see no way to find out what Huffman/DQT tables
>> that are used.
> 
> I found some interesting file in a TP6810 folder on my Windoz box after 
> I installed the driver. See Attachment ;-)
Looks like 17 DQT tables to me, if one assumes that the description for register
79 (QUALITY):

  JPEG compression quality factor 0 ~ 31
    0: good quality
    15: smallest size
    16 ~ 31: ultra fine quality

can be interpreted as that there are 17 different quality levels, that should
mean that we have some information. If we then set the gammatables (Bulk-Out
with prefix) to constant values, we should know what data goes into the Huffman
encoding, which might give some additional information.
> 
> Hope this helps, I will study some more....
Don't know, but it's new data to chew on...


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
