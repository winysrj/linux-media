Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46530 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752761AbbCYA2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 20:28:53 -0400
Date: Wed, 25 Mar 2015 02:28:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DocBook media: improve event documentation
Message-ID: <20150325002849.GD18321@valkosipuli.retiisi.org.uk>
References: <55094DEB.2050908@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55094DEB.2050908@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Mar 18, 2015 at 11:05:31AM +0100, Hans Verkuil wrote:
> It always annoyed me that the event type documentation was separate from the struct
> v4l2_event documentation. This patch moves it all to one place, VIDIOC_DQEVENT.
> 
> This makes much more sense.

I think the original reasoning was that in order to get an event of a
particular kind, the user must first subscribe the type. That's why the
event types were documented in conjunction with VIDIOC_SUBSCRIBE_EVENT, not
with VIDIOC_DQEVENT.

Should I write the documentation again, I'd put it where it now is. I have
no strict opinion on that though.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
