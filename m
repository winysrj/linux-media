Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45634 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728395AbeJHWpH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 18:45:07 -0400
Date: Mon, 8 Oct 2018 18:32:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org
Subject: Re: [RFC PATCH 00/11] Convert last remaining g/s_crop/cropcap drivers
Message-ID: <20181008153249.oyip4u3ij2ufd2f4@valkosipuli.retiisi.org.uk>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Oct 05, 2018 at 09:49:00AM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series converts the last remaining drivers that use g/s_crop and
> cropcap to g/s_selection.
> 
> The first two patches do some minor code cleanup.
> 
> The third patch adds a new video_device flag to indicate that the driver
> inverts the normal usage of g/s_crop/cropcap. This applies to the old
> Samsung drivers that predate the Selection API and that abused the existing
> crop API.
> 
> The next three patches do some code cleanup and prepare drivers for the
> removal of g/s_crop and ensure that cropcap only returns the pixelaspect.
> 
> The next three patches convert the remaining Samsung drivers and set the
> QUIRK flag for all three.
> 
> The final two patches remove vidioc_g/s_crop and rename vidioc_cropcap
> to vidioc_g_pixelaspect.

Nice one; thanks!

For patches 1, 2, 3, 10 and 11:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I didn't read through the driver changes but I assume they would be fine.
:-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
