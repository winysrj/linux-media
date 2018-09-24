Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60856 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728680AbeIXVDS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 17:03:18 -0400
Date: Mon, 24 Sep 2018 18:00:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, h.grohne@intenta.de
Subject: Re: [PATCH 1/1] v4l: Remove support for crop default target in
 subdev drivers
Message-ID: <20180924150042.q4ksoiktoe64fftk@valkosipuli.retiisi.org.uk>
References: <20180924144227.31237-1-sakari.ailus@linux.intel.com>
 <b7c721df-1035-40d1-f507-fe7a474e85e5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7c721df-1035-40d1-f507-fe7a474e85e5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 24, 2018 at 04:47:07PM +0200, Hans Verkuil wrote:
> On 09/24/2018 04:42 PM, Sakari Ailus wrote:
> > The V4L2 sub-device API does not support the crop default target. A number
> > of drivers apparently still did support this, likely as it was needed by
> > the SoC camera framework. Drop support for the default crop rectaingle in
> > sub-device drivers, and use the bround in SoC camera instead.

				    ^

This was intended to be "bounds rectangle" instead. I'll fix that to the
pull request.

> > 
> > Reported-by: Helmut Grohne <h.grohne@intenta.de>
> > Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
