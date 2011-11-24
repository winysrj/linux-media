Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61149 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab1KXXxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:53:22 -0500
Received: by bke11 with SMTP id 11so3595813bke.19
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 15:53:21 -0800 (PST)
Message-ID: <4ECED8EC.8010807@gmail.com>
Date: Fri, 25 Nov 2011 00:53:16 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
Subject: Re: [Query] V4L2 Integer (?) menu control
References: <4ECD730E.3080808@gmail.com> <20111124085018.GF27136@valkosipuli.localdomain> <4ECE0FA5.1040205@samsung.com> <4ECEAFBE.1010303@iki.fi>
In-Reply-To: <4ECEAFBE.1010303@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 11/24/2011 09:57 PM, Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
>> On 11/24/2011 09:50 AM, Sakari Ailus wrote:
>>>
>>> There is not currently, but I have patches for it. The issue is that I need
>>> them myself but the driver I need them for isn't ready to be released yet.
>>> And as usual, I assume others than vivo is required to show they're really
>>> useful so I haven't sent them.
>>
>> That's great news. Then I might not need to do all the work on my own;)
> 
> I hope mine will do. ;-)
> 
> I'm working on 2.6.32 kernel (ouch!) so I haven't been able to test them properly
> yet. Please provide feedback on them if you find any issues.
> 
>>>
>>> Good that you asked so we won't end up writing essentially the same code
>>> again. I'll try to send the patches today.
>>
>> All right, there is no rush. I was just looking around how to support the
>> camera scene mode with m5mols sort of sensors. The scene mode is essentially
>> a compilation of several different parameters, for some of which there are
>> standard controls in V4L2 but for many there are not.
> 
> I fully agree with this approach. Scene modes should not be implemented at the
> level of the V4L2 API. Instead, the parameters that the scene modes consist of
> must be shown separately on the V4L2 API, if that is the level of API they belong
> to. Depending on your camera stack control algorithms could reside in the user 
> space, which I believe is however not the case with the M5-MOLS.

No, with these hybrid camera devices the algorithms are built in their own ISP.
And there is quite many advanced algorithms, e.g. auto focus/face detection that 
are difficult to control at the subdevice API level.

> 
>> I've got a feeling the best way to handle this would be to create controls
>> for each single parameter and then do a batch set from user space, and keep
>> the scene mode mappings in user space. The only concern is there is a couple
>> of ISP-specific parameters involved with that scene mode thing. Perhaps they
>> just could be set initially to fixed values.
> 
> Can you describe what kind of parameters this is about? Is there an issue in 
> just setting those using the ISP driver V4L2 subdev API?

Please see struct m5mols_scenemode in file m5mols.h

http://git.linuxtv.org/media_tree.git/blob/7e5219d18e93dd23e834a53b1ea73ead19cfeeb1:/drivers/media/video/m5mols/m5mols.h

for a brief overview. I have also been preparing a list of the parameters and their
exact meaning, but it's not ready yet.

The issue is that the subdev API seems to low level for the device but it's
the only API available at the user space ;) 

> 
> This makes your user space to depend both on the sensor and the ISP, but there's
> really no way around that if both do non-trivial hardware-specific things.

I guess a dedicated library for the sensor itself is needed on top of subdevice API
to be able to use advanced features. And even then subdevice/V4L2 API is a limitation.

> 
> I think we need to further standardise image processing configuration such as 
> RGB-to-RGB matrices and gamma tables. This would make the ISP interfaces less 
> hardware specific.

I guess first we need at least one more OMAP3 ISP like device driver in mainline 
to identify common features and design APIs for them. On the other hand gamma tables
are also present in some embedded ISPs, e.g. in s5k6aafx IIRC. 


-- 
Regards,
Sylwester
