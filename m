Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:59272 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757488AbdDRRfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 13:35:15 -0400
Date: Tue, 18 Apr 2017 18:35:07 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] drm: writeback: Add out-fences for writeback
 connectors
Message-ID: <20170418173507.GB325@e106950-lin.cambridge.arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
 <1480092544-1725-3-git-send-email-brian.starkey@arm.com>
 <20170414121114.6e6eee7a@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170414121114.6e6eee7a@bbrezillon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 14, 2017 at 12:11:14PM +0200, Boris Brezillon wrote:
>On Fri, 25 Nov 2016 16:49:00 +0000
>Brian Starkey <brian.starkey@arm.com> wrote:
>
>> Add the OUT_FENCE_PTR property to writeback connectors, to enable
>> userspace to get a fence which will signal once the writeback is
>> complete. It is not allowed to request an out-fence without a
>> framebuffer attached to the connector.
>>
>> A timeline is added to drm_writeback_connector for use by the writeback
>> out-fences.
>>
>> In the case of a commit failure or DRM_MODE_ATOMIC_TEST_ONLY, the fence
>> is set to -1.
>>
>> Changes from v2:
>>  - Rebase onto Gustavo Padovan's v9 explicit sync series
>>  - Change out_fence_ptr type to s32 __user *
>
>Don't know what happened, but I still see s32 __user * types in this
>patch (I had to patch it to make in work on top of 4.11-rc1).

Yeah this really confused me too when rebasing. Given that this patch
predates Gustavo's change to s32 I can only assume I typo'd and meant
s64 in this commit message.

-Brian
