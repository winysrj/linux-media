Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19542 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725199AbeIPEYN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Sep 2018 00:24:13 -0400
Date: Sun, 16 Sep 2018 02:02:30 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: hugues.fruchet@st.com, Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v3 0/5] Fix OV5640 exposure & gain
Message-ID: <20180915230229.ivldwawzwignkbxv@kekkonen.localdomain>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
 <20180914160712.GD16851@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180914160712.GD16851@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo, Hugues,

On Fri, Sep 14, 2018 at 06:07:12PM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Tue, Sep 11, 2018 at 03:48:16PM +0200, Hugues Fruchet wrote:
> > This patch serie fixes some problems around exposure & gain in OV5640 driver.
> 
> As you offered to collect this series and my CSI-2 fixes I have just
> re-sent, you might be interested in this branch:
> 
> git://jmondi.org/linux
> engicam-imx6q/media-master/ov5640/csi2_init_v4_exposure_v3
> 
> I have there re-based this series on top of mine, which is in turn
> based on latest media master, where this series do not apply as-is
> afaict.
> 
> I have added to Hugues' patches my reviewed-by and tested-by tags.
> If you prefer to I can send you a pull request, or if you want to have
> a chance to review the whole patch list please refer to the above
> branch.
> 
> Let me know if I can help speeding up the inclusion of these two
> series as they fix two real issues of MIPI CSI-2 capture operations
> for this sensor.

I've pushed the patches here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.20-5>

There was a merge commit and a few extra patches in your tree; I threw them
out. :-)

I also edited the commit messages slightly (format; no change in content)
--- the patches are as-is. I'll still check they look right before sending
a pull request, likely on Monday.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
