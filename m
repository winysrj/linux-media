Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51278 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753117AbeBGIxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 03:53:22 -0500
Date: Wed, 7 Feb 2018 10:53:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-ioctl.c: fix VIDIOC_DV_TIMINGS_CAP: don't clear pad
Message-ID: <20180207085319.zucciygg72gw63oy@valkosipuli.retiisi.org.uk>
References: <4b4680d3-047a-c229-3de7-e7a548883822@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b4680d3-047a-c229-3de7-e7a548883822@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 06, 2018 at 08:04:42PM +0100, Hans Verkuil wrote:
> The pad field should be passed on to the subdev driver, but it is cleared in
> v4l2-ioctl.c so the subdev driver always sees a 0 pad.
> 
> Found with v4l2-compliance.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Tim Harvey <tharvey@gateworks.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
