Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab2HUKSZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 06:18:25 -0400
Message-ID: <50336069.4030402@redhat.com>
Date: Tue, 21 Aug 2012 07:18:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.7] uvcvideo patches
References: <2583529.5y4fYzNJ2T@avalon> <1561599.3DnS2US7L9@avalon>
In-Reply-To: <1561599.3DnS2US7L9@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-08-2012 06:13, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Sunday 12 August 2012 17:25:05 Laurent Pinchart wrote:
>> Hi Mauro,
>>
>> The following changes since commit 518c267f4ca4c45cc51bd582b4aef9f0b9f01eba:
>>
>>   [media] saa7164: use native print_hex_dump() instead of custom one
>> (2012-08-12 07:58:54 -0300)
>>
>> are available in the git repository at:
>>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
>>
>> Jayakrishnan Memana (1):
>>       uvcvideo: Reset the bytesused field when recycling an erroneous buffer
> 
> This patch made it to your media-next tree, but not to the main media tree, 
> while the other three patches in this pull request did. Is there a specific 
> reason for that ?

This one is on my queue for 3.6. I should be sending the pull request for it
likely today. Due to the tree reorg, the -next pull from my tree failed
last week.

Regards,
Mauro
> 
>> Laurent Pinchart (2):
>>       uvcvideo: Support super speed endpoints
>>       uvcvideo: Add support for Ophir Optronics SPCAM 620U cameras
>>
>> Stefan Muenzel (1):
>>       uvcvideo: Support 10bit, 12bit and alternate 8bit greyscale formats
>>
>>  drivers/media/video/uvc/uvc_driver.c |   28 ++++++++++++++++++++++++++--
>>  drivers/media/video/uvc/uvc_queue.c  |    1 +
>>  drivers/media/video/uvc/uvc_video.c  |   30 ++++++++++++++++++++++++------
>>  drivers/media/video/uvc/uvcvideo.h   |    9 +++++++++
>>  4 files changed, 60 insertions(+), 8 deletions(-)
> 

