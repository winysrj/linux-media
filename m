Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:59198 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754129AbdDRRcE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 13:32:04 -0400
Date: Tue, 18 Apr 2017 18:31:56 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/6] Introduce writeback connectors
Message-ID: <20170418173156.GA30544@e106950-lin.cambridge.arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
 <20170414113517.323ab297@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170414113517.323ab297@bbrezillon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Boris,

On Fri, Apr 14, 2017 at 11:35:17AM +0200, Boris Brezillon wrote:
>Hi Brian,
>
>On Fri, 25 Nov 2016 16:48:58 +0000
>Brian Starkey <brian.starkey@arm.com> wrote:
>
>> Hi,
>>
>> This is v3 of my series introducing a new connector type:
>>  DRM_MODE_CONNECTOR_WRITEBACK
>> See v1 and v2 here: [1] [2]
>>
>> Writeback connectors are used to expose the memory writeback engines
>> found in some display controllers, which can write a CRTC's
>> composition result to a memory buffer.
>> This is useful e.g. for testing, screen-recording, screenshots,
>> wireless display, display cloning, memory-to-memory composition.
>>
>> Writeback connectors are given a WRITEBACK_FB_ID property (which acts
>> slightly differently to FB_ID, so gets a new name), as well as
>> a PIXEL_FORMATS blob to list the supported writeback formats, and
>> OUT_FENCE_PTR to be used for out-fences.
>>
>> The changes since v2 are in the commit messages of each commit.
>>
>> The main differences are:
>>  - Subclass drm_connector as drm_writeback_connector
>>  - Slight relaxation of core checks, to allow
>>    (connector->crtc && !connector->fb)
>>  - Dropped PIXEL_FORMATS_SIZE, which was redundant
>>  - Reworked the event interface, drivers don't need to deal with the
>>    fence directly
>>  - Re-ordered the commits to introduce writeback out-fences up-front.
>>
>> I've kept RFC on this series because the event reporting (introduction
>> of drm_writeback_job) is probably up for debate.
>>
>> v4 will be accompanied by igt tests.
>
>I plan to add writeback support to the VC4 driver and wanted to know if
>anything has changed since this v3 (IOW, do you have a v4 + igt tests
>ready)?
>

Oh that's good to hear. I've got a v4 (just rebased for the most
part), but was holding off sending it until having some "proper"
userspace to support it. Unfortunately in the meantime we've had some
team changes which mean I'm not really able to work on it to move
things forward - Liviu might be able to pick this up.

I'll collect together what I have and send it out anyway. It includes
some functional tests in igt, but I'm not sure if that meets the "new
uapi needs userspace" bar.

>>
>> As always, I look forward to any comments.
>
>I'll try to review these patches. Keep in mind that I didn't follow the
>initial discussions and might suggest things or ask questions that have
>already been answered in previous versions of this series or on IRC.

Thanks,

-Brian

>
>Regards,
>
>Boris
