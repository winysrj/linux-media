Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46244 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab2HBJxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 05:53:32 -0400
References: <50186040.1050908@lockie.ca> <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com> <5019EE10.1000207@lockie.ca>
In-Reply-To: <5019EE10.1000207@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 02 Aug 2012 05:53:41 -0400
To: James <bjlockie@lockie.ca>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Message-ID: <bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James <bjlockie@lockie.ca> wrote:

>On 08/01/12 07:07, Andy Walls wrote:
>> James <bjlockie@lockie.ca> wrote:
>> 
>>> I got the latest kernel from git and I can't find the kernel options
>>> for my tv card.
>>>
>>> I have: http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1250
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>linux-media"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> /sbin/modinfo cx23885
>> 
>> Regards,
>> Andy
>> 
>
>I don't build any modules.
>
>In case anyone else has trouble getting to work (the kernel makes
>options invisible unless dependencies are met).
>
>1. Turn on expert mode (to be able to select frontends to build).
>General setup/Configure standard kernel features (expert users)
>
>2. Device Drivers/Multimedia support
>
>3. Analog TV support
>
>4. Digital TV support
>
>5. Remote Controller support
>
>6. Customize analog and hybrid tuner modules to build
>   Customize TV tuners  ---> Microtune MT2131 silicon tuner
>
>7. V4L PCI(e) devices/Conexant cx23885 (2388x successor) support
>
>8. DVB/ATSC adapters  ---> Customise the frontend modules to
>build/Customise DVB Frontends/Samsung S5H1409 based
>
>I think that is it but I did other stuff so I may be missing a step or
>2.
>
>
>
>Can I make the make menuconfig show all the options an when I select
>something, it selects all the dependencies?
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

No, the Kconfig system can't help.

You can 'grep MODULE_ drivers/media/video/cx23885/* drivers/media/video/cx25840/* ' and other relevant directories under drivers/media/{dvb, common} to find all the parameter options for all the drivers involved in making a HVR_1250 work.

Regards,
Andy
