Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41454 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933509AbeFZMTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 08:19:36 -0400
Date: Tue, 26 Jun 2018 15:19:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] media: imx274: cleanups, improvements and
 SELECTION API support
Message-ID: <20180626121934.5xhp6k7x2se6pmqr@valkosipuli.retiisi.org.uk>
References: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On Mon, Jun 11, 2018 at 01:35:31PM +0200, Luca Ceresoli wrote:
> Hi,
> 
> this patchset introduces cropping support for the Sony IMX274 sensor
> using the SELECTION API.
> 
> With respect to v3, this version uses the SELECTION API with taget
> V4L2_SEL_TGT_COMPOSE to change the output resolution. This is the
> recommended API for cropping + downscaling. However for backward
> compatibility the set_format callback is still supported and is
> equivalent to setting the compose rect as far as resolutions are
> concerned.
> 
> Patches 1-5 are overall improvements and restructuring, mostly useful
> to implement the SELECTION API in a clean way.
> 
> Patch 6 introduces a helper to allow setting many registers computed
> at runtime in a straightforward way. This would not have been very
> useful before because all long register write sequences came from
> const tables, but it's definitely a must for the cropping code where
> several register values are computed at runtime.
> 
> Patch 7 is new in this series, it's a trivial typo fix that can be
> applied independently.
> 
> Patch 8 implements the set_selection pad operation for cropping
> (V4L2_SEL_TGT_CROP) and binning (V4L2_SEL_TGT_COMPOSE). The most
> tricky part was respecting all the device constraints on the
> horizontal crop.

My apologies for delays in reviewing the set. I'll take patches 1--5 and 7
and then I'll comment on patches 6 and 8 separately. Would that work for
you?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
