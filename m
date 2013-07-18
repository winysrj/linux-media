Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36456 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab3GRAMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 20:12:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Pete Eberlein <pete@sensoray.com>
Subject: Re: [RFC PATCH 0/5] Matrix and Motion Detection support
Date: Thu, 18 Jul 2013 02:12:49 +0200
Message-ID: <2376197.fRlMlWruRn@avalon>
In-Reply-To: <51D9E2A6.2070002@gmail.com>
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl> <51D9E2A6.2070002@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sunday 07 July 2013 23:50:30 Sylwester Nawrocki wrote:
> On 06/28/2013 02:27 PM, Hans Verkuil wrote:
> > This patch series adds support for matrices and motion detection and
> > converts the solo6x10 driver to use these new APIs.
> > 
> > See the RFCv2 for details on the motion detection API:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html
> > 
> > And this RFC for details on the matrix API (which superseeds the
> > v4l2_md_blocks in the RFC above):
> > 
> > http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/
> > 65195
> > 
> > I have tested this with the solo card, both global motion detection and
> > regional motion detection, and it works well.
> > 
> > There is no documentation for the new APIs yet (other than the RFCs). I
> > would like to know what others think of this proposal before I start work
> > on the DocBook documentation.
> 
> These 3 ioctls look pretty generic and will likely allow us to handle wide
> range of functionalities, similarly to what the controls framework does
> today.
> 
> What I don't like in the current trend of the V4L2 API development
> though is that we have seemingly separate APIs for configuring integers,
> rectangles, matrices, etc. And interactions between those APIs sometimes
> happen to be not well defined.
> 
> I'm not opposed to having this matrix API, but I would _much_ more like to
> see it as a starting point of a more powerful API, that would allow to
> model dependencies between parameters being configured and the objects more
> explicitly and freely (e.g. case of the per buffer controls), that would
> allow to pass a list of commands to the hardware for atomic re-
> configurations, that would allow to create hardware configuration contexts,
> etc., etc.
> 
> But it's all song of future, requires lots of effort, founding and takes
> engineers with significant experience.
> 
> As it likely won't happen soon I guess we can proceed with the matrix API
> for now.

Just for the record, I second that point of view. A matrix API, even as an 
interim solution for the problems at hand, would be welcome. I would use it to 
configure various kinds of LUTs (such as gamma tables). I'm all for going to a 
property-based model (or at least seriously brainstorming it), but we're 
looking at a too long time frame.

> > My tentative goal is to get this in for 3.12. Once this is in place the
> > solo and go7007 drivers can be moved out of staging into the mainline
> > since this is the only thing holding them back.

-- 
Regards,

Laurent Pinchart

