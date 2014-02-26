Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57339 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752598AbaBZAJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 19:09:43 -0500
Date: Wed, 26 Feb 2014 02:09:40 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH v5 3/7] v4l: Add timestamp source flags, mask and
 document them
Message-ID: <20140226000940.GH15635@valkosipuli.retiisi.org.uk>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-4-git-send-email-sakari.ailus@iki.fi>
 <12fa01cf322a$d8c35950$8a4a0bf0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12fa01cf322a$d8c35950$8a4a0bf0$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 25, 2014 at 02:09:41PM +0100, Kamil Debski wrote:
> Hi Sakari,
> 
> > From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> > Sent: Saturday, February 15, 2014 9:53 PM
> > 
> > Some devices do not produce timestamps that correspond to the end of
> > the frame. The user space should be informed on the matter. This patch
> > achieves that by adding buffer flags (and a mask) for timestamp sources
> > since more possible timestamping points are expected than just two.
> > 
> > A three-bit mask is defined (V4L2_BUF_FLAG_TSTAMP_SRC_MASK) and two of
> > the eight possible values is are defined V4L2_BUF_FLAG_TSTAMP_SRC_EOF
> > for end of frame (value zero) V4L2_BUF_FLAG_TSTAMP_SRC_SOE for start of
> > exposure (next value).
> > 
> 
> Changes in videobuf2-core.c look good.
> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Acked-by: Kamil Debski <k.debski@samsung.com>

Many thanks for the reviews, Kamil! :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
