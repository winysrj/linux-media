Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45212 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751616AbdEJH7j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 03:59:39 -0400
Date: Wed, 10 May 2017 10:58:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH[ v4l2-ioctl.c: always copy G/S_EDID result
Message-ID: <20170510075858.GA3227@valkosipuli.retiisi.org.uk>
References: <ea4085e3-07aa-44f5-fef6-4913858bd707@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea4085e3-07aa-44f5-fef6-4913858bd707@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, May 10, 2017 at 08:36:56AM +0200, Hans Verkuil wrote:
> The VIDIOC_G/S_EDID ioctls can return valid data even if an error is returned.
> 
> Mark those ioctls accordingly. Rather than using an explicit 'if' to check for the
> ioctl (as was done until now for VIDIOC_QUERY_DV_TIMINGS) just set a new flag in the
> v4l2_ioctls array.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
