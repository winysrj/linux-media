Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40552 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933337AbcHDOD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 10:03:26 -0400
Date: Thu, 4 Aug 2016 17:03:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv2] v4l2-common: add s_selection helper function
Message-ID: <20160804140313.GI3243@valkosipuli.retiisi.org.uk>
References: <c6379bf1-4fdf-7deb-4312-86d26d0ee106@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6379bf1-4fdf-7deb-4312-86d26d0ee106@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Aug 01, 2016 at 12:33:39PM +0200, Hans Verkuil wrote:
> Checking the selection constraint flags is often forgotten by drivers, especially
> if the selection code just clamps the rectangle to the minimum and maximum allowed
> rectangles.
> 
> This patch adds a simple helper function that checks the adjusted rectangle against
> the constraint flags and either returns -ERANGE if it doesn't fit, or fills in the
> new rectangle and returns 0.
> 
> It also adds a small helper function to v4l2-rect.h to check if one rectangle fits
> inside another.

I could have misunderstood the purpose of the patch but... these flags are
used by drivers in guidance in adjusting the rectangle in case there are
hardware limitations, to make it larger or smaller than requested if the
request can't be fulfillsed as such. The intent is *not* to return an error
back to the user. In this respect it works quite like e.g. S_FMT does in
cases an exact requested format can't be supported.

<URL:https://www.linuxtv.org/downloads/v4l-dvb-apis/apb.html#v4l2-selection-flags>

What can be done is rather driver specific.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
