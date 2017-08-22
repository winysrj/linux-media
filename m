Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932523AbdHVOt5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 10:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170822001912.27638-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822001912.27638-1-niklas.soderlund+renesas@ragnatech.se>
From: Rob Herring <robh@kernel.org>
Date: Tue, 22 Aug 2017 09:49:35 -0500
Message-ID: <CAL_Jsq+ABipq+YCpSwu_vhjk0rkZQimCD2vG1x5GL91wi6dzKw@mail.gmail.com>
Subject: Re: [PATCH v2] device property: preserve usecount for node passed to of_fwnode_graph_get_port_parent()
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 21, 2017 at 7:19 PM, Niklas Söderlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
> node being passed to of_fwnode_graph_get_port_parent(). Preserve the
> usecount by using of_get_parent() instead of of_get_next_parent() which
> don't decrement the usecount of the node passed to it.
>
> Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/of/property.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Isn't this already fixed with this fix:

commit c0a480d1acf7dc184f9f3e7cf724483b0d28dc2e
Author: Tony Lindgren <tony@atomide.com>
Date:   Fri Jul 28 01:23:15 2017 -0700

device property: Fix usecount for of_graph_get_port_parent()
