Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1809 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3GHHXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jul 2013 03:23:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFC PATCH 0/5] Matrix and Motion Detection support
Date: Mon, 8 Jul 2013 09:22:34 +0200
Cc: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pete Eberlein <pete@sensoray.com>
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl> <51D9E2A6.2070002@gmail.com>
In-Reply-To: <51D9E2A6.2070002@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307080922.34481.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun July 7 2013 23:50:30 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 06/28/2013 02:27 PM, Hans Verkuil wrote:
> > This patch series adds support for matrices and motion detection and
> > converts the solo6x10 driver to use these new APIs.
> >
> > See the RFCv2 for details on the motion detection API:
> >
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html
> >
> > And this RFC for details on the matrix API (which superseeds the v4l2_md_blocks
> > in the RFC above):
> >
> > http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/65195
> >
> > I have tested this with the solo card, both global motion detection and
> > regional motion detection, and it works well.
> >
> > There is no documentation for the new APIs yet (other than the RFCs). I would
> > like to know what others think of this proposal before I start work on the
> > DocBook documentation.
> 
> These 3 ioctls look pretty generic and will likely allow us to handle wide
> range of functionalities, similarly to what the controls framework does 
> today.
> 
> What I don't like in the current trend of the V4L2 API development 
> though is
> that we have seemingly separate APIs for configuring integers, rectangles,
> matrices, etc. And interactions between those APIs sometimes happen to be
> not well defined.
> 
> I'm not opposed to having this matrix API, but I would _much_ more like to
> see it as a starting point of a more powerful API, that would allow to 
> model
> dependencies between parameters being configured and the objects more
> explicitly and freely (e.g. case of the per buffer controls), that would
> allow to pass a list of commands to the hardware for atomic 
> re-configurations,
> that would allow to create hardware configuration contexts, etc., etc.
> 
> But it's all song of future, requires lots of effort, founding and takes
> engineers with significant experience.
> 
> As it likely won't happen soon I guess we can proceed with the matrix API
> for now.

Do you attend the LPC in New Orleans? I would like to discuss this further,
but it is easier to do so face-to-face with a whiteboard. Alternatively, we
could set up a brainstorm session somewhere. This discussion keeps cropping
up time and again, perhaps we should start to do something about it :-)

Regards,

	Hans
