Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp13.wxs.nl ([195.121.247.25]:62039 "EHLO psmtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab0F2Fy7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 01:54:59 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp13.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L4R00A4LHRJQM@psmtp13.wxs.nl> for linux-media@vger.kernel.org;
 Tue, 29 Jun 2010 07:54:56 +0200 (MEST)
Date: Tue, 29 Jun 2010 07:54:53 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: v4l-dvb unsupported device: Conceptronic CTVDIGUSB2 1b80:d393
 (Afatech) - possibly similar to CTVCTVDIGRCU v3.0?
In-reply-to: <4C290096.5080209@gmail.com>
To: Matteo Sisti Sette <matteosistisette@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4C298AAD.2090701@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <AANLkTikojhopHeY2WuHxK_tbCs99_SV7ksWnYv4UXM4W@mail.gmail.com>
 <4C28FCA8.5090005@hoogenraad.net> <4C290096.5080209@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I see: apparently the versions earlier than V3.0 of CTVDIGRCU used 
Realtek RTL2831U. I'll make a note of that on the wiki page.

Matteo Sisti Sette wrote:
> On 06/28/2010 09:48 PM, Jan Hoogenraad wrote:
>> Matteo:
>>
>> If I read this well, CTVDIGUSB2 1b80:d393 (Afatech) is not at all
>> similar to the CTVDIGRCU.
>> The CTVDIGRCU has a Realtek RTL2831U decoder, and is NOT included in the
>> standard dvb list.
> 
> So is the table at http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices 
> incorrect?
> 
> It says:
> 
> Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0    
>  ✔ Yes, in kernel since 2.6.31
> 1b80:e397 USB2.0    
> Afatech AF9015
> 
> 
> Anyway, I see there are other sticks with chipsets by Afatech. Is there 
> any chance that some of the currently implemented driver would work fine 
> with my chipset if only I forced the driver to recognize the chipset as 
> another one by touching the source code?
> How could I try that? (if it deserves a try)
> 
> Thanks
> m.
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
