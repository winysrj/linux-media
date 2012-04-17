Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34895 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756087Ab2DQPhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 11:37:01 -0400
Date: Tue, 17 Apr 2012 18:36:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] Fix QUERYMENU regression
Message-ID: <20120417153655.GF5356@valkosipuli.localdomain>
References: <201204171441.58423.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204171441.58423.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Apr 17, 2012 at 02:41:58PM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> This patch fixes a regression in VIDIOC_QUERYMENU introduced when the
> __s64 value field was added to the union. On a 64-bit system this will
> change the size of this v4l2_querymenu structure from 44 to 48 bytes,
> thus breaking the ABI. By adding the packed attribute it is working again.

Thanks! The original patch wasn't tested on 64-bit systems and I missed the
fact that the structure size is aligned to the size of the widest data type
used in it to keep alignment set, which Laurent kindly informed me about.
So,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
