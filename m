Return-path: <linux-media-owner@vger.kernel.org>
Received: from jjussi.vpslink.com ([64.150.161.61]:34078 "EHLO mail.jjussi.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab3FCNdh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 09:33:37 -0400
Received: from [192.168.192.149] (Jussin-DELL.jjussi.com [192.168.192.149])
	by mail.jjussi.com (Postfix) with ESMTP id E2E4338102
	for <linux-media@vger.kernel.org>; Mon,  3 Jun 2013 09:33:36 -0400 (EDT)
Message-ID: <51AC9B0E.5030603@jjussi.com>
Date: Mon, 03 Jun 2013 16:33:02 +0300
From: Jussi Jaaskelainen <www.linuxtv.org@jjussi.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: All models of Technotrend TT-connect CT-3650 are not supported
References: <loom.20130530T123614-761@post.gmane.org> <loom.20130531T075102-721@post.gmane.org> <51ABB8F3.1060103@iki.fi>
In-Reply-To: <51ABB8F3.1060103@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3.6.2013 0.28, Antti Palosaari wrote:
> On 05/31/2013 08:53 AM, Jussi Jääskeläinen wrote:
>> Jussi Jääskeläinen <www.linuxtv.org <at> jjussi.com> writes:
>>
>>> Older models have: idVendor=0b48, idProduct=300d
>>> Model what I just bought was: idVendor=04b4, idProduct=8613 and this 
>>> is not
>>> supported!
>>>
>>> usb 2-1: New USB device found, idVendor=04b4, idProduct=8613
>>> usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> usbtest 2-1:1.0: FX2 device
>>> usbtest 2-1:1.0: high-speed {control bulk-in bulk-out} tests (+alt)
>>>
>>> Both products looks just same!
>>
>> Is there some program I could run what would "extract" all needed 
>> information
>> to developer, so driver could be created or known driver could be 
>> connected to
>> this ID?
>
> Your device eeprom is corrupted or eeprom is broken or connection to 
> eeprom is broken. 04b4:8613 is Cypress FX2 default USB ID. It tries to 
> download USB ID (also firmware in some cases) from the eeprom first 
> and after that enumerates to the USB bus.
>
> That device will not even work on Windows. Return it to the warranty.
>
> regards
> Antti
>
Yes. I think you are right..
I managed to get windows machine and installed needed software there.. 
It didn't find that USB device.. Then I connect my old CT-3650 to that 
cable and everything worked fine..
Problem is that I bought it from germany (DVBShop.net) and now I need 
"discuss" with them what we shall do it.. ;-)

-- 
JJussi

