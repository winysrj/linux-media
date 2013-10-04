Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1417 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3JDKNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 06:13:37 -0400
Message-ID: <524E94B0.1060607@xs4all.nl>
Date: Fri, 04 Oct 2013 12:13:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Valentine Barshak <valentine.barshak@cogentembedded.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Simon Horman <horms@verge.net.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/3] media: Add SH-Mobile RCAR-H2 Lager board support
References: <1380029916-10331-1-git-send-email-valentine.barshak@cogentembedded.com> <Pine.LNX.4.64.1309241812350.22197@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1309241812350.22197@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2013 06:14 PM, Guennadi Liakhovetski wrote:
> Hi Valentine,
> 
> Since patches 2 and 3 here are for soc-camera, I can offer to take all 3 
> via my tree after all comments to patch 1/3 are addressed and someone 
> (Laurent?) has acked it. Alternatively I can ack the two patches and let 
> all 3 go via another tree, or we can split this series too - no problem 
> with me either way.

I prefer to take these patches. 95% of the work is in the first patch adding
the new adv driver, and I'm responsible for video receivers/transmitters.

There is going to be a revision anyway, so let's wait for v2.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
> On Tue, 24 Sep 2013, Valentine Barshak wrote:
> 
>> The following patches add ADV7611/ADV7612 HDMI receiver I2C driver
>> and add RCAR H2 SOC support along with ADV761x output format support
>> to rcar_vin soc_camera driver.
>>
>> These changes are needed for SH-Mobile R8A7790 Lager board
>> video input support.
>>
>> Valentine Barshak (3):
>>   media: i2c: Add ADV761X support
>>   media: rcar_vin: Add preliminary r8a7790 H2 support
>>   media: rcar_vin: Add RGB888_1X24 input format support
>>
>>  drivers/media/i2c/Kconfig                    |   11 +
>>  drivers/media/i2c/Makefile                   |    1 +
>>  drivers/media/i2c/adv761x.c                  | 1060 ++++++++++++++++++++++++++
>>  drivers/media/platform/soc_camera/rcar_vin.c |   17 +-
>>  include/media/adv761x.h                      |   28 +
>>  5 files changed, 1114 insertions(+), 3 deletions(-)
>>  create mode 100644 drivers/media/i2c/adv761x.c
>>  create mode 100644 include/media/adv761x.h
>>
>> -- 
>> 1.8.3.1
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

