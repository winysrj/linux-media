Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([67.18.65.21]:38676 "EHLO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762294Ab2KBRbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Nov 2012 13:31:12 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway07.websitewelcome.com (Postfix) with ESMTP id 84F786B9D96D0
	for <linux-media@vger.kernel.org>; Fri,  2 Nov 2012 12:22:21 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
Cc: "'Richard'" <tuxbox.guru@gmail.com>, <linux-media@vger.kernel.org>
References: <CAKQROYViF1PhLNquiPOQAxRs4jnwHXg-kK2PBG3irTtnXpDCwg@mail.gmail.com>	<000d01cdb886$d08f8ed0$71aeac70$@com> <20121102104734.04d708de@gaivota.chehab>
In-Reply-To: <20121102104734.04d708de@gaivota.chehab>
Subject: RE: Skeleton LinuxDVB framework
Date: Fri, 2 Nov 2012 10:22:20 -0700
Message-ID: <000501cdb91e$9ec4fdc0$dc4ef940$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Mauro, for pointing out and clarifying.		-- Charlie


-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Mauro Carvalho
Chehab
Sent: Friday, November 02, 2012 5:48 AM
To: Charlie X. Liu
Cc: 'Richard'; linux-media@vger.kernel.org
Subject: Re: Skeleton LinuxDVB framework

Em Thu, 1 Nov 2012 16:15:41 -0700
"Charlie X. Liu" <charlie@sensoray.com> escreveu:

> You could check or refer to the following links, for start:
> 
> http://linuxtv.org/wiki/index.php/Main_Page
> http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps


Be careful with the docs below:

> http://www.linuxtv.org/docs/dvbapi/dvbapi.html
> http://linuxtv.org/downloads/legacy/linux-dvb-api-v4/linux-dvb-api-v4-
> 0-1.pdf http://elinux.org/images/1/13/Celf_linux_dvb_v4.pdf

As DVB version 3 or below is outdated, and v4 was never finished/merged.

The DVBv5 (currently, on version 5.8) is the one you should use:

> http://linuxtv.org/downloads/v4l-dvb-apis/dvbapi.html

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org 
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Richard
> Sent: Thursday, November 01, 2012 6:35 AM
> To: linux-media@vger.kernel.org
> Subject: Skeleton LinuxDVB framework
> 
> Hi all,
> 
> As a newbie to the LinuxDVB Device drivers, I am wondering if there is 
> a framework template to get a quick start in to DVB device drivers. I 
> currently have a SOC chip and an manufacturers API that I would like 
> to make in to a LinuxDVB compliant device. (Tuners/Demods/CA/MPEG 
> output hardware
> etc)

It is probably easier to get one driver of each type as an example and
change it to fill your needs.

> 
> Any information is greatly appreciated.
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html



Cheers,
Mauro
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

