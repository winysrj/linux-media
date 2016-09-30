Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37031 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbcI3IwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 04:52:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        arnd@arndb.de, hans.verkuil@cisco.com, tony@atomide.com,
        letux-kernel@openphoenux.org
Subject: Re: [PATCH] [media] omap3isp: don't call of_node_put
Date: Fri, 30 Sep 2016 11:52:16 +0300
Message-ID: <14483379.k0ruKCM9Us@avalon>
In-Reply-To: <D2919AEE-E8B6-4CC8-9558-8AF1F50E6961@goldelico.com>
References: <b46d4d86d20d6b93ecc0b434f2c9b7312bcaa829.1473349712.git.hns@goldelico.com> <3824432.fffa8JciHz@avalon> <D2919AEE-E8B6-4CC8-9558-8AF1F50E6961@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Nikolaus,

On Friday 30 Sep 2016 10:28:40 H. Nikolaus Schaller wrote:
> > Am 29.09.2016 um 10:54 schrieb Laurent Pinchart:
> > On Thursday 08 Sep 2016 17:48:33 H. Nikolaus Schaller wrote:
> >> of_node_put() has already been called inside
> >> of_graph_get_next_endpoint().
> >> 
> >> Otherwise we may get warnings like
> >> 
> >> [   10.118286] omap3isp 480bc000.isp: parsing endpoint
> >> /ocp/isp@480bc000/ports/port@0/endpoint, interface 0 [   10.118499]
> >> ERROR:
> >> Bad of_node_put() on /ocp/isp@480bc000/ports/port@0/endpoint [  
> >> 10.118499]
> >> CPU: 0 PID: 968 Comm: udevd Not tainted 4.7.0-rc4-letux+ #376 [
> >> 10.118530] Hardware name: Generic OMAP36xx (Flattened Device Tree) [
> >> 10.118560] [<c010f0e0>] (unwind_backtrace) from [<c010b6d8>]
> >> (show_stack+0x10/0x14) [   10.118591] [<c010b6d8>] (show_stack) from
> >> [<c03ecc50>] (dump_stack+0x98/0xd0) [   10.118591] [<c03ecc50>]
> >> (dump_stack) from [<c03eecac>] (kobject_release+0x60/0x74) [   10.118621]
> >> [<c03eecac>] (kobject_release) from [<c05ab128>]
> >> (__of_get_next_child+0x40/0x48) [   10.118652] [<c05ab128>]
> >> (__of_get_next_child) from [<c05ab158>] (of_get_next_child+0x28/0x44) [
> >> 10.118652] [<c05ab158>] (of_get_next_child) from [<c05ab350>]
> >> (of_graph_get_next_endpoint+0xe4/0x124) [   10.118804] [<c05ab350>]
> >> (of_graph_get_next_endpoint) from [<bf1c88a4>] (isp_probe+0xdc/0xd80
> >> [omap3_isp]) [   10.118896] [<bf1c88a4>] (isp_probe [omap3_isp]) from
> >> [<c0482008>] (platform_drv_probe+0x50/0xa0) [   10.118927] [<c0482008>]
> >> (platform_drv_probe) from [<c04800e8>] (driver_probe_device+0x134/0x29c)
> >> [
> >> 10.118957] [<c04800e8>] (driver_probe_device) from [<c04802d8>]
> >> (__driver_attach+0x88/0xac) [   10.118957] [<c04802d8>] (__driver_attach)
> >> from [<c047e7b8>] (bus_for_each_dev+0x6c/0x90) [   10.118957]
> >> [<c047e7b8>]
> >> (bus_for_each_dev) from [<c047f798>] (bus_add_driver+0xcc/0x1e8) [
> >> 10.118988] [<c047f798>] (bus_add_driver) from [<c0481228>]
> >> (driver_register+0xac/0xf4) [   10.118988] [<c0481228>] (driver_register)
> >> from [<c010192c>] (do_one_initcall+0xac/0x154) [   10.119018]
> >> [<c010192c>]
> >> (do_one_initcall) from [<c02015bc>] (do_init_module+0x58/0x39c) [
> >> 10.119049] [<c02015bc>] (do_init_module) from [<c01bd314>]
> >> (load_module+0xe5c/0x1004) [   10.119049] [<c01bd314>] (load_module) from
> >> [<c01bd68c>] (SyS_finit_module+0x88/0x90) [   10.119079] [<c01bd68c>]
> >> (SyS_finit_module) from [<c0107040>] (ret_fast_syscall+0x0/0x1c)
> >> 
> >> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> >> ---
> >> drivers/media/platform/omap3isp/isp.c | 3 +--
> >> 1 file changed, 1 insertion(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/isp.c
> >> b/drivers/media/platform/omap3isp/isp.c index 5d54e2c..6e2624e 100644
> >> --- a/drivers/media/platform/omap3isp/isp.c
> >> +++ b/drivers/media/platform/omap3isp/isp.c
> >> @@ -2114,7 +2114,6 @@ static int isp_of_parse_nodes(struct device *dev,
> >> 
> >> 		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> >> 		if (!isd) {
> >> -			of_node_put(node);
> > 
> > I don't think this one is correct. Looking at the context
> > 
> >        while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
> >               (node = of_graph_get_next_endpoint(dev->of_node, node))) {
> >                struct isp_async_subdev *isd;
> >                
> >                isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> >                if (!isd) {
> >                        of_node_put(node);
> >                        return -ENOMEM;
> >                }
> >                
> >                notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> >                
> >                if (isp_of_parse_node(dev, node, isd)) {
> >                        of_node_put(node);
> >                        return -EINVAL;
> >                }
> > 		
> > 		isd->asd.match.of.node =
> > 			of_graph_get_remote_port_parent(node);
> >                of_node_put(node);
> >                
> >                if (!isd->asd.match.of.node) {
> >                        dev_warn(dev, "bad remote port parent\n");
> >                        return -EINVAL;
> >                }
> >                
> >                isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> >                notifier->num_subdevs++;
> >        }
> > 
> > of_graph_get_next_endpoint() increases the reference count of the node it
> > returns, which needs a corresponding of_node_put() in the error paths. It
> > thus look like to me that the function isn't correct in that the
> > devm_kzalloc() and !isd->asd.match.of.node error paths.
> 
> Ah ok, the of_node_put() is not always wrong.
> 
> >> 			return -ENOMEM;
> >> 		}
> >> 
> >> @@ -2126,7 +2125,7 @@ static int isp_of_parse_nodes(struct device *dev,
> >> 		}
> >> 		
> >> 		isd->asd.match.of.node =
> >> of_graph_get_remote_port_parent(node);
> >> -		of_node_put(node);
> >> +
> > 
> > This change is correct not because of_graph_get_next_endpoint() has called
> > of_node_put() but because it *will* call it on the next iteration.
> > 
> > How about the following patch instead ?
> > 
> > commit 4ed9893bf52c90181c8d5b1ae29a37556b89f1da
> > Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Date:   Thu Sep 29 11:41:24 2016 +0300
> > 
> >    omap3isp: Fix OF node double put when parsing OF graph
> >    
> >    When parsing the graph the driver loops over all endpoints using
> >    of_graph_get_next_endpoint(). The function handles reference counting
> >    of the passed and returned nodes, so the returned node's reference
> >    count must not be decreased manually in the normal path.
> >    
> >    Move the offending of_node_put() call to the error path that requires
> >    manual reference count handling.
> >    
> >    Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
> >    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 5e212668f726..f8b437cc8943
> > 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2131,23 +2131,18 @@ static int isp_of_parse_nodes(struct device *dev,
> > 		struct isp_async_subdev *isd;
> > 		
> > 		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> > -		if (!isd) {
> > -			of_node_put(node);
> > -			return -ENOMEM;
> > -		}
> > +		if (!isd)
> > +			goto error;
> > 
> > 		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> > 
> > -		if (isp_of_parse_node(dev, node, isd)) {
> > -			of_node_put(node);
> > -			return -EINVAL;
> > -		}
> > +		if (isp_of_parse_node(dev, node, isd))
> > +			goto error;
> > 
> > 		isd->asd.match.of.node =
> > of_graph_get_remote_port_parent(node);
> > -		of_node_put(node);
> > 		if (!isd->asd.match.of.node) {
> > 			dev_warn(dev, "bad remote port parent\n");
> > -			return -EINVAL;
> > +			goto error;
> > 		}
> > 		
> > 		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> > @@ -2155,6 +2150,10 @@ static int isp_of_parse_nodes(struct device *dev,
> > 	}
> > 	
> > 	return notifier->num_subdevs;
> > +
> > +error:
> > +	of_node_put(node);
> > +	return -EINVAL;
> > }
> > 
> > static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
> 
> Seems to fix the reported warning, but obviously I can't test the error
> paths.

Can I add

Tested-by: H. Nikolaus Schaller <hns@goldelico.com>

to the patch ?

> So let's go this way (until someone shows a bug in the error path).

-- 
Regards,

Laurent Pinchart

