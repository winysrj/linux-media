Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51138 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751336AbdJXUgD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 16:36:03 -0400
Date: Tue, 24 Oct 2017 23:36:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v15.2 24/32] v4l: fwnode: Add a helper function to obtain
 device / integer references
Message-ID: <20171024203559.x7wmou7va3iw626t@valkosipuli.retiisi.org.uk>
References: <ffc57dfd-e798-d532-e029-dc91989e285c@xs4all.nl>
 <20171024203254.19993-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171024203254.19993-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 24, 2017 at 11:32:54PM +0300, Sakari Ailus wrote:
> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> the device's own fwnode, it will follow child fwnodes with the given
> property-value pair and return the resulting fwnode.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

since v15.1:

- Add DT example.

- Add textual description as suggested by Hans.


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
