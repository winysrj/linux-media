Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:61779 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab0BBTse (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 14:48:34 -0500
Message-ID: <4B688190.7030108@kaiser-linux.li>
Date: Tue, 02 Feb 2010 20:48:32 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: possible problem found in PAC7302 JPEG decoding
References: <4B67466F.1030301@freemail.hu> <4B68028D.8000405@kaiser-linux.li> <4B6875F8.8040100@freemail.hu>
In-Reply-To: <4B6875F8.8040100@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2010 07:59 PM, Németh Márton wrote:
> Hi Thomas,
> Thomas Kaiser wrote:
>> On 02/01/2010 10:23 PM, Németh Márton wrote:
>>> Hello Hans,
>>>
>>> while I was dealing with Labtec Webcam 2200 and with gspca_pac7302 driver I recognised the
>>> following behaviour. The stream received from the webcam is splitted by the gspca_pac7302
>>> subdriver when the byte sequence 0xff, 0xff, 0x00, 0xff, 0x96 is found (pac_find_sof()).
>>> Before transmitting the data to the userspace a JPEG header is added (pac_start_frame())
>>> and the footer after the bytes 0xff, 0xd9 are removed.
>>>
>>> The data buffer which arrives to userspace looks like as follows (maybe not every detail is exact):
>>>
>>>  1. JPEG header
>>>
>>>  2. Some bytes of image data (near to 1024 bytes)
>>>
>>>  3. The byte sequence 0xff, 0xff, 0xff, 0x01 followed by 1024 bytes of data.
>>>     This marker sequence and data repeats a couple of time. Exactly how much
>>>     depends on the image content.
>>>
>>>  4. The byte sequence 0xff, 0xff, 0xff, 0x02 followed by 512 bytes of data.
>>>     This marker sequence and data also repeats a couple of time.
>>>
>>>  5. The byte sequence 0xff, 0xff, 0xff, 0x00 followed by a variable amount of
>>>     image data bytes.
>>>
>>>  6. The End of Image (EOI) marker 0xff, 0xd9.
>>>
>>> Now what can be wrong with the libv4l? In libv4lconvert/tinyjpeg.c, line 315 there is a
>>> huge macro which tries to remove the 0xff, 0xff, 0xff, xx byte sequence from the received
>>> image. This fails, however, if the image contains 0xff bytes just before the 0xff, 0xff,
>>> 0xff, xx sequence because one byte from the image data (the first 0xff) is removed, then
>>> the three 0xff bytes from the marker is also removed. The xx (which really belongs to the
>>> marker) is left in the image data instead of the original 0xff byte.
>>>
>>> Based on my experiments this problem sometimes causes corrupted image decoding or that the
>>> JPEG image cannot be decoded at all.
>>>
>> Hello Németh
>>
>> I remember the problem as I was working on the PAC7311.
>> http://www.kaiser-linux.li/index.php?title=PAC7311
>>
>>
>> This is the code I used in the JPEG decoder to remove the 0xff 0xff 0xff 
>>   0xnn markers.
>>
>> See http://www.kaiser-linux.li/files/PAC7311/gspcav1-PAC7311-20070425.tar.gz
>> decoder/gspcadecoder.c pac7311_decode()
> 
> Do you remember whether this code was working properly always?

Hello Németh

I am not 100% sure but it looked OK for me.

Anyway, we have to throw away these markers before the JPEG decoding 
starts. I don't think this code will fail when you parse the Byte stream 
(frame header removed before!).
We don't know these markers, so we don't need them.

Thomas

