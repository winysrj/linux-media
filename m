Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45646 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaHTOcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 10:32:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: H3A module on omap4 iss
Date: Wed, 20 Aug 2014 16:32:51 +0200
Message-ID: <2048451.TcpJ3DtSY9@avalon>
In-Reply-To: <CAH9_wRM_CkRSRiaBDprvVONHXuZ2W6GLorqYTyA3G5N8G1Si6A@mail.gmail.com>
References: <CAH9_wRM_CkRSRiaBDprvVONHXuZ2W6GLorqYTyA3G5N8G1Si6A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sriram,

On Wednesday 20 August 2014 11:55:12 Sriram V wrote:
> Hi,
> 
> I am planning to work on getting the H3A support (Auto White balance,
> Auto Exposure and Auto Focus Support) for OMAP4 ISS.

That would be great !

> I wanted to check if anyone is working to get this module working.

Not to my knowledge. I'm not (at least for now, but I could need H3A support 
at some point in the future).

> Is OMAP3 H3A similar or same as OMAP4 H3A. Can i make use of the OMAP3 code
> base for h3a or how complex is this activity?

The AF and AE engines look pretty similar indeed. It would be nice if the 
OMAP3 ISP AF and AE code could be shared with the OMAP4 ISS driver. That would 
require some refactoring though. One thing we're missing is standardization of 
H3A APIs in V4L2, I'd like to see that happen.

> Also, i wanted to how how to test the v4l resizer driver in omap4iss?

Here's the full pipeline configuration I use. Please note that the OMAP4 ISS 
resizer implementation doesn't support resizing yet, it just hardcodes the 
resizer ratio to 1:1.

IFMT="SBGGR10"
ISIZE="1920x1084"
OFMT="UYVY"
OSIZE="1920x1080"
CFMT="YUYV1_5X8"

media-ctl -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS ISP IPIPEIF":0 [1]'
media-ctl -l '"OMAP4 ISS ISP IPIPEIF":2 -> "OMAP4 ISS ISP IPIPE":0 [1]'
media-ctl -l '"OMAP4 ISS ISP IPIPE":1 -> "OMAP4 ISS ISP resizer":0 [1]'
media-ctl -l '"OMAP4 ISS ISP resizer":1 -> "OMAP4 ISS ISP resizer a output":0 
[1]'

media-ctl -V "\"sensor\":0 [fmt:$IFMT/$ISIZE]"
media-ctl -V "\"OMAP4 ISS CSI2a\":1 [fmt:$IFMT/$ISIZE]"
media-ctl -V "\"OMAP4 ISS ISP IPIPEIF\":0 [fmt:$IFMT/$ISIZE]"
media-ctl -V "\"OMAP4 ISS ISP IPIPE\":0 [fmt:$IFMT/$ISIZE]"
media-ctl -V "\"OMAP4 ISS ISP IPIPE\":1 [fmt:$OFMT/$OSIZE]"
media-ctl -V "\"OMAP4 ISS ISP resizer\":0 [fmt:$OFMT/$OSIZE]"
media-ctl -V "\"OMAP4 ISS ISP resizer\":1 [fmt:$CFMT/$OSIZE]"

-- 
Regards,

Laurent Pinchart

