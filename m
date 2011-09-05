Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42447 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1IEOdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 10:33:18 -0400
Received: by gxk21 with SMTP id 21so3368496gxk.19
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 07:33:17 -0700 (PDT)
Message-ID: <4E64EBDD.9050807@gmail.com>
Date: Mon, 05 Sep 2011 11:33:49 -0400
From: Mauricio Henriquez <buhochileno@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: spca1528 device (Device 015: ID 04fc:1528 Sunplus Technology)..libv4l2:
 error turning on	stream: Timer expired issue
References: <4E63D3F2.8090500@gmail.com> <20110905091959.727346d5@tele>
In-Reply-To: <20110905091959.727346d5@tele>
Content-Type: multipart/mixed;
 boundary="------------070704040706050609090505"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070704040706050609090505
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/05/2011 03:19 AM, Jean-Francois Moine wrote:
> On Sun, 04 Sep 2011 15:39:30 -0400
> Mauricio Henriquez<buhochileno@gmail.com>  wrote:
>
>    
>> Recently I'm trying to make work a Sunplus crappy mini HD USB camera, lsusb
>> list this info related to the device:
>>
>> Picture Transfer Protocol (PIMA 15470)
>> Bus 001 Device 015: ID 04fc:1528 Sunplus Technology Co., Ltd
>>
>>    idVendor           0x04fc Sunplus Technology Co., Ltd
>>     idProduct          0x1528
>>     bcdDevice            1.00
>>     iManufacturer           1 Sunplus Co Ltd
>>     iProduct                2 General Image Devic
>>     iSerial                 0
>> ...
>>
>> Using the gspca-2.13.6 on my Fed12 (2.6.31.6-166.fc12.i686.PAE kernel), the
>> device is listed as /dev/video1 and no error doing a dmesg...but trying to
>> make it work, let say with xawtv, I get:
>>      
> 	[snip]
>
> Hi Mauricio,
>
> The problem seems tied to the alternate setting. It must be the #3
> while the lastest versions of gspca compute a "best" one. May you apply
> the following patch to gspca-2.13.6?
>    
Thanks Jean, yeap I apply the patch, but still the same kind of messages 
about timeout sing xawtv or svv:

xawtv:
ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument
libv4l2: error turning on stream: Timer expired
libv4l2: error reading: Invalid argument
v4l2: read: Invalid argument
libv4l2: error turning on stream: Timer expired
ioctl: VIDIOC_STREAMON(int=1): Timer expired
v4l2: oops: select timeout
ioctl: VIDIOC_REQBUFS(count=0;type=VIDEO_CAPTURE;memory=MMAP): Device or 
resource busy
libv4l2: error reading: Invalid argument
v4l2: read: Invalid argument

svv:
raw pixfmt: JPEG 640x480
pixfmt: RGB3 640x480
mmap method
VIDIOC_STREAMON error 62, Timer expired

this camera in mass storage mode works ok...

Cheers

Mauricio

> ----------------------8<----------------------
> --- build/spca1528.c.orig	2011-09-05 08:41:54.000000000 +0200
> +++ build/spca1528.c	2011-09-05 08:53:51.000000000 +0200
> @@ -307,8 +307,6 @@
>   	sd->color = COLOR_DEF;
>   	sd->sharpness = SHARPNESS_DEF;
>
> -	gspca_dev->nbalt = 4;		/* use alternate setting 3 */
> -
>   	return 0;
>   }
>
> @@ -349,6 +347,9 @@
>   	reg_r(gspca_dev, 0x25, 0x0004, 1);
>   	reg_wb(gspca_dev, 0x27, 0x0000, 0x0000, 0x06);
>   	reg_r(gspca_dev, 0x27, 0x0000, 1);
> +
> +	gspca_dev->alt = 4;		/* use alternate setting 3 */
> +
>   	return gspca_dev->usb_err;
>   }
>
> ----------------------8<----------------------
>
> (Theodore, this webcam may work in mass storage mode with ID 04fc:0171.
> In webcam mode with ID 04fc:1528, it offers 3 interfaces: interface 0
> contains only an interrupt endpoint, interface 1 is the webcam with
> only isochronous endpoints and interface 2 contains bulk in, bulk out
> and interrupt in endpoints - I don't know how to use the interfaces 0
> and 2, but sure the interface 2 could be used to access the camera
> images)
>
>    


-- 
Mauricio R. Henriquez Schott
Escuela de Ingeniería en Computación
Universidad Austral de Chile - Sede Puerto Montt
Los Pinos S/N, Balneario de Pelluco, Puerto Montt - Chile
Tel: 65-487440
Fax: 65-277156
mail: mauriciohenriquez@uach.cl


--------------070704040706050609090505
Content-Type: text/x-vcard; charset=utf-8;
 name="buhochileno.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="buhochileno.vcf"

YmVnaW46dmNhcmQNCmZuOk1hdXJpY2lvIEhlbnJpcXVleg0KbjpIZW5yaXF1ZXo7TWF1cmlj
aW8NCm9yZztxdW90ZWQtcHJpbnRhYmxlOlVuaXZlcnNpZGFkIEF1c3RyYWwgZGUgQ2hpbGUg
LSBTZWRlIFB1ZXJ0byBNb250dDtFc2N1ZWxhIGRlIENvbXB1dGFjaT1DMz1CM24NCmFkcjo7
O0xvcyBQaW5vcyBTL04gQmFsbmVhcmlvIGRlIFBlbGx1Y287UHVlcnRvIE1vbnR0O0xsYW5x
dWlodWU7NTQ4MDAwMDtDaGlsZQ0KZW1haWw7aW50ZXJuZXQ6bWF1cmljaW9oZW5yaXF1ZXpA
dWFjaC5jbA0KdGl0bGU6RG9jZW50ZQ0KdGVsO3dvcms6NjUtNDg3NDQwDQp0ZWw7ZmF4OjY1
LTI3NzE1Ng0KdXJsOmh0dHA6Ly93d3cubW9ub2JvdGljcy5pYy51YWNoLmNsDQp2ZXJzaW9u
OjIuMQ0KZW5kOnZjYXJkDQoNCg==
--------------070704040706050609090505--
