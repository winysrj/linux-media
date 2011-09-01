Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1IAFxU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Sep 2011 01:53:20 -0400
Message-ID: <4E5F1DCA.3000804@redhat.com>
Date: Thu, 01 Sep 2011 02:53:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 16/21] [staging] tm6000: Select interface on first open.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-17-git-send-email-thierry.reding@avionic-design.de> <4E5E934A.7000500@redhat.com> <20110901051945.GD18473@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20110901051945.GD18473@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-09-2011 02:19, Thierry Reding escreveu:
> * Mauro Carvalho Chehab wrote:
>> Em 04-08-2011 04:14, Thierry Reding escreveu:
>>> Instead of selecting the default interface setting when preparing
>>> isochronous transfers, select it on the first call to open() to make
>>> sure it is available earlier.
>>
>> Hmm... I fail to see what this is needed earlier. The ISOC endpont is used
>> only when the device is streaming.
>>
>> Did you get any bug related to it? If so, please describe it better.
> 
> I'm not sure whether this really fixes a bug, but it seems a little wrong to
> me to selecting the interface so late in the process when in fact the device
> is already being configured before (video standard, audio mode, firmware
> upload, ...).

Some applications may open the device just to change the controls. All other drivers
only set alternates/interfaces when the streaming is requested, as alternates/interfaces
are needed only there.

> Thinking about it, this may actually be part of the fix for the "device hangs
> sometimes for inexplicable reasons" bug that this whole patch series seems to
> fix.

It is unlikely, except if the firmware inside the chip is broken (unfortunately, 
we have serious reasons to believe that the internal firmware on this chipset has
serious bugs).

I prefer to not apply this patch, except if we have a good reason for that,
as otherwise this driver will behave different than the others.

Regards,
Mauro.

> 
> Thierry

