Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34784 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1GNJaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 05:30:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [RFC v1] mt9v113: VGA camera sensor driver and support for BeagleBoard
Date: Thu, 14 Jul 2011 11:30:11 +0200
Cc: Joel A Fernandes <agnel.joel@gmail.com>,
	"beagleboard@googlegroups.com" <beagleboard@googlegroups.com>,
	"Kridner, Jason" <jdk@ti.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Kooi, Koen" <k-kooi@ti.com>, "Prakash, Punya" <pprakash@ti.com>,
	"Maupin, Chase" <chase.maupin@ti.com>,
	"Kipisz, Steven" <s-kipisz2@ti.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>
References: <1310581347-31102-1-git-send-email-agnel.joel@gmail.com> <201107140020.19432.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404E35E43E9@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E35E43E9@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107141130.11764.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

On Thursday 14 July 2011 10:05:41 Hiremath, Vaibhav wrote:
> On Thursday, July 14, 2011 3:50 AM Laurent Pinchart wrote:
> > On Wednesday 13 July 2011 20:22:27 Joel A Fernandes wrote:
> > > * Adds support for mt9v113 sensor by borrowing heavily from PSP 2.6.37
> > > kernel patches * Adapted to changes in v4l2 framework and ISP driver
> > 
> > Here are a few comments about the code. I've left political issues aside
> > on purpose.
> 
> As always thanks for your comments.
> 
> Laurent,
> But here the question is nowhere related to politics. I do not care about
> authorship at all; this is completely engineering argument/discussion I have
> with this patch.
> 
> I have been working with community since long time now, so I was not in
> favor of submitting this patch with so many known issues (from both feature
> and cleanliness). If you look at all the comments you provided, most of them
> should have been already part of the patch series.

I totally agree with you on this. That's why I haven't done any in-depth 
review of the patch, but just quickly looked through it.

> I wanted them to fix before submitting it to the linux-media, it doesn't
> matter whether it's RFC.
> 
> Another point FYI, the sensor driver has been written during 2.6.37
> timeframe, where media-controller was still under flux. Since I wanted to
> make our production release with MC framework, I pulled in patches from your
> private branch and started developing from there, so definitely there will
> be various issues with the driver Vs the current mainline status.
> 
> 
> If I would have been aware that, somebody is willing to push my patches, I
> could have helped him or worked with him (that will ease my bandwidth).
> 
> I just made my stand clear here, and I think we should park this discussion
> here now. We talked enough on this, and I believe we all understand this.

-- 
Regards,

Laurent Pinchart
