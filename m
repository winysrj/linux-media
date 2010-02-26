Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37832 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934688Ab0BZAe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 19:34:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Maupin, Chase" <chase.maupin@ti.com>
Subject: Re: Requested feedback on V4L2 driver design
Date: Fri, 26 Feb 2010 01:35:20 +0100
Cc: Hans Verkuil <hans.verkuil@tandberg.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"vpss_driver_design@list.ti.com - This list is to discuss the VPSS
	driver design (May contain non-TIers)"
	<vpss_driver_design@list.ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com> <201002120222.38816.laurent.pinchart@ideasonboard.com> <131E5DFBE7373E4C8D813795A6AA7F0802E7F9CB88@dlee06.ent.ti.com>
In-Reply-To: <131E5DFBE7373E4C8D813795A6AA7F0802E7F9CB88@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002260135.23333.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chase,

On Tuesday 16 February 2010 14:00:11 Maupin, Chase wrote:
> Laurent,
> 
> To follow up with some of the comments I made before I got additional
> clarification about the commands supported by the proxy driver running on
> the VPSS MCU.  The proxy will support all of the commands used by V4L2 as
> well as those proposed extensions to V4L2 that Hans has mentioned. 
> Basically, the list of commands supported at initial release is not only
> those required today, but a full set for all the features of the VPSS.  In
> this was as new APIs are added to V4L2 the support for those features will
> already be supported by the VPSS MCU proxy driver.

Thank you for the clarification.

A few things are still uncleared to me, as stated in my previous mail (from a 
few minutes ago). My main question is, if the VPSS API is full-featured and 
accessible from the master CPU, why do we need a proxy driver in the firmware 
at all ?

> As for the license of the firmware this is still being worked.  It is
> currently under TI proprietary license and will be distributed as binary
> under Technical Software Publicly Available (TSPA) which means it can be
> obtained by anyone.  If you feel that source code is required for the
> firmware at launch to gain acceptance please let us know and we can start
> working that issue.

I think it would definitely help keeping the Linux driver and the VPSS 
firmware in sync if the VPSS firmware source was available. The firmware 
source code could even be distributed along with the Linux driver.

By the way, will the firmware be loaded at runtime by the driver, or will it 
be stored internally in the chip ?

-- 
Regards,

Laurent Pinchart
