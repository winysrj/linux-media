Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32977 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZBFPE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 10:04:28 -0500
Message-ID: <498C513E.6080501@maxwell.research.nokia.com>
Date: Fri, 06 Feb 2009 17:03:26 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor driver
 v2
References: <19F8576C6E063C45BE387C64729E739403FA81B0D0@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403FA81B0D0@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hiremath, Vaibhav wrote:
> [Hiremath, Vaibhav] Sakari, Can you share your version of code
> (either in form of patches or source) here onto the mailing list, so
> that everybody those who are interested will be aware of changes?

I will synchronise soon with Sergio (as he noted). After that we'll send 
a new patchset. I was thinking of separating the ISP and camera driver 
patches from other hardware dependent patches. The resulting patchset 
wouldn't be that huge anymore but on the other hand it wouldn't be very 
usable as such.

> Atleast for me I would get prior view of changes which might affect
> BT656 support (posted on top of Sergio's patch).
> 
> Again one more thing I would like to bring to your notice is about
> sub-device framework. Also we need to plan for the migration from
> V4L2-int to sub-device framework, which is of equal important. I feel
> the more time we spend in merging and aligning offline, more we are
> carrying risk.

I agree that we should be moving to v4l2 sub-device at some point, 
preferrably sooner than later, but I think the ISP driver should get a 
much much better interface than it currently has. So that should be part 
of the task.

> According to me as I mentioned before, the plan should be to push
> ISP-Camera with V4L2-int interface as early as possible with whatever
> minimal sensor/decoder support we have today, which will make sure
> that our underneath ISP-library is in place. Once that is placed in,
> we can have additional patches on top of it to add more features.

I agree. But I'd say that fixing the bugs and cleaning up the code is as 
least as important than adding new features.

> In this way, we can plan for migration to sub-device framework and
> also be easier and simpler. Even if any customers are interested,
> they can pick it up the ISP library and start development on top of
> it.

There's still a long way to get there --- the ISP driver's current 
interface and internals don't mix well with either v4l2 sub-device or 
v4l2-int-if. For example, there's no ISP object, just function calls and 
then output frame size / frame interval enumeration doesn't work 
properly for YUV (maybe not even for RAW10). Enumerating frame size has 
side effects. The ISP driver doesn't have a standard interface, it's now 
specific to OMAP 3. And this is just an example...

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
