Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53701 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751221AbaBQXcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 18:32:06 -0500
Date: Tue, 18 Feb 2014 01:32:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com
Subject: Re: [PATCH v5 7/7] v4l: Document timestamp buffer flag behaviour
Message-ID: <20140217233203.GX15635@valkosipuli.retiisi.org.uk>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-8-git-send-email-sakari.ailus@iki.fi>
 <52FFD60B.4080308@xs4all.nl>
 <1640658.PZi431b47s@avalon>
 <5301CBAA.80103@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5301CBAA.80103@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 17, 2014 at 09:43:22AM +0100, Hans Verkuil wrote:
> >>> +    the masks <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> >>> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> >>> +    linkend="buffer-flags">. These flags are guaranteed to be always
> >>> +    valid and will not be changed by the driver autonomously.
> > 
> > This sentence sounds a bit confusing to me. What about
> > 
> > "These flags are always valid and are constant across all buffers during the 
> > whole video stream."
> 
> I like this.

I'll put that to the next version.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
