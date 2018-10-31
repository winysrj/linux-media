Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49879 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727645AbeJaSsS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 14:48:18 -0400
Subject: Re: [PATCH 2/4] tw9910: No SoC camera dependency
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
 <20181029230029.14630-3-sakari.ailus@linux.intel.com>
 <2f16f40b-e0cd-847e-8245-671bad4e6025@xs4all.nl>
 <20181031094954.wmto5l7bdsjxfi6v@paasikivi.fi.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0aa2ccc2-46da-fc49-e940-7dc2b2e40637@xs4all.nl>
Date: Wed, 31 Oct 2018 10:50:52 +0100
MIME-Version: 1.0
In-Reply-To: <20181031094954.wmto5l7bdsjxfi6v@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/31/2018 10:49 AM, Sakari Ailus wrote:
> On Tue, Oct 30, 2018 at 01:03:18PM +0100, Hans Verkuil wrote:
>> On 10/30/2018 12:00 AM, Sakari Ailus wrote:
>>> The tw9910 driver does not depend on SoC camera framework. Don't include
>>> the header, but instead include media/v4l2-async.h which the driver really
>>> needs.
>>
>> You might want to make a note of the fact that soc_camera.h includes
>> v4l2-async.h, so removing soc_camera.h requires adding v4l2-async.h.
>>
>> I couldn't understand how it compiled before without the v4l2-async.h
>> header until I saw that soc_camera.h includes it.
> 
> Yes. How about this:
> 
> Also include i2c/v4l2-async.h in drivers/media/i2c/tw9910.c as it depends
> on the header which used to be included through media/soc_camera.h.
> 

Looks good. With that change:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

for the whole series.

Regards,

	Hans
