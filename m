Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:48951 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab0FIKc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 06:32:59 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 9 Jun 2010 16:02:51 +0530
Subject: RE: [PATCH] OMAP: V4L2: Enable V4L2 on ZOOM2/3 & 3630SDP
Message-ID: <19F8576C6E063C45BE387C64729E7394044E7A1E42@dbde02.ent.ti.com>
References: <FF55437E1F14DA4BAEB721A458B6701706BD8CCD05@dbde02.ent.ti.com>
 <201006091227.29175.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201006091227.29175.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, June 09, 2010 3:57 PM
> To: Nagarajan, Rajkumar
> Cc: linux-media@vger.kernel.org
> Subject: Re: [PATCH] OMAP: V4L2: Enable V4L2 on ZOOM2/3 & 3630SDP
> 
> Hi Rajkumar,
> 
> On Wednesday 09 June 2010 11:51:45 Nagarajan, Rajkumar wrote:
> > Defconfig changes to enable V4L2 on zoom2, zoom3 and 3630sdp boards.
> 
> Defconfigs on ARM are going away. See the http://lkml.org/lkml/2010/6/2/472
> thread on LKML. There's also a lengthy discussion about that on LAKML. Linus
> will not accept any change to the defconfig files anymore and currently
> plans
> to remove them completely for 2.6.36.
> 
[Hiremath, Vaibhav] That's correct, and also FYI, you must cc linux-omap mailing list for the patches which touch any files under arch/arm/*

Thanks,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
