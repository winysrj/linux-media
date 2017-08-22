Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36713 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932922AbdHVPAx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 11:00:53 -0400
Received: by mail-lf0-f41.google.com with SMTP id l137so5313845lfg.3
        for <linux-media@vger.kernel.org>; Tue, 22 Aug 2017 08:00:53 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 22 Aug 2017 17:00:50 +0200
To: Rob Herring <robh@kernel.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2] device property: preserve usecount for node passed to
 of_fwnode_graph_get_port_parent()
Message-ID: <20170822150050.GD14873@bigcity.dyn.berto.se>
References: <20170822001912.27638-1-niklas.soderlund+renesas@ragnatech.se>
 <CAL_Jsq+ABipq+YCpSwu_vhjk0rkZQimCD2vG1x5GL91wi6dzKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_Jsq+ABipq+YCpSwu_vhjk0rkZQimCD2vG1x5GL91wi6dzKw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 2017-08-22 09:49:35 -0500, Rob Herring wrote:
> On Mon, Aug 21, 2017 at 7:19 PM, Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
> > node being passed to of_fwnode_graph_get_port_parent(). Preserve the
> > usecount by using of_get_parent() instead of of_get_next_parent() which
> > don't decrement the usecount of the node passed to it.
> >
> > Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/of/property.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Isn't this already fixed with this fix:
> 
> commit c0a480d1acf7dc184f9f3e7cf724483b0d28dc2e
> Author: Tony Lindgren <tony@atomide.com>
> Date:   Fri Jul 28 01:23:15 2017 -0700
> 
> device property: Fix usecount for of_graph_get_port_parent()

No, that commit fixes it for of_graph_get_port_parent() while this 
commit fixes it for of_fwnode_graph_get_port_parent(). But in essence it 
is the same issue but needs two separate fixes.

-- 
Regards,
Niklas Söderlund
