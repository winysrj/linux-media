Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42042 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759763AbcHEN5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 09:57:39 -0400
Subject: Re: [PATCHv2] v4l2-common: add s_selection helper function
To: Tiffany Lin <tiffany.lin@mediatek.com>
References: <c6379bf1-4fdf-7deb-4312-86d26d0ee106@xs4all.nl>
 <20160804140313.GI3243@valkosipuli.retiisi.org.uk>
 <aa119982-53c6-37bf-d019-b6ccd27b5c8a@xs4all.nl>
 <20160804141734.GK3243@valkosipuli.retiisi.org.uk>
 <b343ec5f-0c03-ae92-ef92-a051b23060ca@xs4all.nl>
 <20160804143813.GL3243@valkosipuli.retiisi.org.uk>
 <0ea23a54-3a72-665f-30f3-e02f7f6f41fb@xs4all.nl>
 <20160804145925.GM3243@valkosipuli.retiisi.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e5ed0f02-4305-c47c-b20c-c0022e162b05@xs4all.nl>
Date: Fri, 5 Aug 2016 15:57:30 +0200
MIME-Version: 1.0
In-Reply-To: <20160804145925.GM3243@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

We just had a long discussion about whether or not -ERANGE should be returned
if the constraint flags could not be satisfied, and the end result was that
the driver should not return an error in that case, but just select a rectangle
that works with the hardware and is closest to the requested rectangle.

See the irc log for the discussion:

https://linuxtv.org/irc/irclogger_log/v4l?date=2016-08-05,Fri

This will simplify your code, and I'll drop this patch for a v4l2-common helper
function, since that is no longer relevant.

I will try to find time to fix the documentation (since that's wrong) and any
drivers that do return ERANGE.

Regards,

	Hans
