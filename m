Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.mail.ru ([94.100.179.91]:58042 "EHLO smtp2.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbbFZK76 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 06:59:58 -0400
Message-ID: <2DCE24E5218441A2AD205B5EA707CB62@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
Cc: <linux-media@vger.kernel.org>,
	"Devin Heitmueller" <dheitmueller@kernellabs.com>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown> <20150626062210.6ee035ec@recife.lan>
Subject: Re: XC5000C 0x14b4 status
Date: Fri, 26 Jun 2015 17:59:48 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Mauro Carvalho Chehab"
To: "Unembossed Name"
Cc: <linux-media@vger.kernel.org>; "Devin Heitmueller"
Sent: Friday, June 26, 2015 4:22 PM
Subject: Re: XC5000C 0x14b4 status


>> After that RF tuner identification became always successful.
>> I had a conversation with a hardware vendor.
>> Now I can say, that such behaviour, most likely, because of  "early" firmware for XC5000C.
>> This hardware vendor is using for his Windows driver a latest firmware, and reading Product ID register always gives 0x14b4 
>> status.
>> As he says, 0x1388 status is only for previous XC5000 IC. (Without C at end of a P/N)
>> Is this possible to patch xc5000.c with something like this:
>>
>>  #define XC_PRODUCT_ID_FW_LOADED 0x1388
>> +#define XC_PRODUCT_ID_FW_LOADED_XC5000C 0x14b4
>>
>>   case XC_PRODUCT_ID_FW_LOADED:
>> + case XC_PRODUCT_ID_FW_LOADED_XC5000C:
>>    printk(KERN_INFO
>>     "xc5000: Successfully identified at address 0x%02x\n",
>>
>> Or to try to get a chip vendor's permission for using a latest firmware for XC5000C in Linux, and then anyway, patch the driver?
>
> IMHO, the best is to get the latest firmware licensed is the best
> thing to do.
Agreed. If that possible of course.

> Does that "new" xc5000c come with a firmware pre-loaded already?
It's not "new" IC. It's XC5000C. Maybe i was interpreted wrong.
As I have understood, such behaviour can depends from FW version.
HW vendor says, that with his latest FW he always gets response 0x14b4.
Not a 0x1388. And I think, that these ICs still come without pre-loaded FW.
HW vendor also didn't says anything about FW pre-load possibility.

Best regards. 

