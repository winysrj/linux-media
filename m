Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.epfl.ch ([128.178.224.219]:42176 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab3LWVru (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 16:47:50 -0500
Message-ID: <52B8AF81.3040804@epfl.ch>
Date: Mon, 23 Dec 2013 22:47:45 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Regression inside omap3isp/resizer (was: 3fdfeda causes a regression)
References: <52B02A7A.4010901@epfl.ch>
In-Reply-To: <52B02A7A.4010901@epfl.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 12/17/2013 11:42 AM, Florian Vaussard wrote:
> Hello Laurent,
> 
> I was working on having a functional IOMMU/ISP for 3.14, and had an
> issue with an image completely distorted. Comparing with another kernel,
> I saw that PRV_HORZ_INFO and PRV_VERT_INFO differed. On the newer
> kernel, sph, eph, svl, and slv were all off-by 2, causing my final image
> to miss 4 pixels on each line, thus distorting the result.
> 
> Your commit 3fdfedaaa7f243f3347084231c64f6c1be0ba131 '[media] omap3isp:
> preview: Lower the crop margins' indeed changes PRV_HORZ_INFO and
> PRV_VERT_INFO by removing the if() condition. Reverting it made my image
> to be valid again.
> 
> FYI, my pipeline is:
> 
> MT9V032 (SGRBG10 752x480) -> CCDC -> PREVIEW (UYVY 752x480) -> RESIZER
> -> out
> 

Just an XMAS ping on this :-) Do you have any idea how to solve this
without reverting the patch?

(I changed the topic to make it more clear)

Regards,

Florian
