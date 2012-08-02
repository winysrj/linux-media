Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:55928 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2HBDDt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 23:03:49 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-135.nexicom.net [216.168.121.135])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q7233k70021900
	for <linux-media@vger.kernel.org>; Wed, 1 Aug 2012 23:03:46 -0400
Received: from [127.0.0.1] (unknown [IPv6:::1])
	by mail.lockie.ca (Postfix) with ESMTP id 0406F1E0289
	for <linux-media@vger.kernel.org>; Wed,  1 Aug 2012 23:03:44 -0400 (EDT)
Message-ID: <5019EE10.1000207@lockie.ca>
Date: Wed, 01 Aug 2012 23:03:44 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
References: <50186040.1050908@lockie.ca> <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>
In-Reply-To: <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/12 07:07, Andy Walls wrote:
> James <bjlockie@lockie.ca> wrote:
> 
>> I got the latest kernel from git and I can't find the kernel options
>> for my tv card.
>>
>> I have: http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1250
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> /sbin/modinfo cx23885
> 
> Regards,
> Andy
> 

I don't build any modules.

In case anyone else has trouble getting to work (the kernel makes options invisible unless dependencies are met).

1. Turn on expert mode (to be able to select frontends to build).
General setup/Configure standard kernel features (expert users)

2. Device Drivers/Multimedia support

3. Analog TV support

4. Digital TV support

5. Remote Controller support

6. Customize analog and hybrid tuner modules to build
   Customize TV tuners  ---> Microtune MT2131 silicon tuner

7. V4L PCI(e) devices/Conexant cx23885 (2388x successor) support

8. DVB/ATSC adapters  ---> Customise the frontend modules to build/Customise DVB Frontends/Samsung S5H1409 based

I think that is it but I did other stuff so I may be missing a step or 2.



Can I make the make menuconfig show all the options an when I select something, it selects all the dependencies?
