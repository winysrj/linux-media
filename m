Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:17632 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504339AbeKWXTY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 18:19:24 -0500
Date: Fri, 23 Nov 2018 14:35:18 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: 'bad remote port parent' warnings
Message-ID: <20181123123518.k753f6wclbq4bf3e@kekkonen.localdomain>
References: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
 <1542904065.16720.2.camel@pengutronix.de>
 <CAOMZO5CRWC1qbYa3wAYfd+_ig0s9Bq2Z8Hz1SmM95Zuxb6LqRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CRWC1qbYa3wAYfd+_ig0s9Bq2Z8Hz1SmM95Zuxb6LqRw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio, Philipp,

On Thu, Nov 22, 2018 at 05:17:44PM -0200, Fabio Estevam wrote:
> Hi Philipp,
> 
> On Thu, Nov 22, 2018 at 2:27 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
> > There are empty endpoint nodes (without remote-endpoint property)
> > labeled ipu1_csi[01]_mux_from_parallel_sensor in the i.MX6 device trees
> > for board DT implementers' convenience. See commit 2539f517acbdc ("ARM:
> > dts: imx6qdl: Add video multiplexers, mipi_csi, and their connections").
> >
> > We had a discussion about this issue in February when this caused a
> > probing error: https://patchwork.kernel.org/patch/10234469/
> 
> Thanks for the clarification.
> 
>  We could demote the warning to a debug message, make the wording a bit
> > less misleading (there is no bad remote port parent, there is just no
> > remote endpoint at all), or we could just accept the error message for
> 
> Something like this?
> 
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -613,7 +613,7 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct
> device *dev,
>         asd->match.fwnode =
>                 fwnode_graph_get_remote_port_parent(endpoint);
>         if (!asd->match.fwnode) {
> -               dev_warn(dev, "bad remote port parent\n");
> +               dev_dbg(dev, "no remote endpoint found\n");

Makes sense. This is not necessarily a fatal error. Could you send a patch?

>                 ret = -ENOTCONN;
>                 goto out_err;
>         }
> 
> And how should we treat these error probes?
> 
> [    3.449564] imx-ipuv3 2400000.ipu: driver could not parse
> port@1/endpoint@0 (-22)
> [    3.457342] imx-ipuv3-csi: probe of imx-ipuv3-csi.1 failed with error -22
> [    3.464498] imx-ipuv3 2800000.ipu: driver could not parse
> port@0/endpoint@0 (-22)
> [    3.472120] imx-ipuv3-csi: probe of imx-ipuv3-csi.4 failed with error -22

I'm not sure if this is a real problem, I presume it's just that the device
has nothing connected to it, and so cannot work. Steve probably has a
better understanding of this, I'm just guessing here. :-)

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
