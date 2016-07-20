Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:59214 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbcGTROS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 13:14:18 -0400
Subject: Re: [PATCH v2 01/10] v4l: of: add "newavmode" property for Analog
 Devices codecs
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steve Longerbeam <slongerbeam@gmail.com>, <lars@metafoo.de>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-2-git-send-email-steve_longerbeam@mentor.com>
 <1d7e9b86-a4c9-8223-d8bd-8f4b9effcce8@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <0f49b30a-62ca-7a72-e12e-1c81cc3ca691@mentor.com>
Date: Wed, 20 Jul 2016 10:14:14 -0700
MIME-Version: 1.0
In-Reply-To: <1d7e9b86-a4c9-8223-d8bd-8f4b9effcce8@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2016 12:37 AM, Hans Verkuil wrote:
> On 07/20/2016 02:03 AM, Steve Longerbeam wrote:
>> This patch adds a "newavmode" boolean property as part of the v4l2 endpoint
>> properties. This indicates an Analog Devices decoder is generating EAV/SAV
>> codes to suit Analog Devices encoders.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>>  drivers/media/v4l2-core/v4l2-of.c                            | 4 ++++
>>  include/media/v4l2-mediabus.h                                | 5 +++++
>>  3 files changed, 11 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> index 9cd2a36..6f2df51 100644
>> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> @@ -88,6 +88,8 @@ Optional endpoint properties
>>  - field-even-active: field signal level during the even field data transmission.
>>  - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
>>    signal.
>> +- newavmode: a boolean property to indicate an Analog Devices decoder is
>> +  operating in NEWAVMODE. Valid for BT.656 busses only.
> This property is adv7180 specific and does not belong here.

Hi Hans, yes that was my initial reaction to this idea as well, but
you didn't respond to my first request for comment.

>
> Add this to Documentation/devicetree/bindings/media/i2c/adv7180.txt instead.

Yes, I'll move this property into adv7180.

Steve


