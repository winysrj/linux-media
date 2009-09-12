Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:59659 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZILS0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 14:26:38 -0400
Message-ID: <4AABE7D0.6030308@freemail.hu>
Date: Sat, 12 Sep 2009 20:26:24 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: leandro Costantino <lcostantino@gmail.com>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Luc Saillard <luc@saillard.org>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: image quality of Labtec Webcam 2200
References: <4AA9F7A0.5080802@freemail.hu> <4AAA944F.1090701@freemail.hu>	 <c2fe070d0909111741l21120025v3f45eb8566d27c7a@mail.gmail.com>	 <4AAB3CB5.7090106@freemail.hu> <c2fe070d0909120751o2c4122c1r8607f37e65b41377@mail.gmail.com>
In-Reply-To: <c2fe070d0909120751o2c4122c1r8607f37e65b41377@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

leandro Costantino wrote:
> Nice, i will take a look.
> Anyway, be aware, that the "conversion error", is something expected
> on pac7311, in fact, Hans have commented that on the libv4lconvert.
> ......
>     if (result) {
>         /* Pixart webcam's seem to regulary generate corrupt frames, which
>            are best thrown away to avoid flashes in the video stream. Tell
>            the upper layer this is an intermediate fault and it should try
>            again with a new buffer by setting errno to EAGAIN */
>         if (src_pix_fmt == V4L2_PIX_FMT_PJPG ||
>             data->flags & V4LCONVERT_IS_SN9C20X) {
>           V4LCONVERT_ERR("decompressing JPEG: %s",
>             tinyjpeg_get_errorstring(data->jdec));
>           errno = EAGAIN;
>           return -1;
> ........
> That's the result of the EAGAIN.

The corrupted data coming from the device would be one reason. An other reason
could be the limitation of the libv4l 0.6.1 that it cannot understand the raw data
coming from the webcam. Maybe the raw data does not fulfill the JPEG specification
but still could have some meaning -- which we don't understand at the moment. The
different types of error messages mean for me that at least some of them could be
solved (i.e. "unknown huffman code").

> About, the half brightness picture, did that happens when autogain is off?

Yes, I tried to switch the "Auto Gain" control off before starting a measurement.
The half brightness pictures appears time to time.

Regards,

	M�rton N�meth

> Best Regards
> On Sat, Sep 12, 2009 at 2:16 AM, N�meth M�rton <nm127@freemail.hu> wrote:
>> Hello,
>>
>> thank you for looking at this topic.
>>
>> leandro Costantino wrote:
>>>> Hi ,
>>>> i tested it with 2.6.31-rc9 & libvl 0.6.1 + svv  and cannot reproduce.
>>>>
>>>> 301147.626826] gspca: probing 093a:2626
>>>> [301147.641578] gspca: probe ok
>>>> [301147.641607] gspca: probing 093a:2626
>>>> [301147.641770] gspca: probing 093a:2626
>>>> [301147.641829] usbcore: registered new interface driver pac7311
>>>> [301147.641835] pac7311: registered
>> I have the same dmesg output. My Labtec Webcam 2200 has the following labels
>> on the cable:
>>
>> M/N: V-UCE52
>> P/N: 860-000073
>> PID: CE73902
>>
>> Maybe there is more than one revision of the Labtec Webcam 2200 and I have
>> one with a different hardware/firmware inside?
>>
>>>> Could you try testing with svv.c app?
>> I used a bit modified svv.c to create the measurement result. The
>> modifications are to create the output HTML report and save the raw
>> and the BMP images. The display is not correct because I changed
>> the format from V4L2_PIX_FMT_RGB24 to V4L2_PIX_FMT_BGR24 to easily
>> save the result to BMP. The source code quality is not the best,
>> I am sorry about that, but I can still attach my source code which I
>> modified a little bit since my last report.
>>
>>>> pd: quality is not the best, but works ok. Seem that the format is not
>>>> the proper or expected "pjpeg" on your streaming.
>> Do you think about USB transfer problem?
>>
>> Regards,
>>
>>        M�rton N�meth
>>
>>>> 2009/9/11 N�meth M�rton <nm127@freemail.hu>:
>>>>>> M�rton N�meth wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I have a Labtec Webcam 2200 and I have problems with the image quality
>>>>>>>> with Linux 2.6.31 + libv4l 0.6.1. I made some experiments and stored
>>>>>>>> each captured image as raw data and when libv4l was able to convert
>>>>>>>> then I also stored the result as bmp.
>>>>>>>>
>>>>>>>> You can find my results at http://v4l-test.sourceforge.net/results/test-20090911/index.html
>>>>>>>> There are three types of problems:
>>>>>>>>  a) Sometimes the picture contains a 8x8 pixel error, like in image #9
>>>>>>>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00009
>>>>>>>>  b) Sometimes the brightness of the half picture is changed, like in
>>>>>>>>     images #7, #36 and #37
>>>>>>>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00007
>>>>>>>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00036
>>>>>>>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00037
>>>>>>>>  c) Sometimes the libv4l cannot convert the raw image and the errno
>>>>>>>>     is set to EAGAIN (11), for example image #1, #2 and #3
>>>>>>>>
>>>>>>>> Do you know how can I fix these problems?
>>>>>> I investigated the c) point a little bit. When I get a negative return value
>>>>>> from the v4lconvert_convert() function then I print out the error message what the
>>>>>> v4lconvert_get_error_message() function returns. With the result log file
>>>>>> I executed a "grep v4l-convert |sort |uniq" command. All the error messages are
>>>>>> coming from the tinyjpeg.c (Small jpeg decoder library):
>>>>>>
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (65) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (66) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (67) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (68) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (69) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (70) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (71) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (72) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (73) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (75) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: error: more then 63 AC components (76) in huffman unit
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x00
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x01
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x02
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x04
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x08
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x09
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x0a
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x10
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x12
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x14
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1a
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1b
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1c
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1f
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x80
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x82
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x87
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x88
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x89
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8a
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8b
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8c
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8d
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8e
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8f
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x90
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x91
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x92
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x93
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x94
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x95
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x96
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x97
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x99
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9b
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9c
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9d
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9e
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9f
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa3
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa5
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa6
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa7
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa9
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xaa
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xab
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xad
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xaf
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb3
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb5
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb7
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb8
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb9
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbc
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbd
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbe
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbf
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc0
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc4
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc6
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc7
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc9
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xcb
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xcc
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xcf
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd1
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd2
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd3
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd4
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xdc
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xdf
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xe5
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xe7
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xe8
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xea
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xeb
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xec
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf0
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf2
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf4
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf5
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf8
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf9
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xfa
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xfc
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xfe
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xff
>>>>>> v4l-convert: error decompressing JPEG: Pixart JPEG error, stream does not end with EOF marker
>>>>>> v4l-convert: error decompressing JPEG: unknown huffman code: 0000ff81
>>>>>> v4l-convert: error decompressing JPEG: unknown huffman code: 0000ffec
>>>>>> v4l-convert: error decompressing JPEG: unknown huffman code: 0000ffff
>>>>>>
>>>>>> Regards,
>>>>>>
>>>>>>        M�rton N�meth
