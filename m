Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3824 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2JQGig (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 02:38:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: media-workshop@linuxtv.org
Subject: Re: RFC: V4L2 API ambiguities
Date: Wed, 17 Oct 2012 08:38:20 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <201210151335.45477.hverkuil@xs4all.nl>
In-Reply-To: <201210151335.45477.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210170838.20507.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 15 2012 13:35:45 Hans Verkuil wrote:
> During the Plumbers Conference a few weeks ago we had a session to resolve V4L2
> ambiguities. It was very successful, but we didn't manage to tackle two of the
> harder topics, and a third one (timestamps) cause a lot of discussion on the
> mailinglist after the conference.
> 
> So here is the list I have today. Any other ambiguities or new features that
> should be added to the list?

I've got another:

Right now there are no standard ioctls that one could call for a v4l-subdev node
to discover whether the device node is really a subdev node. For other v4l nodes
we have QUERYCAP, but that's not available for subdev nodes.

I propose that QUERYCAP support is added (and will be required) for subdev nodes.
The capabilities field will be set to V4L2_CAP_SUBDEVICE only (at least for now).
All other fields of v4l2_capability are just as valid for subdevs as they are for
normal v4l devices.

Regards,

	Hans
