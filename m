Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:53468 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1IRPsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 11:48:21 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p8IFmJ5E029798
	for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 11:48:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id D09671E0144
	for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 11:48:18 -0400 (EDT)
Message-ID: <4E76133A.5030508@lockie.ca>
Date: Sun, 18 Sep 2011 11:50:18 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: can't find bt driver
References: <4E7527BD.8040802@lockie.ca> <4E75D669.7040207@redhat.com>
In-Reply-To: <4E75D669.7040207@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/18/11 07:30, Mauro Carvalho Chehab wrote:
> Em 17-09-2011 20:05, James escreveu:
>> Where is the bt848 driver in kernel-3.0.4?
> It should be at the usual places:
>
> $ find drivers/media/ -name bt8x*
> drivers/media/video/bt8xx
> drivers/media/dvb/bt8xx
>
> $ find sound/ -name bt8*
> sound/pci/bt87x.c
I found it under dvd but there is no check box, just three stars.
   │ │    --- DVB/ATSC 
adapters                                            │ │
   │ │          *** Supported BT878 Adapters ***


I can't find it under video.
All I have is:
   │ │    --- Video capture 
adapters                                       │ │
   │ │    [ ]   Enable advanced debug 
functionality                        │ │
   │ │    [ ]   Enable old-style fixed minor ranges for video 
devices      │ │
   │ │    [*]   Autoselect pertinent encoders/decoders and other helper 
chi│ │
   │ │ < >   CPiA2 Video For Linux                                      │ │
   │ │ < >   Philips SAA7134 support                                    │ │
   │ │ < >   Siemens-Nixdorf 'Multimedia eXtension Board'               │ │
   │ │ < >   Hexium HV-PCI6 and Orion frame grabber                     │ │
   │ │ < >   Hexium Gemini frame grabber                                │ │
   │ │ < >   Marvell 88ALP01 (Cafe) CMOS Camera Controller support      │ │
   │ │ < >   SR030PC30 VGA camera sensor support                        │ │
   │ │ < >   NOON010PC30 CIF camera sensor support                      │ │
   │ │ < >   SoC camera support                                         │ │
   │ │    [*]   V4L USB devices  --->
