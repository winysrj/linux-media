Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:37141 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbZDTOVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 10:21:32 -0400
Date: Mon, 20 Apr 2009 16:21:17 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Antti Palosaari <crope@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Add Elgato EyeTV DTT deluxe to dibcom driver
In-Reply-To: <49EB8431.70202@iki.fi>
Message-ID: <alpine.LRH.1.10.0904201604430.11443@pub4.ifh.de>
References: <E63C5667-D18B-4D13-9D88-15293E1B12B2@snafu.de> <49EB8431.70202@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 19 Apr 2009, Antti Palosaari wrote:

> Armin Schenker kirjoitti:
>> -        .num_device_descs = 11,
>> +        .num_device_descs = 12,
>
>> -    struct dvb_usb_device_description devices[11];
>> +    struct dvb_usb_device_description devices[12];
>
> I don't comment about this patch but general.
>
> I didn't realized this value is allowed to increase when adding new devices. 
> Due to that there is now three dvb_usb_device_properties in af9015 which 
> makes driver a little bit complex.
>
> What we should do? Can I remove code from af9015 and increase 
> dvb_usb_device_description count to about 30? What is biggest suitable value 
> we want use, how much memory one entry will take.

One dvb_usb_device_description is (2*15+1) * pointer-size. For 
PC-architecture it seems not big for me, but for other architectures it 
can be a problem.

After 4 years in place I think we could evaluate whether another method 
for the module_device_id-table in all those dvb-usb-modules cannot be made 
differently, best case, without any fixed array-sizes.

One very convenient option would be the driver_info-field in the 
usb_device_id-table, but it will be hard to convert all drivers and to 
keep some information we have today (like the device name) at the same 
time .

Beside the size-problem there is still the issue of having the fixed 
indexes referenced by the dvb_usb_device_descriptor.

No matter how I think about it, I still have such a link between the 
mod_id_table and the dvb_usb_device_description.

If someone comes up with a good idea how to replace the current way of 
doing things, it'll be more than welcome. :)

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
