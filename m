Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46317 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388241AbeGXN3U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 09:29:20 -0400
Date: Tue, 24 Jul 2018 14:23:02 +0200
From: Simon Horman <horms@verge.net.au>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo@jmondi.org>, magnus.damm@gmail.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: defconfig: Remove SOC_CAMERA
Message-ID: <20180724122302.7zry3qiizevmchjt@verge.net.au>
References: <1531920672-31153-1-git-send-email-jacopo@jmondi.org>
 <20180719074405.znqjtno2l2a6exti@verge.net.au>
 <54e7045b-c3b2-b625-22ab-3677d69ed93d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e7045b-c3b2-b625-22ab-3677d69ed93d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 19, 2018 at 09:44:57AM +0200, Hans Verkuil wrote:
> On 07/19/2018 09:44 AM, Simon Horman wrote:
> > On Wed, Jul 18, 2018 at 03:31:12PM +0200, Jacopo Mondi wrote:
> >> As the soc_camera framework is going to be deprecated soon, remove the
> >> associated configuration options from shmobile defconfig.
> >>
> >> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
> >> ---
> >> Hi Simon,
> >>    I expect Hans to collect this patch as he did for SH defconfig ones.
> >> Please let us know if that's not ok with you.
> > 
> > I'd slightly prefer if shmobile_defconfig changes went through me.
> > My motivation is to reduce the chances of merge conflicts.
> 
> Feel free to take it!
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks, applied for v4.20.
