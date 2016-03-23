Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38584 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbcCWJP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 05:15:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Rafael =?ISO-8859-1?Q?Louren=E7o?= de Lima Chehab
	<chehabrafael@gmail.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] [media] media-device: use kref for media_device instance
Date: Wed, 23 Mar 2016 11:15:57 +0200
Message-ID: <4350208.vzA33hqtSr@avalon>
In-Reply-To: <56EFFA4A.6040002@osg.samsung.com>
References: <9d8830150475bc4d4dde2fa1f5163aef82a35477.1458347578.git.mchehab@osg.samsung.com> <3052381.o5ho2okSRi@avalon> <56EFFA4A.6040002@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Monday 21 Mar 2016 07:42:34 Shuah Khan wrote:
> On 03/21/2016 05:10 AM, Laurent Pinchart wrote:
> > On Friday 18 Mar 2016 21:42:16 Mauro Carvalho Chehab wrote:
> >> Now that the media_device can be used by multiple drivers,
> >> via devres, we need to be sure that it will be dropped only
> >> when all drivers stop using it.
> > 
> > I've discussed this with Shuah previously and I'm surprised to see that
> > the problem hasn't been fixed : using devres for this purpose is just
> > plain wrong. The empty media_device_release_devres() function should have
> > given you a hint.
> > 
> > What we need instead is a list of media devices indexed by struct device
> > (for this use case) or by struct device_node (for DT use cases). It will
> > both simplify the code and get rid of the devres abuse.
> > 
> > Shuah, if I recall correctly you worked on implementing such a solution
> > after our last discussion on the topic. Could you please update us on the
> > status ?
> It is work in progress. I have a working prototype for au0828 which is an
> easier case. I am working on resolving a couple of issues to differentiate
> media devices allocated using the global media device list vs. the ones
> embedded in the driver data structures. We have many of those.
> 
> I had to put this work on the back burner to get the au0882 and
> snd-usb-audio wrapped up. I can get the RFC patches on top of the au0882
> and snd-usb-audio. We can discuss them at the upcoming media summit.
> 
> > In the mean time, let's hold off on this patch, and merge a proper
> > solution instead.
> 
> I think Mauro's restructure helps us with such differentiation and it will
> be easy enough to change out devres to get media get API.

We have build too much technical debt already. I would really dislike seeing 
another hack being merged to fix partial problems when we know what needs to 
be done for a proper implementation. That's not the Linux upstream development 
I've known and grown to love, we don't pile up half-baked patches and hope 
that everything will be magically cleaned up later :-)

-- 
Regards,

Laurent Pinchart

