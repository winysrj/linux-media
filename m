Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35650 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab2E2VD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 17:03:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH] omap3isp : fix cfa demosaicing for format other than GRBG
Date: Tue, 29 May 2012 23:04:12 +0200
Message-ID: <2212863.1QHZfSWdDi@avalon>
In-Reply-To: <CAGGh5h3jNpbPty6Qzrz9XhmBJci2GcHZhaF8w3dmG_Ce9dpSRQ@mail.gmail.com>
References: <CAGGh5h3jNpbPty6Qzrz9XhmBJci2GcHZhaF8w3dmG_Ce9dpSRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

On Tuesday 29 May 2012 10:24:45 jean-philippe francois wrote:
> Hi,
> 
> omap3 ISP previewer block can convert a raw bayer image into a UYVY image.
> Debayering coefficient are stored in an undocumented table. In the current
> form, only GRBG format are converted correctly.
> 
> However, the other CFA arrangement can be transformed in GRBG arrangement by
> shifting the image window one pixel to the left or to the bottom.
> 
> Here is a patch against vanilla 3.2.17, that was only tested with a BGGR
> arrangement.
> Is it the right way to fix this issue ?

That's really a hack. I'd much rather support other Bayer orders properly by 
modifying the CFA coefficients table.

The table is arranged as 4 blocks of 144 coefficients. If I'm not mistaken (I 
haven't tested it), the blocks should be arranged as follows:

GRBG 0 1 2 3
RGGB 1 0 3 2
BGGR 2 3 0 1
GBRG 3 2 1 0

Would you be able to test that with your BGGR sensor ?

If that's correct, it shouldn't be too difficult to modify the order 
dynamically based on the format.

-- 
Regards,

Laurent Pinchart
