Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33079 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753871AbdHUOEq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 10:04:46 -0400
Received: by mail-lf0-f50.google.com with SMTP id d17so67235402lfe.0
        for <linux-media@vger.kernel.org>; Mon, 21 Aug 2017 07:04:45 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 21 Aug 2017 16:04:43 +0200
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] device property: preserve usecount for node passed to
 of_fwnode_graph_get_port_parent()
Message-ID: <20170821140443.GA32709@bigcity.dyn.berto.se>
References: <20170821125107.20746-1-niklas.soderlund+renesas@ragnatech.se>
 <282c50da-8927-d1fc-27e5-39b75f3ba564@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <282c50da-8927-d1fc-27e5-39b75f3ba564@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 2017-08-21 16:30:17 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> Niklas Söderlund wrote:
> > Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
> > node being passed to of_fwnode_graph_get_port_parent(). Preserve the
> > usecount just like it is done in of_graph_get_port_parent().
> 
> The of_fwnode_graph_get_port_parent() is called by
> fwnode_graph_get_port_parent() which obtains the port node through
> fwnode_get_parent(). If you take a reference here, calling
> fwnode_graph_get_port_parent() will end up incrementing the port node's use
> count. In other words, my understanding is that dropping the reference to
> the port node isn't a problem but intended behaviour here.

I'm not sure but I don't think the usecount will be incremented, without 
this patch I think it's decremented by one instead. Lets look at the 
code starting with fwnode_graph_get_port_parent().

struct fwnode_handle *
fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
{
        struct fwnode_handle *port, *parent;

Increment usecount by 1

        port = fwnode_get_parent(endpoint);
        parent = fwnode_call_ptr_op(port, graph_get_port_parent);

Decrement usecount by 1

        fwnode_handle_put(port); << Usecount -1

        return parent;
}

Here it looks like the counting is correct and balanced. But without 
this patch it's in this function 'fwnode_handle_put(port)' which 
triggers the error which this patch aims to fix. Lets look at 
of_fwnode_graph_get_port_parent() which in my case is what is called by 
the fwnode_call_ptr_op().

static struct fwnode_handle *
of_fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
{
        struct device_node *np;

Here in of_get_next_parent() the usecount is decremented by 1 and the 
parents usecount is incremented by 1. So for our node node which passed 
in from fwnode_graph_get_port_parent() (where it's named 'port') will be 
decremented by 1.

        /* Get the parent of the port */
        np = of_get_next_parent(to_of_node(fwnode));
        if (!np)
                return NULL;

        /* Is this the "ports" node? If not, it's the port parent. */
        if (of_node_cmp(np->name, "ports"))
                return of_fwnode_handle(np);

        return of_fwnode_handle(of_get_next_parent(np));
}

So unless I miss something I do think this patch is needed to restore 
balance to the usecount of the node being passed to 
of_fwnode_graph_get_port_parent(). Or maybe I have misunderstood 
something?

> 
> I wonder if I miss something.

I also wonder what I missed :-)

> 
> > 
> > Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/of/property.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/of/property.c b/drivers/of/property.c
> > index 067f9fab7b77c794..637dcb4833e2af60 100644
> > --- a/drivers/of/property.c
> > +++ b/drivers/of/property.c
> > @@ -922,6 +922,12 @@ of_fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
> >  {
> >  	struct device_node *np;
> > 
> > +	/*
> > +	 * Preserve usecount for passed in node as of_get_next_parent()
> > +	 * will do of_node_put() on it.
> > +	 */
> > +	of_node_get(to_of_node(fwnode));
> > +
> >  	/* Get the parent of the port */
> >  	np = of_get_next_parent(to_of_node(fwnode));
> >  	if (!np)
> > 
> 
> 
> -- 
> Sakari Ailus
> sakari.ailus@linux.intel.com

-- 
Regards,
Niklas Söderlund
