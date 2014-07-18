Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:45089 "EHLO
	smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934407AbaGROb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 10:31:27 -0400
Message-ID: <53C92FB6.40300@grumpydevil.homelinux.org>
Date: Fri, 18 Jul 2014 16:31:18 +0200
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9?= <poisson.rene@neuf.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ddbridge -- kernel 3.15.6
References: <53C920FB.1040501@grumpydevil.homelinux.org> <6E594BCC1018445BA338AAABB100405C@ci5fish>
In-Reply-To: <6E594BCC1018445BA338AAABB100405C@ci5fish>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rene,

DVB-S2

I would have expected the relevant modules to be loaded after detecting 
the bridge, and after ddbridge detecting the relevant HW behind. This is 
apparently not happening, so how to trigger?

Cheers


Rudy

On 18-07-14 16:27, René wrote:
> Hi Rudy,
>
> ddbridge is a ... bridge. So it is an interface between PCIe and a 
> "DVB" device. So missing info is what frontend and demux (at least) 
> devices type. Is it DVB-C(2)/T(2)/S(2) ?
>
> René
>
> --------------------------------------------------
> From: "Rudy Zijlstra" <rudy@grumpydevil.homelinux.org>
> Sent: Friday, July 18, 2014 3:28 PM
> To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
> Subject: ddbridge -- kernel 3.15.6
>
>> Dears,
>>
>> I have a ddbridge device:
>>
>> 03:00.0 Multimedia controller: Device dd01:0003
>>         Subsystem: Device dd01:0021
>>         Flags: fast devsel, IRQ 17
>>         Memory at f0900000 (64-bit, non-prefetchable) [size=64K]
>>         Capabilities: [50] Power Management version 3
>>         Capabilities: [90] Express Endpoint, MSI 00
>>         Capabilities: [100] Vendor Specific Information: ID=0000 
>> Rev=0 Len=00c <?>
>>         Kernel driver in use: DDBridge
>>
>> The kernel recognises as seen in dmesg:
>>
>> [    1.811626] Digital Devices PCIE bridge driver, Copyright (C) 
>> 2010-11 Digital Devices GmbH
>> [    1.813996] pci 0000:01:19.0: enabling device (0000 -> 0002)
>> [    1.816033] DDBridge driver detected: Digital Devices PCIe bridge
>> [    1.816273] HW 0001000d FW 00010004
>>
>> But /dev/dvb remains empty, only /dev/ddbridge exists.
>>
>> Any pointers are much appreciated
>>
>> Cheers
>>
>>
>> Rudy
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html 

