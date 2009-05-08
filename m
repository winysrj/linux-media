Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp31.wxs.nl ([195.121.247.33]:32843 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZEHRgb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2009 13:36:31 -0400
Received: from localhost.sitecomwl312
 (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14
 2006)) with ESMTP id <0KJC000GC68PKB@psmtp31.wxs.nl> for
 linux-media@vger.kernel.org; Fri, 08 May 2009 19:36:30 +0200 (CEST)
Date: Fri, 08 May 2009 19:36:24 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Compro VideoMate U90
In-reply-to: <66cf70750903100132q5e28217icd43df860585863c@mail.gmail.com>
To: scott <scottlegs@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4A046D98.1070206@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <66cf70750903092243v7c1ba7c0of95d0bdc836116be@mail.gmail.com>
 <66cf70750903100132q5e28217icd43df860585863c@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


No problem. Please send me the ID, which can be found with the command:
lsusb -v

scott wrote:
> After investigating the Windows driver CD, the chip appeared to be
> described as a RTL2831U.
> 
> This led me to the rtl2831-r2 driver here:
> http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/
> 
> The product ID of my device doesn't seem to be defined in this driver,
> though many similar device based on the same chipset are. Is it
> possible to add the ID for this device? I would be happy to test!
> 
> Regards,
> Scott.
> 
> On Tue, Mar 10, 2009 at 2:43 PM, scott <scottlegs@gmail.com> wrote:
>> Hi,
>> I recently bought a Compro VideoMate U90, described on the box as a
>> "USB 2.0 DVB-T Stick with Remote".
>>
>> When plugging it in, /var/log/messages simply says:
>>
>> Mar 10 12:50:49 sonata kernel: [60359.936022] usb 4-5: new high speed
>> USB device using ehci_hcd and address 3
>> Mar 10 12:50:49 sonata kernel: [60360.070474] usb 4-5: configuration
>> #1 chosen from 1 choice
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
