Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:35768 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZILBVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 21:21:19 -0400
Received: by vws33 with SMTP id 33so1056696vws.33
        for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 18:21:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAA944F.1090701@freemail.hu>
References: <4AA9F7A0.5080802@freemail.hu> <4AAA944F.1090701@freemail.hu>
Date: Fri, 11 Sep 2009 21:21:21 -0400
Message-ID: <c2fe070d0909111821w572f4f25gdf53cbc8f1855885@mail.gmail.com>
Subject: Re: image quality of Labtec Webcam 2200
From: leandro Costantino <lcostantino@gmail.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Luc Saillard <luc@saillard.org>,
	V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also , about the negative value. It happens to when using Pac7311 on
libv4l_convert. Usually it an -EAGAIN, that should be ignored.
svv application, just ignore that, and another apps take in account.
But would be nice to re test your webcam to find where the real problem is.
Best Regards


2009/9/11 Németh Márton <nm127@freemail.hu>:
> Márton Németh wrote:
>> Hi,
>>
>> I have a Labtec Webcam 2200 and I have problems with the image quality
>> with Linux 2.6.31 + libv4l 0.6.1. I made some experiments and stored
>> each captured image as raw data and when libv4l was able to convert
>> then I also stored the result as bmp.
>>
>> You can find my results at http://v4l-test.sourceforge.net/results/test-20090911/index.html
>> There are three types of problems:
>>  a) Sometimes the picture contains a 8x8 pixel error, like in image #9
>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00009
>>  b) Sometimes the brightness of the half picture is changed, like in
>>     images #7, #36 and #37
>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00007
>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00036
>>     http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00037
>>  c) Sometimes the libv4l cannot convert the raw image and the errno
>>     is set to EAGAIN (11), for example image #1, #2 and #3
>>
>> Do you know how can I fix these problems?
>
> I investigated the c) point a little bit. When I get a negative return value
> from the v4lconvert_convert() function then I print out the error message what the
> v4lconvert_get_error_message() function returns. With the result log file
> I executed a "grep v4l-convert |sort |uniq" command. All the error messages are
> coming from the tinyjpeg.c (Small jpeg decoder library):
>
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (65) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (66) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (67) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (68) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (69) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (70) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (71) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (72) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (73) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (75) in huffman unit
> v4l-convert: error decompressing JPEG: error: more then 63 AC components (76) in huffman unit
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x00
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x01
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x02
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x04
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x08
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x09
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x0a
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x10
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x12
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x14
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1a
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1b
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1c
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x1f
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x80
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x82
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x87
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x88
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x89
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8a
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8b
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8c
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8d
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8e
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x8f
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x90
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x91
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x92
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x93
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x94
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x95
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x96
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x97
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x99
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9b
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9c
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9d
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9e
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0x9f
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa3
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa5
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa6
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa7
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xa9
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xaa
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xab
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xad
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xaf
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb3
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb5
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb7
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb8
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xb9
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbc
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbd
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbe
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xbf
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc0
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc4
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc6
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc7
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xc9
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xcb
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xcc
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xcf
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd1
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd2
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd3
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xd4
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xdc
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xdf
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xe5
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xe7
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xe8
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xea
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xeb
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xec
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf0
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf2
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf4
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf5
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf8
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xf9
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xfa
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xfc
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xfe
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xff
> v4l-convert: error decompressing JPEG: Pixart JPEG error, stream does not end with EOF marker
> v4l-convert: error decompressing JPEG: unknown huffman code: 0000ff81
> v4l-convert: error decompressing JPEG: unknown huffman code: 0000ffec
> v4l-convert: error decompressing JPEG: unknown huffman code: 0000ffff
>
> Regards,
>
>        Márton Németh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
