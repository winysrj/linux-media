Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48575 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbaKXVnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 16:43:08 -0500
Date: Mon, 24 Nov 2014 23:36:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hans.verkuil@xs4all.nl
Subject: Re: [REVIEW PATCH v2.1 2/5] v4l: Add V4L2_SEL_TGT_NATIVE_SIZE
 selection target
Message-ID: <20141124213624.GJ8907@valkosipuli.retiisi.org.uk>
References: <1416289220-32673-3-git-send-email-sakari.ailus@iki.fi>
 <1416344890-28142-1-git-send-email-sakari.ailus@iki.fi>
 <54730D1D.7010500@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54730D1D.7010500@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 24, 2014 at 11:49:01AM +0100, Hans Verkuil wrote:
> On 11/18/14 22:08, Sakari Ailus wrote:
> > The V4L2_SEL_TGT_NATIVE_SIZE target is used to denote e.g. the size of a
> > sensor's pixel array.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> For the whole patch series:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Thanks!
> 
> Once this is mainlined, can you update v4l2-ctl so it supports this
> new target?

Sure! I'll do the same to media-ctl.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
