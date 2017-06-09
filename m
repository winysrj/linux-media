Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34218 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751539AbdFIK4h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 06:56:37 -0400
Date: Fri, 9 Jun 2017 13:55:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer
 format
Message-ID: <20170609105558.GP1019@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-2-git-send-email-yong.zhi@intel.com>
 <20170605214327.19b26021@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170605214327.19b26021@lxorguk.ukuu.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Mon, Jun 05, 2017 at 09:43:27PM +0100, Alan Cox wrote:
> On Mon,  5 Jun 2017 15:39:06 -0500
> Yong Zhi <yong.zhi@intel.com> wrote:
> 
> > Add the IPU3 specific processing parameter format
> > V4L2_META_FMT_IPU3_PARAMS and metadata formats
> > for 3A and other statistics:
> > 
> >   V4L2_META_FMT_IPU3_PARAMS
> >   V4L2_META_FMT_IPU3_STAT_3A
> >   V4L2_META_FMT_IPU3_STAT_DVS
> >   V4L2_META_FMT_IPU3_STAT_LACE
> 
> Are these specific to IPU v3 or do they match other IPU versions ?

The parameters (V4L2_META_FMT_IPU3_PARAMS) are bound to be different (for
previous versions had a private IOCTL to pass them). There could be
similarities between different versions of the IPUs but they're still not
exactly the same. The hardware tends to change quite a bit between the
generations.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
