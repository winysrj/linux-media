Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab0DNVHD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 17:07:03 -0400
Message-ID: <4BC62E69.60600@redhat.com>
Date: Wed, 14 Apr 2010 14:06:49 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: tm6000: firmware
References: <4BC5ECB8.2060208@arcor.de> <4BC5FF15.10605@redhat.com> <4BC60C72.6020901@arcor.de>
In-Reply-To: <4BC60C72.6020901@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-04-2010 11:41, Stefan Ringel escreveu:
> Am 14.04.2010 19:44, schrieb Mauro Carvalho Chehab:
>> Hi Stefan,
>>
>> Em 14-04-2010 09:26, Stefan Ringel escreveu:
>>   
>>> Hi Mauro,
>>>
>>> Can you added these three firmwares? The third is into archive file,
>>> because I'm extracted for an user (Bee Hock Goh).
>>>     
>> Sorry, but for us to put the firmwares at the server and/or add them at linux-firmware 
>> git tree, we need to get the distribution rights from the manufacturer,
>> as described on:
>> 	http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches#Firmware_submission
>>
>> So, we need Xceive's ack, in order to add the firmware files somewhere. That's why
>> currently we're using the procedure described on the comments at the extraction
>> tool:
>> 	Documentation/video4linux/extract_xc3028.pl  
>>
>> Cheers,
>> Mauro
>>   
> OK. In the archive is the modified extract_xc3028 tool for
> tm6000-xc3028.fw . Is that useful?

Yes, but:

1) Please, send it as a patch, with the proper SOB;

2) From a diff I did here:

-       my $sourcefile = "UDXTTM6000.sys";
-       my $hash = "cb9deb5508a5e150af2880f5b0066d78";
-       my $outfile = "tm6000-xc3028.fw";
+       my $sourcefile = "hcw85bda.sys";
+       my $hash = "0e44dbf63bb0169d57446aec21881ff2";
+       my $outfile = "xc3028-v27.fw";

This version works with another *.sys file. The proper way is to
check for the hash, and use the proper logic, based on the provided
sys file;

3) Please document where to get the UDXTTTM6000.sys file at the 
comments;

4) tm6000-xc3028.fw is a really bad name. It made sense only during
the development of tuner-xc2028.c, since, on that time, it seemed that
tm6000 had a different firmware version. In fact, the first devices
appeared with v 1.e firmware. So, a proper name for that version
would be xc3028-v1e.fw. We should rename it to be consistent.

It is not clear what version is provided with this version. Is it
v3.6? On a few cases, we've seen some modified versions of XC3028 firmwares
shipped with some specific board. Is it the case?


Cheers,
Mauro
