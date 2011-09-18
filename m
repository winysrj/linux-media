Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1IRPvU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 11:51:20 -0400
Message-ID: <4E761374.2000804@redhat.com>
Date: Sun, 18 Sep 2011 12:51:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: can't find bt driver
References: <4E7527BD.8040802@lockie.ca> <4E75D669.7040207@redhat.com> <4E76133A.5030508@lockie.ca>
In-Reply-To: <4E76133A.5030508@lockie.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-09-2011 12:50, James escreveu:
> On 09/18/11 07:30, Mauro Carvalho Chehab wrote:
>> Em 17-09-2011 20:05, James escreveu:
>>> Where is the bt848 driver in kernel-3.0.4?
>> It should be at the usual places:
>>
>> $ find drivers/media/ -name bt8x*
>> drivers/media/video/bt8xx
>> drivers/media/dvb/bt8xx
>>
>> $ find sound/ -name bt8*
>> sound/pci/bt87x.c
> I found it under dvd but there is no check box, just three stars.
>   │ │    --- DVB/ATSC adapters                                            │ │
>   │ │          *** Supported BT878 Adapters ***
> 
> 
> I can't find it under video.
> All I have is:
>   │ │    --- Video capture adapters                                       │ │
>   │ │    [ ]   Enable advanced debug functionality                        │ │
>   │ │    [ ]   Enable old-style fixed minor ranges for video devices      │ │
>   │ │    [*]   Autoselect pertinent encoders/decoders and other helper chi│ │
>   │ │ < >   CPiA2 Video For Linux                                      │ │
>   │ │ < >   Philips SAA7134 support                                    │ │
>   │ │ < >   Siemens-Nixdorf 'Multimedia eXtension Board'               │ │
>   │ │ < >   Hexium HV-PCI6 and Orion frame grabber                     │ │
>   │ │ < >   Hexium Gemini frame grabber                                │ │
>   │ │ < >   Marvell 88ALP01 (Cafe) CMOS Camera Controller support      │ │
>   │ │ < >   SR030PC30 VGA camera sensor support                        │ │
>   │ │ < >   NOON010PC30 CIF camera sensor support                      │ │
>   │ │ < >   SoC camera support                                         │ │
>   │ │    [*]   V4L USB devices  --->
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Probably, You've disabled Remote Controller support or some
other needed dependency.

Cheers,
Mauro
