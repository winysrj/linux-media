Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51732 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752075AbbFYJgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:36:00 -0400
Date: Thu, 25 Jun 2015 12:35:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-event: v4l2_event_queue: do nothing if vdev == NULL
Message-ID: <20150625093558.GI5904@valkosipuli.retiisi.org.uk>
References: <558924D7.4010904@xs4all.nl>
 <20150625091236.GH5904@valkosipuli.retiisi.org.uk>
 <558BC83A.1070308@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <558BC83A.1070308@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

On Thu, Jun 25, 2015 at 11:22:02AM +0200, Lars-Peter Clausen wrote:
> On 06/25/2015 11:12 AM, Sakari Ailus wrote:
> >Hi Hans,
> >
> >On Tue, Jun 23, 2015 at 11:20:23AM +0200, Hans Verkuil wrote:
> >>If the vdev pointer == NULL, then just return.
> >>
> >>This makes it easier for subdev drivers to use this function without having to
> >>check if the sd->devnode pointer is NULL or not.
> >
> >Do you have an example of when this would be useful? Isn't it a rather
> >fundamental question to a driver whether or not it exposes a device node,
> >i.e. why would a driver use v4l2_event_queue() in the first place if it does
> >not expose a device node, and so the event interface?
> 
> The device node will only be created if the subdev driver supports it and if
> the bridge driver requests it. So if the subdev driver supports it, but the
> bridge driver does not request it there will be no devnode. The patch is to
> handle that case.
> 
> This patch is a requirement for this series which adds support for direct
> event notification to some subdev drivers. Why this is necessary and useful
> can be found in the series patch description.
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/92808

Ok, fair enough.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
