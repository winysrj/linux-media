Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59424 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754206Ab2HNMrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 08:47:01 -0400
Message-ID: <502A48C2.9000400@iki.fi>
Date: Tue, 14 Aug 2012 15:46:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] mt9v032: Export horizontal and vertical blanking as
 V4L2 controls
References: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com> <1505124.16Oe9aIvIj@avalon> <20120813141805.GP29636@valkosipuli.retiisi.org.uk> <1433360.QycaYFLEyB@avalon>
In-Reply-To: <1433360.QycaYFLEyB@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,
>
> On Monday 13 August 2012 17:18:20 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> On Saturday 28 July 2012 00:27:23 Sakari Ailus wrote:
>>>> On Fri, Jul 27, 2012 at 01:02:04AM +0200, Laurent Pinchart wrote:
>>>>> On Thursday 26 July 2012 23:54:01 Sakari Ailus wrote:
>>>>>> On Tue, Jul 24, 2012 at 01:10:42AM +0200, Laurent Pinchart wrote:
>>>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>>>> ---
>>>>>>>
>>>>>>>    drivers/media/video/mt9v032.c |   36
>>>>>>>    ++++++++++++++++++++++++++++---
>>>>>>>    1 files changed, 33 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> Changes since v1:
>>>>>>>
>>>>>>> - Make sure the total horizontal time will not go below 660 when
>>>>>>>     setting the horizontal blanking control
>>>>>>>
>>>>>>> - Restrict the vertical blanking value to 3000 as documented in the
>>>>>>>     datasheet. Increasing the exposure time actually extends vertical
>>>>>>>     blanking, as long as the user doesn't forget to turn auto-exposure
>>>>>>>     off...
>>>>>>
>>>>>> Does binning either horizontally or vertically affect the blanking
>>>>>> limits? If the process is analogue then the answer is typically "yes".
>>>>>
>>>>> The datasheet doesn't specify whether binning and blanking can influence
>>>>> each other.
>>>>
>>>> Vertical binning is often analogue since digital binning would require as
>>>> much temporary memory as the row holds pixels. This means the hardware
>>>> already does binning before a/d conversion and there's only need to
>>>> actually read half the number of rows, hence the effect on frame length.
>>>
>>> That will affect the frame length, but why would it affect vertical
>>> blanking ?
>>
>> Frame length == image height + vertical blanking.
>>
>> The SMIA++ driver (at least) associates the blanking controls to the
>> pixel array subdev. They might be more naturally placed to the source
>> (either binner or scaler) but the width and height (to calculate the
>> frame and line length) are related to the dimensions of the pixel array
>> crop rectangle.
>>
>> So when the binning configuration changes, that changes the limits for
>> blanking and thus possibly also blanking itself.
>
> Do the blanking controls expose blanking after binning or before binning ? In
> the later case I don't see how binning would influence them.

Some sensors control the blanking in pixel array directly whereas some, 
like the SMIA++, control the frame length in the source (scaler or 
binner) source instead.

So it is up to the sensor hardware --- I think it's still better to keep 
all the controls in a single subdev. Otherwise it'd be quite difficult 
for the user to figure out how to calculate the frame rate.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
