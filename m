Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0JWKB6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 06:01:58 -0400
Message-ID: <4CC2B291.1090305@redhat.com>
Date: Sat, 23 Oct 2010 08:01:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: tvbox <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH][UPDATE for 2.6.37] LME2510(C) DM04/QQBOX USB DVB-S BOXES
References: <1287258283.494.10.camel@canaries-desktop>	 <4CC22B52.7040003@redhat.com> <1287825326.6605.43.camel@canaries-desktop>
In-Reply-To: <1287825326.6605.43.camel@canaries-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-10-2010 07:15, tvbox escreveu:
> On Fri, 2010-10-22 at 22:24 -0200, Mauro Carvalho Chehab wrote:
>> Em 16-10-2010 16:44, tvbox escreveu:
>>> Updated driver for DM04/QQBOX USB DVB-S BOXES to version 1.60
>>>
>>> These include
>>> -later kill of usb_buffer to avoid kernel crash on hot unplugging.
>>> -DiSEqC functions.
>>> -LNB Power switch
>>> -Faster channel change.
>>> -support for LG tuner on LME2510C.
>>> -firmware switching for LG tuner.
>>
>> Please, don't do updates like that, adding several different things into just
>> one patch. Instead, send one patch per change.
>>
> The patches as released is a working driver.
> 
> This device is particularly temperamental and covers several
> adaptations. The driver returned to beta testing through several of
> those changes.
> 
> I didn't want release patches that would have produced an unworkable
> driver for the user.

Ok, but, instead of sending one patch grouping several changes, please send
me a series of patches. In this case, you should be sending, instead, 6 patches
(e. g. one for each functional change), e. g. :

[PATCH 1/6] later kill of usb_buffer to avoid kernel crash on hot unplugging
[PATCH 2/6] DiSEqC functions
[PATCH 3/6] LNB Power switch
[PATCH 4/6] Faster channel change
[PATCH 5/6] support for LG tuner on LME2510C
[PATCH 6/6] firmware switching for LG tuner

properly describing at the body why each patch is needed.

Cheers,
Mauro.
