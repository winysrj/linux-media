Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60349 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758465Ab2J2UAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 16:00:42 -0400
Date: Mon, 29 Oct 2012 22:00:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/23] V4L: Add auto focus targets to the selections API
Message-ID: <20121029200036.GA25623@valkosipuli.retiisi.org.uk>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
 <1336645858-30366-11-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336645858-30366-11-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, May 10, 2012 at 12:30:45PM +0200, Sylwester Nawrocki wrote:
> The camera automatic focus algorithms may require setting up
> a spot or rectangle coordinates or multiple such parameters.
> 
> The automatic focus selection targets are introduced in order
> to allow applications to query and set such coordinates. Those
> selections are intended to be used together with the automatic
> focus controls available in the camera control class.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/selection-api.xml  |   33 +++++++++++++++++++-
>  .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +++++++
>  include/linux/videodev2.h                          |    5 +++
>  3 files changed, 48 insertions(+), 1 deletion(-)

What's the status of this patch? May I ask if you have plans to continue
with it?

Speaking of multiple AF windows --- I originally thought we could just have
multiple selection targets for them. I'm not sure which one would be better;
multiple selection targets or another field telling the window ID. In case
of the former we'd leave a largish gap for additional window IDs.

I think I'm leaning towards using one reserved field for the purpose.

Another question I had was that which of the selection rectangles would the
AF rectangle be related to? Is it the compose bounds rectangle, or the crop
bounds rectangle, for example? I thought it might make sense to use another
field to tell that, since I think which one this really is related to is
purely hardware specific.

What do you think?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
