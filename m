Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43686 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752686AbdFPNJA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 09:09:00 -0400
Date: Fri, 16 Jun 2017 16:08:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC PATCH 2/2] media/uapi/v4l: clarify cropcap/crop/selection
 behavior
Message-ID: <20170616130855.GR12407@valkosipuli.retiisi.org.uk>
References: <20170508143506.16448-1-hverkuil@xs4all.nl>
 <20170508143506.16448-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170508143506.16448-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 08, 2017 at 04:35:06PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Unfortunately the use of 'type' was inconsistent for multiplanar
> buffer types. Starting with 4.12 both the normal and _MPLANE variants
> are allowed, thus making it possible to write sensible code.
> 
> Yes, we messed up :-(

Things worse than this have happened. :-)

I don't think in general I would write about driver bugs that have already
been fixed in developer documentation. That said, I'm not sure how otherwise
developers would learn about this, but OTOH has it been reported to us as a
bug?

Marek, Sylwester: any idea how widely the drivers in question are in use? If
there's a real chance of hitting this, then it does make sense to mention it
in the documentation.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
