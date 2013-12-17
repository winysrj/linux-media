Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.epfl.ch ([128.178.224.8]:48858 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3LQKmH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 05:42:07 -0500
Message-ID: <52B02A7A.4010901@epfl.ch>
Date: Tue, 17 Dec 2013 11:42:02 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: 3fdfedaaa7f243f3347084231c64f6c1be0ba131 causes a regression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

I was working on having a functional IOMMU/ISP for 3.14, and had an
issue with an image completely distorted. Comparing with another kernel,
I saw that PRV_HORZ_INFO and PRV_VERT_INFO differed. On the newer
kernel, sph, eph, svl, and slv were all off-by 2, causing my final image
to miss 4 pixels on each line, thus distorting the result.

Your commit 3fdfedaaa7f243f3347084231c64f6c1be0ba131 '[media] omap3isp:
preview: Lower the crop margins' indeed changes PRV_HORZ_INFO and
PRV_VERT_INFO by removing the if() condition. Reverting it made my image
to be valid again.

FYI, my pipeline is:

MT9V032 (SGRBG10 752x480) -> CCDC -> PREVIEW (UYVY 752x480) -> RESIZER
-> out

Regards,

Florian
