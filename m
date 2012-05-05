Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56920 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab2EEOCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 10:02:44 -0400
Received: by wibhj6 with SMTP id hj6so2156197wib.1
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 07:02:43 -0700 (PDT)
Message-ID: <4FA53301.5030707@gmail.com>
Date: Sat, 05 May 2012 16:02:41 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, t.stanislaws@samsung.com
Subject: Re: [RFC] V4L: Rename V4L2_SEL_TGT_*_ACTIVE to V4L2_SEL_TGT_*_ACTUAL
References: <1336221247-6543-1-git-send-email-sylvester.nawrocki@gmail.com> <4FA52803.3040206@iki.fi>
In-Reply-To: <4FA52803.3040206@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 05/05/2012 03:15 PM, Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
>> After introduction of the selection API on subdevs we have following sets
>> of selection targets:
>>
>> /dev/v4l-subdev? | /dev/video?
>> -------------------------------------------------------------------------
>> V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL | V4L2_SEL_TGT_CROP_ACTIVE
>> V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS | V4L2_SEL_TGT_CROP_BOUNDS
>> | V4L2_SEL_TGT_CROP_DEFAULT
>> | V4L2_SEL_TGT_CROP_PADDED
>> V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL | V4L2_SEL_TGT_COMPOSE_ACTIVE
>> V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS | V4L2_SEL_TGT_COMPOSE_BOUNDS
>> | V4L2_SEL_TGT_COMPOSE_DEFAULT
>> | V4L2_SEL_TGT_COMPOSE_PADDED
>>
>> Although not exactly the same, the meaning of V4L2_SEL_TGT_*_ACTIVE
>> and V4L2_SUBDEV_SEL_TGT_*_ACTUAL selection targets is logically the
>> same. Different names add to confusion where both APIs are used in
>> a single driver or an application.
>> Then, rename the V4l2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
>> V4l2_SEL_TGT_[CROP/COMPOSE]_ACTUAL to avoid the API inconsistencies.
>> The selections API is experimental, so no any compatibility layer
>> is added. The ABI remains unchanged.
> 
> I'm definitely for keeping the two sets of target as uniform as possible.
> 
> I have one question, though: how about dropping the ACTIVE / ACTUAL 
> altogether? Then we'd have V4L2_SUBDEV_SEL_TGT_CROP and 
> V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS etc. I feel that the ACTIVE or ACTUAL 
> doesn't really say anything there, and don't think it's an issue that a 
> target name is a part of another one.

Agreed. I really like the idea of dropping the rather meaningless
postfixes. I don't see an issue here with the subdev API, 'crop/compose' 
and 'crop/compose bounds' would mean exactly what it says. Only 
V4L2_SEL_TGT_COMPOSE_PADDED stands a bit out. I don't see any driver
really using it at the moment though and I recall Tomasz saying it wasn't 
best idea to add it in first place. So I believe V4L2_SEL_TGT_COMPOSE_PADDED
might get removed from the API in future.

I'm going to rework the patch, then let's see what's Tomasz's and others'
opinion.

--

Regards,
Sylwester
