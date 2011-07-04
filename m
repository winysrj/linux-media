Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1GDX2W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2011 19:28:22 -0400
Message-ID: <4E124C8A.7020801@redhat.com>
Date: Mon, 04 Jul 2011 20:28:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l:
 add macro for 1080p59_54 preset
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <1309351877-32444-2-git-send-email-t.stanislaws@samsung.com> <4E11E5AE.30304@redhat.com> <201107050047.44275.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107050047.44275.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-07-2011 19:47, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Monday 04 July 2011 18:09:18 Mauro Carvalho Chehab wrote:
> 
> [snip]
> 
>> 1) PRESET STANDARDS
>>    ====== =========
>>
>> There are 3 specs involved with DV presets: ITU-R BT 709 and BT 1120 and
>> CEA 861.
>>
>> At ITU-R BT.709, both 60Hz and 60/1.001 Hz are equally called as "60 Hz".
>> BT.1120 follows the same logic, as it uses BT.709 as a reference for video
>> timings.
>>
>> The CEA-861-E spec says at item 4, that:
> 
> [snip]
> 
>> At the same item, the table 2 describes several video parameters for each
>> preset, associating the Video Identification Codes (VIC) for each preset.
> 
> This might be a bit out of scope, but why aren't we using the VICs as DV 
> presets ?

I had the same question after analyzing the specs ;)

That's said, abstracting from the spec could be a good idea if we have newer
versions of the spec re-defining the VICs.

Maybe the right thing to do would be to rename the presets as:

V4L2_DV_CEA861_VIC_16
V4L2_DV_CEA861_VIC_35_36
...

(or course, preserving the old names with compatibility macros)

Cheers,
Mauro

