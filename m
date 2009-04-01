Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39570 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZDAUEA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 16:04:00 -0400
Received: by ewy9 with SMTP id 9so231700ewy.37
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 13:03:57 -0700 (PDT)
Message-ID: <49D3C815.6000004@gmail.com>
Date: Wed, 01 Apr 2009 13:01:25 -0700
From: Alan Nisota <alannisota@gmail.com>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove support for Genpix-CW3K (damages hardware)
References: <49D2338C.7040703@gmail.com> <alpine.LRH.1.10.0904010934590.21921@pub4.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0904010934590.21921@pub4.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Boettcher wrote:
> Hi Alan,
>
> Don't you think it is enough to put a Kconfig option to activate the 
> USB-IDs (by default: off) rather than throwing everything away?
>
We could, but honestly, there are likely few people using this device 
who don't have to patch their kernel anyway, and it is a trivial patch 
to apply.  There have been 4 incarnations of the CW3K as the 
manufacturer has tried to actively make it not work in Linux (and users 
have found ways around that for each subsequent revision).  When I 
created the patch, I was not aware that the developer would take this 
stance.  Only the 1st batch of devices works with the existing code, and 
I'm not aware of any way to detect the device version. 

Given the manufacturer's stance and the potential to unknowingly damage 
the device (I've been informed that the manufacturer has stated that use 
of the Linux drivers with the CW3K will void any manufacturer's 
warranty), I would rather remove support for this piece of hardware 
outright.  I believe the manufacturer still supports the 8PSK->USB and 
Skywalker1 versions of the hardware on Linux (plus a new Skywalker2 
which requires a kernel patch to enable).


