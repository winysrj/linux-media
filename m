Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44869 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760504AbZLOPA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 10:00:57 -0500
Received: by fg-out-1718.google.com with SMTP id 19so17316fgg.1
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 07:00:55 -0800 (PST)
Message-ID: <4B27B2A8.80401@royalhat.org>
Date: Tue, 15 Dec 2009 16:00:40 +0000
From: Luis Maia <lmaia@royalhat.org>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: PATCH- gspca: added chipset revision sensor
References: <4B27063C.6020200@royalhat.org> <20091215085445.093ebfd8@tele>
In-Reply-To: <20091215085445.093ebfd8@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Tue, 15 Dec 2009 03:45:00 +0000
> Luis Maia <lmaia@royalhat.org> wrote:
>
>   
>> Added extra chipset revision (sensor) to fix camera zc0301 with  ID: 
>> 0ac8:301b .
>> Since i own one of this cameras fixed and tested it.
>>     
>
>   
>> -------------
>>
>> diff -uNr linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c 
>> linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
>> --- linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c    2009-12-14 
>> 17:47:25.000000000 +0000
>> +++ linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
>> 2009-12-15 02:42:13.000000000 +0000
>> @@ -6868,6 +6868,7 @@
>>      {0x8001, 0x13},
>>      {0x8000, 0x14},        /* CS2102K */
>>      {0x8400, 0x15},        /* TAS5130K */
>> +    {0xe400, 0x15},
>>  };
>>  
>>  static int vga_3wr_probe(struct gspca_dev *gspca_dev)
>> @@ -7634,7 +7635,7 @@
>>      {USB_DEVICE(0x0698, 0x2003)},
>>      {USB_DEVICE(0x0ac8, 0x0301), .driver_info = SENSOR_PAS106},
>>      {USB_DEVICE(0x0ac8, 0x0302), .driver_info = SENSOR_PAS106},
>> -    {USB_DEVICE(0x0ac8, 0x301b)},
>> +    {USB_DEVICE(0x0ac8, 0x301b), .driver_info = SENSOR_PB0330},
>>      {USB_DEVICE(0x0ac8, 0x303b)},
>>      {USB_DEVICE(0x0ac8, 0x305b), .driver_info =
>> SENSOR_TAS5130C_VF0250}, {USB_DEVICE(0x0ac8, 0x307b)},
>>     
>
> Hello Luis,
>
> I don't understand your patch:
> 1) you added 0xe400 in the chipset table giving the sensor tas5130c K
> 2) in the device table you say that the 0ac8:301b sensor is a pb0330
>    (but this information is not used: the sensor type in .driver_info
>    may be only pas106 for sif probe or mc501cb/tas5130_vf0250 for no
>    probe.
>
> What is exactly the sensor of your webcam?
>
>   

Sensor for my webcam is tas5130K, sorry my bad .i forgot to remove the line from .driver_info and didn't noticed.
Thus correct information is on the device table.
I bought a pack of webcams from the same suplier with same model for friends, i'm waiting for feedback from the patch.


