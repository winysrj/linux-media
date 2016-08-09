Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:49042 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751020AbcHIKiG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2016 06:38:06 -0400
Message-ID: <1470739081.10352.100.camel@mtksdaap41>
Subject: Re: [PATCHv2] v4l2-common: add s_selection helper function
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 9 Aug 2016 18:38:01 +0800
In-Reply-To: <e5ed0f02-4305-c47c-b20c-c0022e162b05@xs4all.nl>
References: <c6379bf1-4fdf-7deb-4312-86d26d0ee106@xs4all.nl>
	 <20160804140313.GI3243@valkosipuli.retiisi.org.uk>
	 <aa119982-53c6-37bf-d019-b6ccd27b5c8a@xs4all.nl>
	 <20160804141734.GK3243@valkosipuli.retiisi.org.uk>
	 <b343ec5f-0c03-ae92-ef92-a051b23060ca@xs4all.nl>
	 <20160804143813.GL3243@valkosipuli.retiisi.org.uk>
	 <0ea23a54-3a72-665f-30f3-e02f7f6f41fb@xs4all.nl>
	 <20160804145925.GM3243@valkosipuli.retiisi.org.uk>
	 <e5ed0f02-4305-c47c-b20c-c0022e162b05@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 2016-08-05 at 15:57 +0200, Hans Verkuil wrote:
> Hi Tiffany,
> 
> We just had a long discussion about whether or not -ERANGE should be returned
> if the constraint flags could not be satisfied, and the end result was that
> the driver should not return an error in that case, but just select a rectangle
> that works with the hardware and is closest to the requested rectangle.
> 
> See the irc log for the discussion:
> 
> https://linuxtv.org/irc/irclogger_log/v4l?date=2016-08-05,Fri
> 
> This will simplify your code, and I'll drop this patch for a v4l2-common helper
> function, since that is no longer relevant.
> 
> I will try to find time to fix the documentation (since that's wrong) and any
> drivers that do return ERANGE.

Got it. I will refine and send a new patch.

best regards,
Tiffany

> Regards,
> 
> 	Hans


