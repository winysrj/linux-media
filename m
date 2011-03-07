Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab1CGL4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2011 06:56:39 -0500
Message-ID: <4D74C7EF.6040004@redhat.com>
Date: Mon, 07 Mar 2011 08:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <4D73472A.60702@retiisi.org.uk> <201103061117.42896.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103061117.42896.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-03-2011 07:17, Laurent Pinchart escreveu:
> Hi Sakari,
> 
> On Sunday 06 March 2011 09:34:50 Sakari Ailus wrote:
>> Hi Laurent,
>>
>> Many thanks for the pull req!
>>
>> On Thu, Feb 17, 2011 at 04:06:58PM +0100, Laurent Pinchart wrote:
>> ...
>>
>>>  drivers/media/video/omap3-isp/ispresizer.c         | 1693 ++++++++++++++
>>>  drivers/media/video/omap3-isp/ispresizer.h         |  147 ++
>>>  drivers/media/video/omap3-isp/ispstat.c            | 1092 +++++++++
>>>  drivers/media/video/omap3-isp/ispstat.h            |  169 ++
>>>  drivers/media/video/omap3-isp/ispvideo.c           | 1264 ++++++++++
>>>  drivers/media/video/omap3-isp/ispvideo.h           |  202 ++
>>>  drivers/media/video/omap3-isp/luma_enhance_table.h |   42 +
>>>  drivers/media/video/omap3-isp/noise_filter_table.h |   30 +
>>
>> ...
>>
>>>  include/linux/Kbuild                               |    4 +
>>>  include/linux/media.h                              |  132 ++
>>>  include/linux/omap3isp.h                           |  646 +++++
>>
>> What about renaming the directory omap3isp for the sake of consistency?
>> The header file is called omap3isp.h and omap3isp is the prefix used in
>> the driver for exported symbols.
> 
> I'm fine with both. If Mauro prefers omap3-isp, I can update the patches.

Probably, omap3-isp would be better, but I'm fine if you prefere omap3isp.

Cheers,
Mauro
