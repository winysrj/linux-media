Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2594 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1CUSDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 14:03:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
Date: Mon, 21 Mar 2011 19:03:38 +0100
Cc: Li Li <eggonlea@gmail.com>, Alex Deucher <alexdeucher@gmail.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	Jonghun Han <jonghun.han@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linaro-dev@lists.linaro.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <201103080913.59231.hverkuil@xs4all.nl> <AANLkTi=+2-K9-nt_Sahhrr4K9yg1bzotVexq_YnUTJYi@mail.gmail.com> <AANLkTi=tqMHNQs=-R2rUpD_RZvGJSPUFY8uS6Rz1jCEM@mail.gmail.com>
In-Reply-To: <AANLkTi=tqMHNQs=-R2rUpD_RZvGJSPUFY8uS6Rz1jCEM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103211903.38494.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, March 16, 2011 09:14:54 Kyungmin Park wrote:
> Rough schedules.
> 
> 1. Warsaw meetings (3/16~3/18): mostly v4l2 person and some SoC vendors
>   Make a consensence at media developers. and share the information.
>   Please note that it's v4l2 brainstorming meeting. so memory
> management is not the main issue.

I have asked all participants to the meeting to try and assemble requirements
for their hardware in the next week.

> 2. ELC (4/11~4/13): DRM, DRI and v4l2 person.
>   Discuss GEM/TTM is acceptable for non-X86 system and find out the
> which modules are acceptable.
>   We studied the GEM for our environment. but it's too huge and not
> much benefit for us since current frameworks are enough.
>   The missing is that no generic memory passing mechanism. We need the
> generic memory passing interface. that's all.

Who will be there? Is there a BoF or something similar organized?

> 3. Linaro (5/9~5/13): ARM, SoC vendors and v4l2 persons.
>   I hope several person are anticipated and made a small step for final goal.

I should be able to join, at least for the part related to buffer pools and
related topics.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
