Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46438 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaEZJ2w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 05:28:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] m5mols: Replace missing header
Date: Mon, 26 May 2014 11:29:08 +0200
Message-ID: <1704388.1gDR1zZHE6@avalon>
In-Reply-To: <5383038C.2060909@samsung.com>
References: <1401047695-2046-1-git-send-email-laurent.pinchart@ideasonboard.com> <5383038C.2060909@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Monday 26 May 2014 11:04:12 Sylwester Nawrocki wrote:
> On 25/05/14 21:54, Laurent Pinchart wrote:
> > The include/media/s5p_fimc.h header has been removed in commit
> > 49b2f4c56fbf70ca693d6df1c491f0566d516aea ("exynos4-is: Remove support
> > for non-dt platforms"). This broke compilation of the m5mols driver.
> > 
> > Include the include/media/exynos-fimc.h header instead, which contains
> > the S5P_FIMC_TX_END_NOTIFY definition required by the driver.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Thanks for the fix.

You're welcome. I just happened to run across the problem while compiling my 
tree, it didn't take long to fix it :-)

> I though about adding to this patch:
> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> But it seems the patch is already in Mauro's tree.

-- 
Regards,

Laurent Pinchart

