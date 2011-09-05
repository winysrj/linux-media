Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40432 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1IEOTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 10:19:33 -0400
Received: by yxj19 with SMTP id 19so2363884yxj.19
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 07:19:32 -0700 (PDT)
Message-ID: <4E64E8A6.7090807@gmail.com>
Date: Mon, 05 Sep 2011 11:20:06 -0400
From: Mauricio Henriquez <buhochileno@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: spca1528 device (Device 015: ID 04fc:1528 Sunplus Technology)..libv4l2:
 error turning on stream: Timer expired issue
References: <4E63D3F2.8090500@gmail.com> <alpine.LNX.2.00.1109042055540.8537@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1109042055540.8537@banach.math.auburn.edu>
Content-Type: multipart/mixed;
 boundary="------------020006040200070508060409"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020006040200070508060409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 09/04/2011 10:07 PM, Theodore Kilgore wrote:
>
> On Sun, 4 Sep 2011, Mauricio Henriquez wrote:
>
>    
>> Hi guys,
>>
>> Not sure if is the right place to ask since this device use a gspca driver
>> and not sure if that driver is related to uvc or not, if not please point
>> me to the right place...
>>      
> Looks right to me, and I hope that someone has more direct knowledge about
> your camera, which I do not. I do have a couple of questions, however, and
> a comment.
>
>    
>> Recently I'm trying to make work a Sunplus crappy mini HD USB camera, lsusb
>> list this info related to the device:
>>
>> Picture Transfer Protocol (PIMA 15470)
>> Bus 001 Device 015: ID 04fc:1528 Sunplus Technology Co., Ltd
>>
>>   idVendor           0x04fc Sunplus Technology Co., Ltd
>>    idProduct          0x1528
>>    bcdDevice            1.00
>>    iManufacturer           1 Sunplus Co Ltd
>>    iProduct                2 General Image Devic
>>    iSerial                 0
>> ...
>>
>> Using the gspca-2.13.6 on my Fed12 (2.6.31.6-166.fc12.i686.PAE kernel), the
>> device is listed as /dev/video1 and no error doing a dmesg...but trying to
>> make it work, let say with xawtv, I get:
>>
>> This is xawtv-3.95, running on Linux/i686 (2.6.31.6-166.fc12.i686.PAE)
>> xinerama 0: 1600x900+0+0
>> WARNING: No DGA direct video mode for this display.
>> /dev/video1 [v4l2]: no overlay support
>> v4l-conf had some trouble, trying to continue anyway
>> Warning: Missing charsets in String to FontSet conversion
>> Warning: Missing charsets in String to FontSet conversion
>> libv4l2: error turning on stream: Timer expired
>> ioctl: VIDIOC_STREAMON(int=1): Timer expired
>> ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument
>> v4l2: oops: select timeout
>>
>> ..or doing:
>> xawtv -c /dev/video1 -nodga -novm -norandr -noxv -noxv-video
>>
>> I get:
>> ioctl: VIDIOC_STREAMON(int=1): Timer expired
>> ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument
>> v4l2: oops: select timeout
>> libv4l2: error turning on stream: Timer expired
>> libv4l2: error reading: Invalid argument
>>
>>
>> vlc, cheese, etc give me similar "Timeout" related messages...
>>      
> The comment:
>
> Perhaps a good thing to try would be the nice, simple, basic program svv,
> which you can get from the website of Jean-Francois Moine. Some of these
> other things do not always work. Especially I have had trouble with xawtv,
> though the xawtv people may have fixed a lot of problems while I was not
> watching them.
>    
yeap, I try it, same kind of mesages...
> The question:
>
> Is this a dual-mode camera which is also supposed to have still camera
> capabilities? If so, you might be interested in contacting the Gphoto
> project. I just searched for it there, and it does not seem to be listed.
>    
yeap a dual-mode camera...
> I assume that the specialists on the spca cameras will step forward. I
> am not one of them, as I said. Good luck.
>
> Theodore Kilgore
>    
Thanks!

Mauricio


-- 
Mauricio R. Henriquez Schott
Escuela de Ingeniería en Computación
Universidad Austral de Chile - Sede Puerto Montt
Los Pinos S/N, Balneario de Pelluco, Puerto Montt - Chile
Tel: 65-487440
Fax: 65-277156
mail: mauriciohenriquez@uach.cl


--------------020006040200070508060409
Content-Type: text/x-vcard; charset=utf-8;
 name="buhochileno.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="buhochileno.vcf"

begin:vcard
fn:Mauricio Henriquez
n:Henriquez;Mauricio
org;quoted-printable:Universidad Austral de Chile - Sede Puerto Montt;Escuela de Computaci=C3=B3n
adr:;;Los Pinos S/N Balneario de Pelluco;Puerto Montt;Llanquihue;5480000;Chile
email;internet:mauriciohenriquez@uach.cl
title:Docente
tel;work:65-487440
tel;fax:65-277156
url:http://www.monobotics.ic.uach.cl
version:2.1
end:vcard


--------------020006040200070508060409--
