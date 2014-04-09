Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38616 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932847AbaDIR1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 13:27:48 -0400
Date: Wed, 9 Apr 2014 20:27:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com
Subject: Re: vb2: various small fixes/improvements
Message-ID: <20140409172744.GB7530@valkosipuli.retiisi.org.uk>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 10, 2014 at 10:20:47PM +0100, Hans Verkuil wrote:
> This patch series contains a list of various vb2 fixes and improvements.
> 
> These patches were originally part of this RFC patch series:
> 
> http://www.spinics.net/lists/linux-media/msg73391.html
> 
> They are now rebased and reordered a bit. It's little stuff for the
> most part, although the first patch touches on more drivers since it
> changes the return type of stop_streaming to void. The return value was
> always ignored by vb2 and you really cannot do anything sensible with it.
> In general resource allocations can return an error, but freeing up resources
> should not. That should always succeed.

For patches 1--10, with Pawel's comments addressed:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
