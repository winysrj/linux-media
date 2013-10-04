Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:62298 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3JDOTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:19:41 -0400
Received: by mail-lb0-f171.google.com with SMTP id u14so3375316lbd.30
        for <linux-media@vger.kernel.org>; Fri, 04 Oct 2013 07:19:40 -0700 (PDT)
Message-ID: <524ECE79.1020109@cogentembedded.com>
Date: Fri, 04 Oct 2013 18:19:37 +0400
From: Valentine <valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Simon Horman <horms@verge.net.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/3] media: Add SH-Mobile RCAR-H2 Lager board support
References: <1380029916-10331-1-git-send-email-valentine.barshak@cogentembedded.com> <Pine.LNX.4.64.1309241812350.22197@axis700.grange> <524E94B0.1060607@xs4all.nl>
In-Reply-To: <524E94B0.1060607@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2013 02:13 PM, Hans Verkuil wrote:
> On 09/24/2013 06:14 PM, Guennadi Liakhovetski wrote:
>> Hi Valentine,

Hi,

>>
>> Since patches 2 and 3 here are for soc-camera, I can offer to take all 3
>> via my tree after all comments to patch 1/3 are addressed and someone
>> (Laurent?) has acked it. Alternatively I can ack the two patches and let
>> all 3 go via another tree, or we can split this series too - no problem
>> with me either way.
>
> I prefer to take these patches. 95% of the work is in the first patch adding
> the new adv driver, and I'm responsible for video receivers/transmitters.
>
> There is going to be a revision anyway, so let's wait for v2.

Patch 2 doesn't really depend on the other ones.
So I think it can be added separately.
I'll resubmit it in a bit.

The ADV related stuff will be reworked/submitted later.

>
> Regards,
>
> 	Hans

Thanks,
Val.
>
>>
>> Thanks
>> Guennadi
>>
>> On Tue, 24 Sep 2013, Valentine Barshak wrote:
>>
>>> The following patches add ADV7611/ADV7612 HDMI receiver I2C driver
>>> and add RCAR H2 SOC support along with ADV761x output format support
>>> to rcar_vin soc_camera driver.
>>>
>>> These changes are needed for SH-Mobile R8A7790 Lager board
>>> video input support.
>>>
>>> Valentine Barshak (3):
>>>    media: i2c: Add ADV761X support
>>>    media: rcar_vin: Add preliminary r8a7790 H2 support
>>>    media: rcar_vin: Add RGB888_1X24 input format support
>>>
>>>   drivers/media/i2c/Kconfig                    |   11 +
>>>   drivers/media/i2c/Makefile                   |    1 +
>>>   drivers/media/i2c/adv761x.c                  | 1060 ++++++++++++++++++++++++++
>>>   drivers/media/platform/soc_camera/rcar_vin.c |   17 +-
>>>   include/media/adv761x.h                      |   28 +
>>>   5 files changed, 1114 insertions(+), 3 deletions(-)
>>>   create mode 100644 drivers/media/i2c/adv761x.c
>>>   create mode 100644 include/media/adv761x.h
>>>
>>> --
>>> 1.8.3.1
>>>
>>
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

