Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49844 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753936AbcLOWd3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:33:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: omap3isp change to devm for resources
Date: Fri, 16 Dec 2016 00:33:11 +0200
Message-ID: <2731467.skKvVxvkgN@avalon>
In-Reply-To: <98a3d1794bc001f312a7db31ad03465ba697bb36.1481829722.git.shuahkh@osg.samsung.com>
References: <cover.1481829721.git.shuahkh@osg.samsung.com> <98a3d1794bc001f312a7db31ad03465ba697bb36.1481829722.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Thank you for the patch.

Sakari has submitted a similar patch as part of his kref series. Please use it 
as a base point and rework it if you want to get it merged separately. I've 
reviewed the patch and left quite a few comments that need to be addressed.

On Thursday 15 Dec 2016 12:40:08 Shuah Khan wrote:
> Using devm resources that have external dependencies such as a dev
> for a file handler could result in devm resources getting released
> durin unbind while an application has the file open holding pointer
> to the devm resource. This results in use-after-free errors when the
> application exits.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/omap3isp/isp.c         | 71 ++++++++++++++++--------
>  drivers/media/platform/omap3isp/ispccp2.c     | 10 +++-
>  drivers/media/platform/omap3isp/isph3a_aewb.c | 21 +++++---
>  drivers/media/platform/omap3isp/isph3a_af.c   | 21 +++++---
>  drivers/media/platform/omap3isp/isphist.c     |  5 +-
>  5 files changed, 92 insertions(+), 36 deletions(-)

-- 
Regards,

Laurent Pinchart

