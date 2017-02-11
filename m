Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52114 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751155AbdBKWIj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 17:08:39 -0500
Date: Sun, 12 Feb 2017 00:08:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] v4l: split lane parsing code
Message-ID: <20170211220836.6jsaivly5b6vqkcq@ihha.localdomain>
References: <20161228183116.GA13407@amd>
 <20170102070425.GE3958@valkosipuli.retiisi.org.uk>
 <20170112102405.GF29366@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112102405.GF29366@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thu, Jan 12, 2017 at 11:24:06AM +0100, Pavel Machek wrote:
> 
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The function to parse CSI2 bus parameters was called
> v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
> anticipation of CSI1/CCP2 support.
> 
> Obtain data bus type from bus-type property. Only try parsing bus
> specific properties in this case.
> 
> Separate lane parsing from CSI-2 bus parameter parsing. The CSI-1 will
> need these as well, separate them into a different
> function. have_clk_lane and num_data_lanes arguments may be NULL; the
> CSI-1 bus will have no use for them.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

The patch looks good to me. Could you post a patchset containing all the
needed patches, maybe on top of the DT patches in the ccp2 branch, please?
It'd be easier to handle this that way.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
