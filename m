Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45081 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LaIv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Dec 2013 03:51:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: florian.vaussard@epfl.ch
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Regression inside omap3isp/resizer (was: 3fdfeda causes a regression)
Date: Tue, 31 Dec 2013 09:51:57 +0100
Message-ID: <5578156.0MrbcJaUWJ@avalon>
In-Reply-To: <52B8AF81.3040804@epfl.ch>
References: <52B02A7A.4010901@epfl.ch> <52B8AF81.3040804@epfl.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

Sorry for the late reply.

On Monday 23 December 2013 22:47:45 Florian Vaussard wrote:
> On 12/17/2013 11:42 AM, Florian Vaussard wrote:
> > Hello Laurent,
> > 
> > I was working on having a functional IOMMU/ISP for 3.14, and had an
> > issue with an image completely distorted. Comparing with another kernel,
> > I saw that PRV_HORZ_INFO and PRV_VERT_INFO differed. On the newer
> > kernel, sph, eph, svl, and slv were all off-by 2, causing my final image
> > to miss 4 pixels on each line, thus distorting the result.
> > 
> > Your commit 3fdfedaaa7f243f3347084231c64f6c1be0ba131 '[media] omap3isp:
> > preview: Lower the crop margins' indeed changes PRV_HORZ_INFO and
> > PRV_VERT_INFO by removing the if() condition. Reverting it made my image
> > to be valid again.
> > 
> > FYI, my pipeline is:
> > 
> > MT9V032 (SGRBG10 752x480) -> CCDC -> PREVIEW (UYVY 752x480) -> RESIZER
> > -> out
> 
> Just an XMAS ping on this :-) Do you have any idea how to solve this
> without reverting the patch?

The patch indeed changed the preview engine margins, but the change is 
supposed to be handled by applications. As a base for this discussion could 
you please provide the media-ctl -p output before and after applying the patch 
? You can strip the unrelated media entities out of the output.

-- 
Regards,

Laurent Pinchart

