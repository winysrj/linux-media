Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37858 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932426AbdERP0Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 11:26:16 -0400
Date: Thu, 18 May 2017 18:26:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        John Youn <johnyoun@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/3] device property: Add fwnode_graph_get_port_parent
Message-ID: <20170518152607.GV3227@valkosipuli.retiisi.org.uk>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
 <e81284b2bb29552ab7cf02c07367a6a542f06d49.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e81284b2bb29552ab7cf02c07367a6a542f06d49.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, May 17, 2017 at 04:03:38PM +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> V4L2 async notifiers can pass the endpoint fwnode rather than the device
> fwnode.
> 
> Provide a helper to obtain the parent device fwnode without first
> parsing the remote-endpoint as per fwnode_graph_get_remote_port_parent.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Could you rebase this on my fwnode cleanup patchset here, please? I'd be
happy to apply it on top of the set.

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=acpi-graph-cleaned>

This function becomes quite simple, see
fwnode_graph_get_remote_port_parent().

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
