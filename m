Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33626 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbcDRG15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 02:27:57 -0400
Subject: Re: [PATCH] [media] smiapp: provide g_skip_top_lines method in sensor
 ops
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1460794340-490-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160417214447.GV32125@valkosipuli.retiisi.org.uk>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	=?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <57147E69.8060506@gmail.com>
Date: Mon, 18 Apr 2016 09:27:53 +0300
MIME-Version: 1.0
In-Reply-To: <20160417214447.GV32125@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 18.04.2016 00:44, Sakari Ailus wrote:
> Hi Ivaylo,
>
> On Sat, Apr 16, 2016 at 11:12:20AM +0300, Ivaylo Dimitrov wrote:
>> Some sensors (like the one in Nokia N900) provide metadata in the first
>> couple of lines. Make that information information available to the
>> pipeline.
>>
>> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>> ---
>>   drivers/media/i2c/smiapp/smiapp-core.c | 12 ++++++++++++
>>   drivers/media/i2c/smiapp/smiapp.h      |  1 +
>>   2 files changed, 13 insertions(+)
>>
...
>
> I'm afraid I think this is not exactly the best way to approach the issue.
> It'd work, somehow, yes, but ---
>
> 1. A compliant sensor (at least in theory) is able to tell this information
> itself. The number of metadata lines is present in the sensor frame format
> descriptors.
>

Right. And this is where that number is taken from in the patch and made 
available to whoever wants to use it. See 
http://lxr.free-electrons.com/source/drivers/media/i2c/smiapp/smiapp-core.c#L177 
. I don't really understand your point here. Maybe the patch description 
is fuzzy? Could you elaborate?

> 2. The more generic problem of describing the frame layout should be solved.
> Sensor metadata is just a special case of this. I've proposed frame
> descriptors (see an old RFC
> <URL:http://www.spinics.net/lists/linux-media/msg67295.html>), but this is
> just a partial solution as well; the APIs would need to be extended to
> support metadata capture (I think Laurent has been working on that).
>

Could be, however what we have right now is 
http://lxr.free-electrons.com/source/drivers/media/platform/omap3isp/ispccp2.c#L369. 
Also, the patch is not trying to solve the problem with frame format 
description(or anything in general), but a mere way to pass an already 
available information in the sensor which is needed by omap3isp, by 
using an already existing API. I don't see how's that related to the way 
v4l API going to evolve in some (distant?) future. Not to say that once 
those frame format descriptors are available, it should be relatively 
easy to simply remove g_skip_top_lines form v4l2_subdev_sensor_ops and 
fix the drivers to use the new API.

BTW if you have any idea on how to pass (or set) the number of lines to 
be skipped at the start of the frame to omap3isp driver in some other 
way, I am fine with dropping the $subject patch and sending another one 
implementing your proposal.

Regards,
Ivo
