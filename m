Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:65270 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdH0Wki (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 18:40:38 -0400
Date: Mon, 28 Aug 2017 01:40:33 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rob Herring <robh@kernel.org>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH v2] device property: preserve usecount for node passed to
 of_fwnode_graph_get_port_parent()
Message-ID: <20170827224033.2ubrkzp33g5supab@kekkonen.localdomain>
References: <20170822001912.27638-1-niklas.soderlund+renesas@ragnatech.se>
 <CAL_Jsq+ABipq+YCpSwu_vhjk0rkZQimCD2vG1x5GL91wi6dzKw@mail.gmail.com>
 <20170822150050.GD14873@bigcity.dyn.berto.se>
 <CAL_JsqJOZPrOwy1Hi7zdHb-+X69rV2M5ZZd=X8aoWjvjqt+NNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJOZPrOwy1Hi7zdHb-+X69rV2M5ZZd=X8aoWjvjqt+NNg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Tue, Aug 22, 2017 at 02:42:10PM -0500, Rob Herring wrote:
> On Tue, Aug 22, 2017 at 10:00 AM, Niklas Söderlund
> <niklas.soderlund@ragnatech.se> wrote:
> > Hi Rob,
> >
> > On 2017-08-22 09:49:35 -0500, Rob Herring wrote:
> >> On Mon, Aug 21, 2017 at 7:19 PM, Niklas Söderlund
> >> <niklas.soderlund+renesas@ragnatech.se> wrote:
> >> > Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
> >> > node being passed to of_fwnode_graph_get_port_parent(). Preserve the
> >> > usecount by using of_get_parent() instead of of_get_next_parent() which
> >> > don't decrement the usecount of the node passed to it.
> >> >
> >> > Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
> >> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> > ---
> >> >  drivers/of/property.c | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> Isn't this already fixed with this fix:
> >>
> >> commit c0a480d1acf7dc184f9f3e7cf724483b0d28dc2e
> >> Author: Tony Lindgren <tony@atomide.com>
> >> Date:   Fri Jul 28 01:23:15 2017 -0700
> >>
> >> device property: Fix usecount for of_graph_get_port_parent()
> >
> > No, that commit fixes it for of_graph_get_port_parent() while this
> > commit fixes it for of_fwnode_graph_get_port_parent(). But in essence it
> > is the same issue but needs two separate fixes.
> 
> Ah, because one takes the port node and one takes the endpoint node.
> That won't confuse anyone.

Yes, I think we've had this for some time in naming of a few graph
functions and increasingly so lately. It began with
of_graph_get_remote_port_parent(), which likely was named so to avoid the
name getting really long. The function itself gets a remove of the endpoint
given as an argument, then the port related to the entpoint and finally the
parent node of the port node (which is not the "ports" node). That's a lot
of work for a single interface function.

What comes to of_fwnode_graph_get_port_parent() --- it's the OF callback
function for the fwnode graph API that, as the name suggests, gets the
parent of the port node, no more, no less. The function is used in the
fwnode graph API implementation and is not available in the API as such.
The fwnode graph API itself only implements functionality already available
in the OF graph API under the corresponding name.

> 
> Can we please align this mess. I've tried to make the graph parsing
> not a free for all, open coded mess. There's no reason to have the
> port node handle and then need the parent device. Either you started
> with the parent device to parse local ports and endpoints or you got
> the remote endpoint with .graph_get_remote_endpoint(). Most of the
> time you don't even need the endpoint node handles. You really just
> need to know what is the remote device connected to port X, endpoint Y
> of my local device.

Perhaps most of the time, yes. V4L2 devices store bus (e.g. MIPI CSI-2)
specific information in the endpoint nodes.

The current OF graph API is geared towards providing convenience functions
to the extent that a single function performs actions a driver would
typically need. More recently functions implementing a single operation has
been added; the primitives that just perform a single operation would
likely be easier to manage.

The convenience functions have been, well, convenient as getting and
putting nodes could have been somewhat ignored in drivers. If the OF graph
API usage can be moved out of the drivers we'll likely have way fewer users
and thus there's no real need for convenience functions. That has other
benefits, too, such as parsing the graph correctly: most V4L2 drivers have
issues in this area.

The OF graph API (or the fwnode equivalent) is used effectively in all V4L2
drivers that support OF (there are about 20 of them); we're moving these to
the V4L2 framework but it'll take some time. That should make it easier for
cleaning things up. Based on a quick look V4L2 and V4L2 drivers together
represent a large proportion of all users in the kernel.

What do you think?

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
