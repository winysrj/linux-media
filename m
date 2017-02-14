Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54902 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755665AbdBNVaB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 16:30:01 -0500
Date: Tue, 14 Feb 2017 23:29:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 03/13] v4l: split lane parsing code
Message-ID: <20170214212927.GL16975@valkosipuli.retiisi.org.uk>
References: <20170214133941.GA8469@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214133941.GA8469@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Feb 14, 2017 at 02:39:41PM +0100, Pavel Machek wrote:
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
> Add support for parsing of CSI-1 and CCP2 bus related properties
> documented in video-interfaces.txt.

One more thing: this conflicts badly with the V4L2 fwnode patchset.

Assuming things go well and that can be merged somewhat soonish, can I take
this and rebase it on the fwnode set? The two first patches in the set look
pretty good to me.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
