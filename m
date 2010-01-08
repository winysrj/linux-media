Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:1101
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab0AHDzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2010 22:55:15 -0500
Message-ID: <4B46AC9E.1050408@iinet.net.au>
Date: Fri, 08 Jan 2010 13:55:10 +1000
From: drappa <drappa@iinet.net.au>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: Compro VideoMate U80 DVB-T USB 2.0 High Definition Digital TV
 Stick
References: <4B3ABD9D.6040207@iinet.net.au> <4B4661ED.3070606@hoogenraad.net>
In-Reply-To: <4B4661ED.3070606@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jan Hoogenraad wrote:
> Can you give us the USB ID
> (type on the command line: lsusb, and report the output)
>
> The U90 has a RTL2831 in it. More info on the driver on:
> http://www.linuxtv.org/wiki/index.php/Rtl2831_devices
Hi Jan

USB ID is :  185b-0150  Compro

I built the driver as per the link but the device does not initialise.

Tested using an Ubuntu Studio Karmic installation with two afatech 9015 
USB devices connected ok

Thanks
drappa


>
> drappa wrote:
>> Hi All
>>
>> http://www.comprousa.com/en/product/u80/u80.html
>>
>> I'd be grateful if anyone can tell me if this device is supported 
>> yet, and if so, any pointers to getting it working.
>>
>> Thanks
>> Drappa
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
