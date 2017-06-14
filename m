Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53020 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752204AbdFNWjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 18:39:21 -0400
Date: Thu, 15 Jun 2017 01:38:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, hyungwoo.yang@intel.com,
        divagar.mohandass@intel.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 1/3] videodev2.h, v4l2-ioctl: add IPU3 raw10 color
 format
Message-ID: <20170614223846.GV12407@valkosipuli.retiisi.org.uk>
References: <1497385036-1002-1-git-send-email-yong.zhi@intel.com>
 <1497385036-1002-2-git-send-email-yong.zhi@intel.com>
 <20170614144840.4260501d@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170614144840.4260501d@alans-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 14, 2017 at 02:48:40PM +0100, Alan Cox wrote:
> On Tue, 13 Jun 2017 15:17:14 -0500
> Yong Zhi <yong.zhi@intel.com> wrote:
> 
> > Add IPU3 specific formats:
> > 
> > 	V4L2_PIX_FMT_IPU3_SBGGR10
> > 	V4L2_PIX_FMT_IPU3_SGBRG10
> > 	V4L2_PIX_FMT_IPU3_SGRBG10
> > 	V4L2_PIX_FMT_IPU3_SRGGB10
> 
> As I said before these are just more bitpacked bayer formats with no
> reason to encode them as IPUv3 specific names.

I must have missed that comment --- the format is pretty unusual still.
Basically it rams as much pixels into a 256-bit DMA word as there's room and
then leaves the rest of the DMA word empty (6 bits in this case).

The newer IPUs do not use this format AFAIK (they do use other unusual
formats though). I haven't seen such formats being used by other non-IPU
hardware either.

I think I'd keep this IPU specific unless there's an indication the same
formats might be used elsewhere. The other packed formats that have been
defined in V4L2 are hardware independent.

Cc Hans, too.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
