Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42658 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756830Ab2IMUiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 16:38:19 -0400
Date: Thu, 13 Sep 2012 23:38:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 12/28] v4l2-core: Add new
 V4L2_CAP_MONOTONIC_TS capability.
Message-ID: <20120913203814.GK6834@valkosipuli.retiisi.org.uk>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
 <86a39343d33f0f75079407d8b36202a1de4c58de.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a39343d33f0f75079407d8b36202a1de4c58de.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch!

On Fri, Sep 07, 2012 at 03:29:12PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a new flag that tells userspace that the monotonic clock is used
> for timestamps and update the documentation accordingly.
> 
> We decided on this new flag during the 2012 Media Workshop.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/io.xml              |   10 +++++++---
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml  |    3 ++-
>  Documentation/DocBook/media/v4l/vidioc-querycap.xml |    7 +++++++
>  include/linux/videodev2.h                           |    1 +
>  4 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 2dc39d8..b680d66 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -582,10 +582,14 @@ applications when an output stream.</entry>
>  	    <entry>struct timeval</entry>
>  	    <entry><structfield>timestamp</structfield></entry>
>  	    <entry></entry>
> -	    <entry><para>For input streams this is the
> +	    <entry><para>This is either the
>  system time (as returned by the <function>gettimeofday()</function>
> -function) when the first data byte was captured. For output streams
> -the data will not be displayed before this time, secondary to the
> +function) or a monotonic timestamp (as returned by the
> +<function>clock_gettime(CLOCK_MONOTONIC, &amp;ts)</function> function).
> +A monotonic timestamp is used if the <constant>V4L2_CAP_MONOTONIC_TS</constant>
> +capability is set, otherwise the system time is used.
> +For input streams this is the timestamp when the first data byte was captured.
> +For output streams the data will not be displayed before this time, secondary to the

I have an alternative proposal.

The type of the desired timestamps depend on the use case, not the driver
used to capture the buffers. Thus we could also give the choice to the user
by means of e.g. a control.

If we'd make it configurable (applications would still get the wallclock
time unless they ask for monotonic time), we'd have a chance to add more
precision by using struct timespec (ns precision) instead of struct timeval
(us precision). struct timespec is also used by V4L2 events.

Adding support for CLOCK_MONOTONIC_RAW would also be a non-issue.

Additional helper function could be used to generate the timestamp of the
desired type.

What do you think?

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
