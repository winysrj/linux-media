Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48187 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1KXU5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 15:57:38 -0500
Message-ID: <4ECEAFBE.1010303@iki.fi>
Date: Thu, 24 Nov 2011 22:57:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmon?= =?ISO-8859-1?Q?t?=
	<remi@remlab.net>
Subject: Re: [Query] V4L2 Integer (?) menu control
References: <4ECD730E.3080808@gmail.com> <20111124085018.GF27136@valkosipuli.localdomain> <4ECE0FA5.1040205@samsung.com>
In-Reply-To: <4ECE0FA5.1040205@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> Thank you all for the comments.
>
> On 11/24/2011 09:50 AM, Sakari Ailus wrote:
>> Hi Sylwester,
>>
>> There is not currently, but I have patches for it. The issue is that I need
>> them myself but the driver I need them for isn't ready to be released yet.
>> And as usual, I assume others than vivo is required to show they're really
>> useful so I haven't sent them.
>
> That's great news. Then I might not need to do all the work on my own;)

I hope mine will do. ;-)

I'm working on 2.6.32 kernel (ouch!) so I haven't been able to test them 
properly yet. Please provide feedback on them if you find any issues.

>>
>> Good that you asked so we won't end up writing essentially the same code
>> again. I'll try to send the patches today.
>
> All right, there is no rush. I was just looking around how to support the
> camera scene mode with m5mols sort of sensors. The scene mode is essentially
> a compilation of several different parameters, for some of which there are
> standard controls in V4L2 but for many there are not.

I fully agree with this approach. Scene modes should not be implemented 
at the level of the V4L2 API. Instead, the parameters that the scene 
modes consist of must be shown separately on the V4L2 API, if that is 
the level of API they belong to. Depending on your camera stack control 
algorithms could reside in the user space, which I believe is however 
not the case with the M5-MOLS.

> I've got a feeling the best way to handle this would be to create controls
> for each single parameter and then do a batch set from user space, and keep
> the scene mode mappings in user space. The only concern is there is a couple
> of ISP-specific parameters involved with that scene mode thing. Perhaps they
> just could be set initially to fixed values.

Can you describe what kind of parameters this is about? Is there an 
issue in just setting those using the ISP driver V4L2 subdev API?

This makes your user space to depend both on the sensor and the ISP, but 
there's really no way around that if both do non-trivial 
hardware-specific things.

I think we need to further standardise image processing configuration 
such as RGB-to-RGB matrices and gamma tables. This would make the ISP 
interfaces less hardware specific.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
