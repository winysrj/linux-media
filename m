Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:59218 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbcLMMjr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 07:39:47 -0500
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
To: Nicholas Mc Guire <hofrat@osadl.org>
References: <CGME20161213015743epcas3p19867fa74e5ffe2974364d317d9b494f6@epcas3p1.samsung.com>
 <1481594282-12801-1-git-send-email-hofrat@osadl.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <ae02dfc1-39b9-f7f7-5168-d00e4ad75db7@samsung.com>
Date: Tue, 13 Dec 2016 13:38:52 +0100
MIME-version: 1.0
In-reply-to: <1481594282-12801-1-git-send-email-hofrat@osadl.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2016 02:58 AM, Nicholas Mc Guire wrote:
> As this is not in atomic context and it does not seem like a critical 
> timing setting a range of 1ms allows the timer subsystem to optimize 
> the hrtimer here.
> 
> Fixes: commit bfa8dd3a0524 ("[media] v4l: Add v4l2 subdev driver for S5K6AAFX sensor")
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

I'm not sure the "Fixes" tag is needed here.

> Patch is against 4.9.0 (localversion-next is next-20161212)

Ideally patches for the media subsystem should be normally based on
master branch of the media tree (git://linuxtv.org/media_tree.git).

-- 
Thanks,
Sylwester
